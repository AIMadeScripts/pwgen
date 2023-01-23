#!/bin/bash

echo "How long is the word:"
read length
echo "Do you know any pattern that must be in the word:"
read pattern
echo "Do you know any other letters that must be in the word (comma separated):"
read letters
clear
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
        cat temporary.txt | while IFS= read -r line; do echo "Generating all possible permutations from the given information into output.txt $wordcount x number of lines crunch shows should give you an estimate"; crunch $length $length -f charset.lst.1 mixalpha-numeric-all-space -t "$line" >> output_temp.txt; clear; done
        cat output_temp.txt | sort | uniq >> output.txt
        rm output_temp.txt
    fi
fi
