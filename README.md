# ffuf_bab
FFUF Basic Auth Brute Forcer

# Basic Auth Brute Forcer

This tool is a simple script that uses the Fast web fuzzer (ffuf) to perform brute force attacks against HTTP Basic Authentication.

## Features

- Generates combinations of usernames and passwords
- Can perform the brute force attack with multiple threads (as supported by ffuf)
- Checks if necessary dependencies are installed and attempts to install them if not

## Dependencies

The tool has the following dependencies:

- curl
- jq
- coreutils (for the base64 command)
- ffuf

## Installation

Simply clone this repository and run the script:

```
git clone https://github.com/m4xx101/ffuf_bab.git
cd ffuf_bab
chmod +x ffuf_bab.sh
```

## Usage

Use the `-u`, `-p`, and `-d` flags to specify the usernames file, passwords file, and target domain, respectively:

```
./ffuf_bab.sh -u usernames.txt -p passwords.txt -d http://example.com
```
