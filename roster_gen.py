import colorama
from   pprint import pprint
import re
from   termcolor import colored, cprint
colorama.just_fix_windows_console()

# Data Layout
# trainer_db :: TrainerClassID -> TrainerID -> { block_name:str, class:str, region:str, id:int, pkmn: [ (level, name, moves[4]) ] }

# Constants
def load_constants_asm( path, def_keyword='const' ):
    enums = []
    for line in open( path ).read().split('\n'):
        active = line.split(';')[0].strip() # only look at uncommented part of the line
        m = re.match( fr'^{def_keyword}\s+(\w+)', active )
        if m: enums.append( m.group(1).strip() )
    return enums # first entry is always a sentinel for invalid value but we sometimes use it, so keep them in

# Most enums we can parse from the code
legal_move_ids = load_constants_asm( 'constants/move_constants.asm' )
legal_pokemon_ids = load_constants_asm( 'constants/pokemon_constants.asm' )[1:]
legal_trainer_class_ids = load_constants_asm( 'constants/trainer_constants.asm', 'trainer_const' )[1:]
assert len(legal_move_ids) > 75, 'Too few moves'
assert len(legal_pokemon_ids) > 150, 'Too few pokemon'
assert len(legal_trainer_class_ids) > 30, 'Too few trainers'

# Trainer rosters are stored by data label and then ordered trainer id in parties.asm but trainer class is used for special_moves.asm, so create bidirectional lookups
trainer_data_label_to_class = { 'YoungsterData':'YOUNGSTER', 'BugCatcherData':'BUG_CATCHER', 'LassData':'LASS', 'SailorData':'SAILOR', 'JrTrainerFData':'JR_TRAINER', 'PokemaniacData':'POKEMANIAC', 'SuperNerdData':'SUPER_NERD', 'HikerData':'HIKER', 'BikerData':'BIKER', 'BurglarData':'BURGLAR', 'EngineerData':'ENGINEER', 'FisherData':'FISHER', 'SwimmerData':'SWIMMER', 'CueBallData':'CUE_BALL', 'GamblerData':'GAMBLER', 'BeautyData':'BEAUTY', 'PsychicData':'PSYCHIC_TR', 'RockerData':'ROCKER', 'JugglerData':'JUGGLER', 'TamerData':'TAMER', 'BirdKeeperData':'BIRD_KEEPER', 'BlackbeltData':'BLACKBELT', 'Rival1Data':'RIVAL1', 'ProfOakData':'PROF_OAK', 'ScientistData':'SCIENTIST', 'GiovanniData':'GIOVANNI', 'RocketData':'ROCKET', 'CooltrainerData':'COOLTRAINER', 'BrunoData':'BRUNO', 'BrockData':'BROCK', 'MistyData':'MISTY', 'LtSurgeData':'LT_SURGE', 'ErikaData':'ERIKA', 'KogaData':'KOGA', 'BlaineData':'BLAINE', 'SabrinaData':'SABRINA', 'GentlemanData':'GENTLEMAN', 'Rival2Data':'RIVAL2', 'Rival3Data':'RIVAL3', 'LoreleiData':'LORELEI', 'ChannelerData':'CHANNELER', 'AgathaData':'AGATHA', 'LanceData':'LANCE', 'OrageData':'ORAGE', 'PigeonData':'PIGEON', 'TravelerData':'TRAVELER', 'BFTrainerData':'BF_TRAINER', 'MissingNoTData':'MISSINGNO_T' }
trainer_class_to_data_label = { v:k for k,v in trainer_data_label_to_class.items() }
assert set( trainer_class_to_data_label.keys() ) == set( legal_trainer_class_ids ), 'Mismatch between trainer data label <> class lookups and known trainer class enums'
#trainer_class_ids_disabled = ['JR_TRAINER_M', 'UNUSED_JUGGLER', 'CHIEF', 'COOLTRAINER_M']
#trainer_data_labels_disabled = ['JrTrainerMData', 'UnusedJugglerData', 'ChiefData', 'CooltrainerMData']

