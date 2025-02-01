#!/bin/bash

naive_rule() {
    find . -type f -path "./$1" -exec sh -c 'diff -u "$0" <(sed -E "$1" "$0")' {} "$2" \;
}
debug_rule() {
    echo "🔍Searching $1"
    found_files=$(find . -type f -path "./$1")

    if [[ -z "$found_files" ]]; then
        echo "⚠️ No files found for pattern: $1"
        return
    fi

    echo "📄Found"
    echo "$found_files"

    for file in $found_files; do
        echo "✏️Matching in $file"

        # Extract move name or match pattern from sed substitution
        if [[ "$2" =~ ^s/ ]]; then
            match_word=$(echo "$2" | sed -E 's/^s\/\(([^,]+),.*\).*$/\1/')
        elif [[ "$2" =~ ^/ ]]; then
            match_word=$(echo "$2" | sed -E 's/^\/([^\/]+)\/.*/\1/')
        else
            match_word=$2
        fi

        if [[ -z "$match_word" || "$match_word" == "$2" ]]; then
            echo "⚠️ Could not extract a valid match pattern from: $2"
            continue
        fi

        match_count=$(grep -Ec "$match_word" "$file")

        if [[ "$match_count" -eq 0 ]]; then
            echo "❌ No matching lines found for move: $match_word in $file"
            continue
        fi

        echo "✅Matched $match_count lines for $match_word"
        diff -u "$file" <(sed -E "$2" "$file")
    done
}

DRY_RUN=true
[[ "$1" == "--not-dry" ]] && DRY_RUN=false

declare -A RULES
apply() {
    for file in "${!RULES[@]}"; do
        [[ -f "$file" ]] || { echo "⚠️ File not found: $file"; continue; }
        if $DRY_RUN; then
            diff -u "$file" <(echo -e "${RULES[$file]}" | sed -E -f - "$file")
        else
            echo "not dry run logic here"
            #echo -e "${RULES[$file]}" | sed -E -f - -i "$file"
        fi
    done
}
rule() { RULES["$1"]+="$2"$'\n'; }

# ✅ Use `/MATCH/s/OLD/NEW/g` when it's safe to replace all occurrences in the line
rule "moves/moves.asm" "/STRUGGLE/s/TYPELESS/NO_TYPE/g"

# ✅ Use direct substitution for unique type changes
rule "moves/moves.asm" "s/(PAY_DAY,.*)NORMAL/\1POISON/"
rule "moves/moves.asm" "s/(BITE,.*)DARK/\1NORMAL/"

apply

#s/db FAIRY, FAIRY/db NORMAL, NORMAL/g
#s/db NORMAL, FAIRY/db NORMAL, NORMAL/g
#s/db FAIRY, NORMAL/db NORMAL, NORMAL/g
#s/db DARK, DARK/db POISON, POISON/g
#s/db WATER, DARK/db WATER, DRAGON/g
