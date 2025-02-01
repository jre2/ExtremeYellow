#!/bin/bash

DRY_RUN=true
[[ "$1" == "--not-dry" ]] && DRY_RUN=false

declare -A RULES
apply() {
    for file in "${!RULES[@]}"; do
        [[ -f "$file" ]] || { echo "⚠️ File not found: $file"; continue; }
        if $DRY_RUN; then
            diff --color=auto -u "$file" <(echo -e "${RULES[$file]}" | sed -E -f - "$file")
        else
            echo "not dry run logic here"
            #echo -e "${RULES[$file]}" | sed -E -f - -i "$file"
        fi
    done
}
rule() {
    #a. simple system with no wildcard support
    #RULES["$1"]+="$2"$'\n';
    #b. wildcard version with blacklist for preExcel dir
    local files
    mapfile -t files < <(find . -type f -path "./$1" 2>/dev/null | grep -v "preExcel")
    for file in "${files[@]}"; do
        RULES["$file"]+="$2"$'\n';
    done
}
rule_move() { rule "moves/moves.asm" "$1"; }
rule_mon() { rule "pokemon/base_stats/$1.asm" "$2"; }

# Usage: run with --not-dry to actually execute instead of geting a unified diff
    # ✅ Use `/MATCH/s/OLD/NEW/g` when it's safe to replace all occurrences in the line
    #rule "moves/moves.asm" "/STRUGGLE/s/TYPELESS/NO_TYPE/g"
    # ✅ Use direct substitution otherwise (eg. move name includes type to change)
    #rule_move "s/(STEEL_WING,.*)STEEL/\1FLYING/"

if true; then
# FAIRY
rule_move "/DRAININGKISS/s/FAIRY/GHOST/g"
rule_move "/PLAY_ROUGH/s/FAIRY/DRAGON/g"
rule_move "/MOONBLAST/s/FAIRY/PSYCHIC_TYPE/g"
rule_move "/CHARM/s/FAIRY/NORMAL/g"
# DARK
rule_move "/BITE|CRUNCH/s/DARK/NORMAL/g"
rule_move "/FEINT_ATTACK/s/DARK/BUG/g"
rule_move "/NIGHT_SLASH/s/DARK/GHOST/g"
#rule_move "/DARK_PULSE/s/DARK/GHOST/g"
rule_move "s/(DARK_PULSE,.*)DARK/\1GHOST/"
# STEEL
rule_move "/IRON_TAIL/s/STEEL/NORMAL/g"
rule_move "/METAL_CLAW|METEOR_MASH/s/STEEL/ROCK/g"
rule_move "/BULLET_PUNCH/s/STEEL/ELECTRIC/g"
rule_move "s/(STEEL_WING,.*)STEEL/\1FLYING/"
rule_move "/GYRO_BALL/s/STEEL/ROCK/g"
rule_move "/FLASH_CANNON/s/STEEL/NORMAL/g"

# FAIRY
rule_mon "clef*" "s/FAIRY, FAIRY/NORMAL, NORMAL/g"
rule_mon "*iggly*uff" "s/NORMAL, FAIRY/NORMAL, NORMAL/g"
rule_mon "*mime*" "s/PSYCHIC_TYPE, FAIRY/PSYCHIC_TYPE, PSYCHIC_TYPE/g"
rule_mon "sylveon" "s/FAIRY, FAIRY/DRAGON, DRAGON/g"
# DARK
rule_mon "mgyarados" "s/WATER, DARK/WATER, DRAGON/g"
rule_mon "umbreon" "s/DARK, DARK/POSION, POISON/g"
# STEEL
rule_mon "magne*" "s/ELECTRIC, STEEL/ELECTRIC, ELECTRIC/g"
rule_mon "*scizor" "s/BUG, STEEL/BUG, BUG/g"
rule_mon "*steelix" "s/STEEL, GROUND/ROCK, GROUND/g"
fi

apply