# ASM code serialization
def load_parties_asm( path ):
    buf = open( path ).read()

    block_num = 0 # 0 preamble, 1 YoungsterData, 2 BugCatcherData, 3 LassData, etc
    block_data_label = None
    block_trainer_class = None
    cur_trainer_region = None
    cur_trainer_id = None

    trainer_db = {} # :: TrainerClassID -> TrainerID -> { block_name:str, class:str, region:str, id:int, pkmn: [ (level, name, moves[4]) ] }

    for lineno, line in enumerate( buf.split('\n') ):
        if not line: continue
        # New blocks start with a line like "YoungsterData:"
        if line[0].isupper() and line[-1] == ':':
            block_num += 1
            block_data_label = line[:-1]
            if block_num > 1:
                assert block_data_label in trainer_data_label_to_class, f'Unknown trainer data {block_data_label}'
                block_trainer_class = trainer_data_label_to_class[ block_data_label ]
                assert block_trainer_class in legal_trainer_class_ids, f'Unknown trainer class {block_trainer_class}'
            else: block_trainer_class = None

            cur_trainer_region = None
            cur_trainer_id = 0

        # Ignore non-significant whitespace
        line = line.strip()

        # comment at start of line denotes trainer region
        if line[0] == ';':
            cur_trainer_region = line[1:].strip()
        
        # db at start of line denotes trainer data
        if line[:2] == 'db':
            line = line.split(';')[0] # remove comments

            cur_trainer_id += 1
            trainer = { 'block_name':block_data_label, 'class': block_trainer_class, 'region': cur_trainer_region, 'id': cur_trainer_id, 'pkmn':[] }

            # trainer data takes two forms
            # db pkmn_level, pkmn_name, pkmn_name, ..., 0
            # db $FF, pkmn_level, pkmn_name, pkmn_level, pkmn_name, ..., 0
            xs = [ tok.strip() for tok in line[2:].split(',') ]
            assert xs[-1] == '0', f'No null termination for {str(xs)}'
            if xs[0] == '$FF':
                assert len(xs) % 2 == 0, 'Need matching pairs of level and name'
                num_pkmn = ( len(xs)-2 )//2
                assert 1 <= num_pkmn <= 6, 'Need 1..6 pokemon'
                for i in range( num_pkmn ):
                    pkmn_level = int(xs[2*i +1])
                    pkmn_name = xs[2*i +2]
                    assert pkmn_name in legal_pokemon_ids, f'Unknown pokemon {pkmn_name}'
                    trainer['pkmn'].append( [ pkmn_level, pkmn_name, [None,None,None,None] ] )
            else:
                pkmn_level = int(xs[0])
                for pkmn_name in xs[1:-1]:
                    assert pkmn_name in legal_pokemon_ids, f'Unknown pokemon {pkmn_name}'
                    trainer['pkmn'].append( [ pkmn_level, pkmn_name, [None,None,None,None] ] )
            
            # Add trainer to DB
            if trainer['class'] not in trainer_db: trainer_db[ trainer['class'] ] = {}
            trainer_db[ trainer['class'] ][ trainer['id'] ] = trainer
    return trainer_db

def save_parties_asm( path, trainer_db ):
    buf = ''
    # Preamble
    buf += 'TrainerDataPointers:\n'
    for block_data_label in trainer_data_label_to_class:
        buf += f'\tdw {block_data_label}\n'
    
    # Trainer blocks
    for block_data_label in trainer_data_label_to_class:
        buf += f'{block_data_label}:\n'

        block_trainer_class = trainer_data_label_to_class[block_data_label]
        cur_trainer_region = None
        trainers_for_data_block_db = trainer_db[ block_trainer_class ]
        trainers_ordered = sorted( trainers_for_data_block_db.values(), key=lambda t: t['id'] )
        for trainer in trainers_ordered:
            # mark Region if it has changed
            if trainer['region'] != cur_trainer_region:
                cur_trainer_region = trainer['region']
                buf += f'; {cur_trainer_region}\n'
            
            if len(set([ lvl for lvl, name, moves in trainer['pkmn'] ])) == 1:
                # entry with pokemon of all same level
                level = trainer['pkmn'][0][0]
                buf += f'\tdb {level}, '
                for level, name, moves in trainer['pkmn']:
                    buf += f'{name}, '
                buf += '0\n'
            else:
                # entry with pokemon of varying levels
                buf += f'\tdb $FF, '
                for level, name, moves in trainer['pkmn']:
                    buf += f'{level}, {name}, '
                buf += '0\n'
    with open( path, 'w' ) as f: f.write( buf )
    return buf

