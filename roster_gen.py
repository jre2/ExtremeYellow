#!/bin/python

import colorama
from   pprint import pprint
import re
import sys
from   termcolor import colored, cprint
colorama.just_fix_windows_console()

# Data Layout
# trainer_db :: TrainerClassID -> TrainerID -> { block_name:str, class:str, region:str, comment:str, id:int, pkmn: [ (level, name, moves[4]) ] }
USE_BANKED_DATA = True

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

        # Skip banked data pointer and section info
        if line.startswith( 'SECTION' ): continue
        if line[:3] == 'dba': continue

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
    if USE_BANKED_DATA:
        buf += '\ttable_width 3\n'
    else:
        buf += '\ttable_width 2\n'
    for block_data_label in trainer_data_label_to_class:
        if USE_BANKED_DATA:
            buf += f'\tdba {block_data_label}\n'
        else:
            buf += f'\tdw {block_data_label}\n'
    buf += '\tassert_table_length NUM_TRAINERS\n\n'
    
    # Trainer blocks
    for block_num, block_data_label in enumerate( trainer_data_label_to_class ):
        if USE_BANKED_DATA:
            buf += f'SECTION "TrainerData{block_num}", ROMX\n'
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
    for lineno, line in enumerate( buf.split('\n') ):
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
            raise ValueError( f'Bad line #{lineno+1}: "{line}"' )
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
    for lineno, line in enumerate( buf.split('\n') ):
        if not line.strip() or line.startswith(';'): continue
        tclass = re.match( r'^(\w+)$', line )
        tid = re.match( r'^\s*(\d+)\s*(?:;\s*(.*))?$', line )
        tpkmn = re.match( r'\s*(\d+)\s+(\w+)\s*([\w\s]*)', line ) # like "  5 BULBASAUR TACKLE GROWL LEECHSEED None"
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
            trainer_comment = None
            if trainer_region is not None:
                parts = trainer_region.split(';')
                trainer_region = parts[0].strip()
                trainer_comment = parts[1].strip() if len(parts) > 1 else None
            #print( 'ID', trainer_id, trainer_region )
            trainer_data_block = trainer_class_to_data_label[ trainer_class ]
            assert trainer_data_block in trainer_data_label_to_class, f'Unknown trainer data block {trainer_data_block}'
            assert trainer_region is not None, f'Missing region for {trainer_class} {trainer_id}'
            #if trainer_region is None: print( f'Missing region for {trainer_class} {trainer_id}' )
            trainer_db[ trainer_class ][ trainer_id ] = { 'block_name':trainer_data_block, 'class':trainer_class, 'region':trainer_region, 'comment':trainer_comment, 'id':trainer_id, 'pkmn':[] }
        elif tpkmn:
            pkmn_lvl = int(tpkmn.group(1))
            pkmn_id = tpkmn.group(2)
            pkmn_moves = tpkmn.group(3).split()
            #print( f'  {pkmn_lvl} {pkmn_id} {pkmn_moves}. Line: {line}' )
            assert 0 < pkmn_lvl <= 250, f'Invalid level {pkmn_lvl}'
            assert pkmn_id in legal_pokemon_ids, f'Unknown pokemon {pkmn_id}'
            assert len(pkmn_moves) <= 4, f'Too many moves {pkmn_moves}'
            # take the 0-4 moves in pkmn_moves and convert to fixed length (4) list with None for missing moves, also unstringify "None"
            pkmn_moves = [ move if move != 'None' else None for move in pkmn_moves ] + [None]*(4-len(pkmn_moves))
            # verify moves are legal
            for move in pkmn_moves:
                if move is not None:
                    assert move in legal_move_ids, f'Unknown move {move}'
            trainer_db[ trainer_class ][ trainer_id ]['pkmn'].append( [ pkmn_lvl, pkmn_id, pkmn_moves ] )
        else:
            raise ValueError( f'Bad line #{lineno+1}: "{line}"' )
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
            # Comment
            if trainer['comment']:
                buf += f' ; {trainer["comment"]}'
            buf += '\n'
            for lvl, pkmn_id, moves in trainer['pkmn']:
                depth = 2
                # remove Nones at the end of the move list, but preserve any that occur before a non-None entry
                while moves and moves[-1] is None: moves.pop()
                smoves = ' '.join( str(move) for move in moves )
                # have a space between pokemon id and moves but only if there are moves
                if moves: smoves = ' ' + smoves
                buf += f'{indenter*depth}{lvl} {pkmn_id}{smoves}\n'
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
    save_parties_asm( 'data/trainers/parties.asm', db )
    save_special_moves_asm( 'data/trainers/special_moves.asm', db )

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
            new.pop( 'comment' ) # asm doesn't have comments
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
                        print( f"    - {printmon(old_mon, columns_changed, 'red')}" )
                        print( f"    + {printmon(new_mon, columns_changed, 'green')}" )

