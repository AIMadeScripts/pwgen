#!/bin/bash

while getopts ":l:p:L:" opt; do
  case $opt in
    l) length="$OPTARG" ;;
    p) pattern="$OPTARG" ;;
    L) letters="$OPTARG" ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
  esac
done

lengthassymbols=$(printf "@%.0s" $(seq 1 $length))

if [[ -z $pattern ]]; then
    crunch $length $length -f charset.lst.1 mixalpha-numeric-all-space -t "$lengthassymbols"
else
    if [[ -z $letters ]]; then
        pattern_len=${#pattern}
        pattern_symbols=$(printf "@%.0s" $(seq 1 $((length-pattern_len))))
        pt=$(echo $pattern_symbols | sed 's/./& /g')
        justpattern=$(echo crunch $length $length -p "$pattern $pt")
        $justpattern  | sort | uniq > temporary.txt
    else
        pattern_len=${#pattern}
        letters2=$(echo $letters | sed 's/,//g')
        letter_len=${#letters2}
        pattern_symbols=$(printf "@%.0s" $(seq 1 $((length-pattern_len-letter_len))))
        pt=$(echo $pattern_symbols | sed 's/./& /g')
        lettersspace=$(echo $letters | sed 's/,/ /g')
        justpattern=$(echo crunch $length $length -p "$pattern $pt $lettersspace")
        $justpattern  | sort | uniq > temporary.txt
        clear
        wordcount=$(wc temporary.txt | awk '{print $2}')
        cat temporary.txt | while IFS= read -r line; do echo "Generating all possible permutations from the given information into output.txt $wordcount x number of lines crunch shows should give you an estimate"; crunch $length $length -f charset.lst.1 mixalpha-numeric-all-space -t "$line"; done
     fi
fi