def load_special_moves_asm( path, trainer_db ):
    buf = open( path ).read()
    buf = buf.split( 'SpecialTrainerMoves:\n' )[1].split('db -1')[0]

    cur_trainer_class = None
    cur_trainer_id = None
    cur_pokemon_id = None
    for line in buf.split('\n'):
        if line and line[0] == ';': continue # full line non-indented comments are disabled code
        line = line.strip()
        if not line: continue

        # full line but indented comments denote pokemon ids (only for reference but we'll check them for now)
        if line[0] == ';':
            cur_pokemon_id = line[1:].strip()
            # only check name for numbered entries like "Gengar 1"
            cur_pokemon_id = cur_pokemon_id.split()[0]
            # skip some specific comments that don't fit pattern
            if cur_pokemon_id not in ['lol']:
                assert cur_pokemon_id in legal_pokemon_ids, f'Unknown pokemon {cur_pokemon_id}'
            continue
        
        # Start of new trainer block fits pattern "db TrainerClassID, TrainerID"
        # End of block is "db $FE"
        # Move replacement data fits pattern "db PokemonIndex, MoveIndex, MoveID"
        start = re.match( r'db ([A-Z_]+[0-9]*), (\d+)', line )
        move = re.match( r'db (\d+), (\d+), (\w+)', line )
        end = re.match( r'db \$FE', line )
        if start:
            cur_trainer_class = start.group(1)
            assert cur_trainer_class in legal_trainer_class_ids, f'Unknown trainer class {cur_trainer_class}'
            cur_trainer_id = int(start.group(2))
            assert cur_trainer_id in trainer_db[ cur_trainer_class ], f'Unknown trainer id {cur_trainer_id} for trainer class {cur_trainer_class}'
            cur_pokemon_id = None
            #print( 'START', cur_trainer_class, cur_trainer_id )
        elif end:
            cur_trainer_class = None
            cur_trainer_id = None
            cur_pokemon_id = None
            #print( 'END' )
        elif move:
            pkmn_idx = int(move.group(1))
            move_idx = int(move.group(2))
            move_id = move.group(3)
            #print( '  MOVE', cur_trainer_class, cur_trainer_id, cur_pokemon_id, pkmn_idx, move_idx, move_id )

            # skip some specific errors in upstream until they patch
            #if (cur_trainer_class, cur_trainer_id) not in [ ('COOLTRAINER',44), ('BROCK',7),('BROCK',8),('BROCK',9), ('LT_SURGE',1),('LT_SURGE',2), ('BRUNO',1),('BRUNO',2), ('RIVAL2',2) ]:
            if 1:
                db_roster = trainer_db[ cur_trainer_class ][ cur_trainer_id ]['pkmn']
                db_pokemon_id = db_roster[pkmn_idx-1][1]
                db_move_id = db_roster[pkmn_idx-1][2][move_idx-1]
                entry_info = f'Entry: tClass {cur_trainer_class} tID {cur_trainer_id} pkmnIdx {pkmn_idx} moveIdx {move_idx} moveID {move_id}'

                # Setting a move slot we already set is an indicator of bad data
                assert db_move_id is None, f'Move overwriting {db_move_id} with {move_id}. {entry_info}'

                # Check that the optional pokemon id comment matches the pokemon id in the party data
                assert cur_pokemon_id is None or cur_pokemon_id == db_pokemon_id, f'Move pokemon comment mismatch. {cur_pokemon_id} != {db_pokemon_id}. {entry_info}. DB {db_roster}'
                
                # Require pokemon id comment
                assert cur_pokemon_id is not None, f'Missing pokemon id comment. Lookup suggests {db_pokemon_id}. {entry_info}'

                # Check that the move id is valid
                assert move_id in legal_move_ids, f'Unknown move {move_id}. {entry_info}'
            
            # Actually update the trainer's database entry
            trainer_db[ cur_trainer_class ][ cur_trainer_id ]['pkmn'][pkmn_idx-1][2][move_idx-1] = move_id
        else:
            raise ValueError( f'Bad line {line}' )
    return trainer_db