import json
import matplotlib.pyplot as plt
import numpy as np
import scipy.signal
from   sklearn.cluster import KMeans

def save_json( path, db ):
    with open( path, 'w' ) as f: json.dump( db, f )

def kmeans_level_clusters(levels, num_clusters=5):
    """Use K-Means to cluster trainer levels into difficulty tiers."""
    levels_reshaped = np.array(levels).reshape(-1, 1)
    kmeans = KMeans(n_clusters=num_clusters, n_init=10, random_state=42)
    clusters = kmeans.fit_predict(levels_reshaped)
    cluster_centers = sorted(kmeans.cluster_centers_.flatten())
    return clusters, cluster_centers

def dev():
    db = load_db_from_human( 'data/trainers/trainers.human' )
    #save_json( 'data/trainers/trainers.json', db )
    trainers = sum( [ list(tclass.values()) for tclass in db.values() ], [] )
    #comments = sorted(set( [ t['comment'] or 'None' for t in trainers ] ))
    #regions = sorted(set( [ t['region'] for t in trainers ] ))

    # For level calculation analysis, we ignore "Boss" type characters
    elite_four = [ 'LORELEI', 'BRUNO', 'AGATHA', 'LANCE' ]
    gym_leaders = [ 'BROCK', 'MISTY', 'LT_SURGE', 'ERIKA', 'KOGA', 'BLAINE', 'SABRINA', 'GIOVANNI' ]
    other_bosses = [ 'RIVAL1', 'RIVAL2', 'RIVAL3', 'PROF_OAK', 'GIOVANNI', 'ROCKET', 'ORAGE', 'PIGEON', 'TRAVELER', 'BF_TRAINER', 'MISSINGNO_T' ]
    blacklisted_trainers = elite_four + gym_leaders + other_bosses

    # We also ignore certain regions
    blacklisted_regions = [ 'Post-game', 'Unused' ]

    # Generate a list of non-blacklisted trainers and track their region and average pokemon level
    non_blacklisted_trainer_data = [
        t for t in trainers
        if t['region'] not in blacklisted_regions
        #and 'Gym' not in t['region'] #HACK extra blacklist
        and t['class'] not in blacklisted_trainers
    ]

    # Reorganize data
    region_to_trainers = {} # :: Region -> [ Trainer{ class, id, lvl } ]
    region_full_stats = {} # :: Region -> { num_trainers, min_level, max_level, avg_level, std_dev }
    region_level = {} # :: Region -> AvgLevel

    for trainer in non_blacklisted_trainer_data:
        # remove outlier pokemon
        pokemon = trainer['pkmn']
        pokemon = [ p for p in pokemon if 6 <= p[0] <= 60 ]
        if not pokemon: continue
        # calculate average level
        pokemon_levels = [ p[0] for p in pokemon ]
        average_level = sum(pokemon_levels) / len(pokemon_levels)
        # add to region
        region = trainer['region']
        if region not in region_to_trainers: region_to_trainers[region] = []
        region_to_trainers[region].append( { 'class':trainer['class'], 'id':trainer['id'], 'lvl':average_level } )
    #pprint( region_to_trainers )

    # Calculate region stats
    for region, trainers in region_to_trainers.items():
        levels = [trainer['lvl'] for trainer in trainers]
        region_full_stats[region] = {
            'len': len(trainers),
            'min': min(levels),
            'max': max(levels),
            'mean': np.mean(levels),
            'std': np.std(levels)
        }
    #pprint(region_full_stats)

    # Cull anything with std dev worse than 7
    region_full_stats = { region:stats for region, stats in region_full_stats.items() if stats['std'] < 5 }

    # Calculate average level for each region
    for region, stats in region_full_stats.items():
        region_level[region] = stats['mean']
    #pprint(region_level)

    # Print LVL (stddev) + Region pairs, sorted by average level
    for region, stats in sorted( region_full_stats.items(), key=lambda x: x[1]['mean'] ):
        pass
        #print( f'{stats["mean"]:5.1f} ({stats["std"]:5.1f}) {region}' )
    
    # Analysis
    levels = [ stats['mean'] for stats in region_full_stats.values() ]
    #levels.sort()
    #print( levels )
    peaks = scipy.signal.find_peaks( levels, prominence=4 )
    #print( peaks )
    clusters, cluster_centers = kmeans_level_clusters( levels, num_clusters=8 )
    #print( clusters )
    #print( cluster_centers )

    # Assign estimated caps based on the nearest cluster center
    badge_based_caps = [ 11, 21, 28, 32, 43, 50, 54, 55, 65 ]
    region_expected_caps = {}
    for region, avg_level in region_level.items():
        closest_cluster = min(cluster_centers, key=lambda x: abs(x - avg_level))
        closest_cap = min(badge_based_caps, key=lambda x: abs(x - avg_level))
        badge = badge_based_caps.index( closest_cap )
        region_expected_caps[region] = {'cluster':closest_cluster, 'badge_cap':closest_cap, 'badge':badge }
    pprint(region_expected_caps)

    # Print regions by badge
    for badge in range(9):
        print( f'Badge {badge}' )
        for region, stats in sorted( region_expected_caps.items(), key=lambda x: x[1]['badge'] ):
            if stats['badge'] == badge:
                print( f'  {stats["badge_cap"]:2} {region}' )

    plt.figure( figsize=(10, 5) )
    # make the y axis more detailed
    #plt.yticks( np.arange(5, 60, 1) )
    plt.yticks( cluster_centers )
    plt.plot( levels, label='Trainer Levels', marker='o' )
    #plt.scatter([p for p in peaks if p < len(levels)], [levels[p] for p in peaks if p < len(levels)], color='red', label='Peaks')
    plt.scatter([p for p in peaks if isinstance(p, int) and p < len(levels)], [levels[p] for p in peaks if isinstance(p, int) and p < len(levels)], color='red', label='Peaks')
    #plt.scatter(peaks, [levels[p] for p in peaks], color='red', label='Peaks')
    for c in cluster_centers:
        plt.axhline( y=c, linestyle='--', color='gray', alpha=0.7, label=f'Cluster {c:.1f}' )
    plt.xlabel( 'Region index' )
    plt.ylabel( 'Average Trainer Level' )
    plt.legend()
    plt.show()

# Perform tasks based on arguments
options = ['--help','--diff','--dev', '--generate-human','--generate-asm','--tests','--debug','--no-banks']
def print_usage():
    print( f"Usage: {' '.join(options)}" )

if '--help' in sys.argv or any( arg not in options for arg in sys.argv[1:] ):
    print_usage()
    sys.exit(0)
if '--no-banks' in sys.argv:
    USE_BANKED_DATA = False
if '--tests' in sys.argv:
    test_asm_serialization()
    test_human_serialization()
elif '--dev' in sys.argv:
    dev()
elif '--diff' in sys.argv:
    print( 'Diff...' )
    generate_diff()
elif '--generate-human' in sys.argv:
    print( 'Generating trainers.human...' )
    generate_human_from_asm()
elif '--generate-asm' in sys.argv:
    print( 'Generating parties.asm and special_moves.asm...' )
    generate_asm_from_human()
elif '--debug' in sys.argv:
    pprint( load_db_from_human( 'data/trainers/trainers.human' )['YOUNGSTER'][1] ) #for debug
else:
    print_usage()
