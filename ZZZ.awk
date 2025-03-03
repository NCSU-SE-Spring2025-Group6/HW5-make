# First pass: Read the top words into an array
PASS == 1 {
    top_words[NR] = $1
    freq[$1] = 0
    printf "%s,", $1
}

# Second pass: Process the cleaned text
PASS == 2 {
    # If we encounter an empty line, it means the end of a paragraph
    if (NF == 0) {
        printf "\n"
        # Print the frequencies for the current paragraph
        for (i = 1; i <= length(top_words); i++) {
            printf "%d,", freq[top_words[i]]
        }

        # Reset the frequency array for the next paragraph
        for (i = 1; i <= length(top_words); i++) {
            freq[top_words[i]] = 0
        }
        next
    }

    # Count the frequencies of top words in the current paragraph
    for (i = 1; i <= NF; i++) {
        word = $i
        if (word in freq) {
            freq[word]++
        }
    }
}

# At the end of the file, print the frequencies for the last paragraph
END {
    # Print the frequencies for the last paragraph if it wasn't followed by an empty line
    if (length(freq) > 0) {
        printf "\n"
        for (i = 1; i <= length(top_words); i++) {
            printf "%d,", freq[top_words[i]]
        }
    }
}