def save_special_moves_asm( path, trainer_db ):
    buf = ''
    buf += 'SpecialTrainerMoves:\n'
    for trainer_class in trainer_db:
        for trainer_id in trainer_db[trainer_class]:
            trainer = trainer_db[trainer_class][trainer_id]

            trainer_entry = ''
            for pkmn_idx, (lvl, pkmn_id, moves) in enumerate( trainer['pkmn'] ):
                pkmn_entry = ''
                for move_idx, move_id in enumerate( moves ):
                    if move_id is not None:
                        pkmn_entry += f'\tdb {pkmn_idx+1}, {move_idx+1}, {move_id}\n'
                if pkmn_entry:
                    pkmn_entry = f'\t; {pkmn_id}\n' + pkmn_entry
                    trainer_entry += pkmn_entry
            if trainer_entry:
                trainer_entry = f'\tdb {trainer_class}, {trainer_id}\n' + trainer_entry + '\tdb $FE\n\n'
                buf += trainer_entry

    buf += 'db -1\n'
    with open( path, 'w' ) as f: f.write( buf )
    return buf

# Human read/writable format serialization
def load_db_from_human( path ):
    trainer_db = {}
    trainer_class = None
    trainer_id = None
    trainer_region = None

    buf = open( path ).read()
    for line in buf.split('\n'):
        if not line or line.startswith(';'): continue
        tclass = re.match( r'^(\w+)$', line )
        tid = re.match( r'^\s*(\d+)\s*(?:;\s*(.*))?$', line )
        tpkmn = re.match( r'^\s*(\d+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)$', line ) # like "  5 BULBASAUR TACKLE GROWL LEECHSEED None"
        if tclass:
            trainer_class = tclass.group(1)
            assert trainer_class in legal_trainer_class_ids, f'Unknown trainer class {trainer_class}'
            trainer_id = None
            trainer_region = None
            trainer_db[ trainer_class ] = {}
            #print( 'CLASS', trainer_class )
        elif tid:
            trainer_id = int(tid.group(1))
            trainer_region = (tid.group(2) if tid.group(2) != 'None' else None) or trainer_region
            #print( 'ID', trainer_id, trainer_region )
            trainer_data_block = trainer_class_to_data_label[ trainer_class ]
            assert trainer_data_block in trainer_data_label_to_class, f'Unknown trainer data block {trainer_data_block}'
            trainer_db[ trainer_class ][ trainer_id ] = { 'block_name':trainer_data_block, 'class':trainer_class, 'region':trainer_region, 'id':trainer_id, 'pkmn':[] }
        elif tpkmn:
            pkmn_lvl = int(tpkmn.group(1))
            pkmn_id = tpkmn.group(2)
            assert pkmn_id in legal_pokemon_ids, f'Unknown pokemon {pkmn_id}'
            pkmn_moves = [ tpkmn.group(i) for i in range(3,7) ]
            pkmn_moves = [ move if move != 'None' else None for move in pkmn_moves ] # unstringify 'None'
            # Check that the moves are valid
            for move_id in pkmn_moves:
                if move_id is not None:
                    assert move_id in legal_move_ids, f'Unknown move {move_id}'
            #print( 'PKMN', pkmn_lvl, pkmn_id, pkmn_moves )
            trainer_db[ trainer_class ][ trainer_id ]['pkmn'].append( [ pkmn_lvl, pkmn_id, pkmn_moves ] )
        else:
            raise ValueError( f'Bad line {line}' )
    return trainer_db

def save_db_to_human( path, trainer_db, skip_repeat_region=True, indenter='    ' ):
    buf = ''
    # Enums for text editor completion aid
    buf += f'; TrainerClassIDs = {" ".join(legal_trainer_class_ids)}\n'
    buf += f'; PokemonIDs = {" ".join(legal_pokemon_ids)}\n'
    buf += f'; MoveIDs = {" ".join(legal_move_ids)}\n'
    buf += '\n'

    # Trainer data
    last_region = None
    for trainer_class in trainer_db:
        depth = 0
        buf += f'{indenter*depth}{trainer_class}\n'
        for trainer_id in trainer_db[trainer_class]:
            depth = 1
            trainer = trainer_db[trainer_class][trainer_id]

            buf += f'{indenter*depth}{trainer_id}'
            # Region marker
            if last_region != trainer['region'] or not skip_repeat_region:
                last_region = trainer['region']
                buf += f' ; {trainer["region"]}'
            buf += '\n'
            for lvl, pkmn_id, moves in trainer['pkmn']:
                depth = 2
                smoves = ' '.join( str(move) for move in moves )
                buf += f'{indenter*depth}{lvl} {pkmn_id} {smoves}\n'
                pass
    with open( path, 'w' ) as f: f.write( buf )
    return buf

# Tests
def test_asm_serialization():
    db = load_parties_asm( 'data/trainers/parties.asm' )
    db = load_special_moves_asm( 'data/trainers/special_moves.asm', db )
    save_parties_asm( '/tmp/test_parties.asm', db )
    save_special_moves_asm( '/tmp/test_special_moves.asm', db )
    db2 = load_parties_asm( '/tmp/test_parties.asm' )
    db2 = load_special_moves_asm( '/tmp/test_special_moves.asm', db2 )
    assert db == db2, 'Test ASM round trip failed'

def test_human_serialization():
    db = load_db_from_human( 'data/trainers/trainers.human' )
    save_db_to_human( '/tmp/test_trainers.human', db )
    db2 = load_db_from_human( '/tmp/test_trainers.human' )

    for trainer_class in db:
        for trainer_id in db[trainer_class]:
            if db[trainer_class][trainer_id] != db2[trainer_class][trainer_id]:
                print( db[ trainer_class ][ trainer_id ] )
                print( db2[ trainer_class ][ trainer_id ] )
            assert db[trainer_class][trainer_id] == db2[trainer_class][trainer_id], f'Test Human {trainer_class} {trainer_id} round trip failed'
    assert db == db2, 'Test Human round trip failed'

# Commands
def generate_human_from_asm():
    db = load_parties_asm( 'data/trainers/parties.asm' )
    db = load_special_moves_asm( 'data/trainers/special_moves.asm', db )
    save_db_to_human( 'data/trainers/trainers.human', db )

def generate_asm_from_human():
    db = load_db_from_human( 'data/trainers/trainers.human' )
    save_parties_asm( 'data/trainers/parties_new.asm', db )
    save_special_moves_asm( 'data/trainers/special_moves_new.asm', db )

def generate_diff():
    def printmon( mon, columns_changed, color ):
        # format like "  5 BULBASAUR TACKLE GROWL LEECHSEED None" but with fixed width spacing
        DNE = '-'*35 + ' DNE ' + '-'*35
        if mon is None:
            return colored( DNE, color ) if any( columns_changed ) else DNE
        values = [ f'{mon[0]:>3}', f'{mon[1]:<15}' ] + [ f'{str(mon[2][i]):<15}' for i in range(4) ]
        colored_values = [ colored( val, color ) if columns_changed[i] else val for i, val in enumerate(values) ]
        return ' '.join( val for val in colored_values )
    asm = load_parties_asm( 'data/trainers/parties.asm' )
    asm = load_special_moves_asm( 'data/trainers/special_moves.asm', asm )
    hum = load_db_from_human( 'data/trainers/trainers.human' )

    # We assume no changes to trainers themselves, so same classes and ids exist
    for trainer_class in asm:
        for trainer_id in asm[trainer_class]:
            old = asm[trainer_class][trainer_id]
            new = hum[trainer_class][trainer_id]
            if old != new:
                print( trainer_class, trainer_id )
                if old['region'] != new['region']:
                    cprint( f'  - {old["region"]}', 'red' )
                    cprint( f'  + {new["region"]}', 'green' )
                for pkmn_idx in range( 6 ):
                    old_mon = old['pkmn'][ pkmn_idx ] if len(old['pkmn']) > pkmn_idx else None
                    new_mon = new['pkmn'][ pkmn_idx ] if len(new['pkmn']) > pkmn_idx else None
                    columns_changed = [ old_mon[i] != new_mon[i] for i in range(2) ] + [ old_mon[2][i] != new_mon[2][i] for i in range(4) ] if old_mon is not None and new_mon is not None else [True]*6
                    if old_mon != new_mon:
                        print( f'    - {printmon(old_mon, columns_changed, 'red')}' )
                        print( f'    + {printmon(new_mon, columns_changed, 'green')}' )

test_asm_serialization()
test_human_serialization()
generate_diff()
#generate_human_from_asm()
#pprint( load_db_from_human( 'data/trainers/trainers.human' )['YOUNGSTER'][1] )