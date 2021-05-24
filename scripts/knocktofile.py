#!/usr/bin/env python3

# Tool created by @Dirsoooo

import json
import argparse
import sys

parser = argparse.ArgumentParser(
        description="Transform .json files created by the knockpy into .txt files containing only the domains found"
        )
parser.add_argument(
        '-f', '--file', action="store", default=None, dest="file", help="Specify the file .json"
        )
parser.add_argument(
        '-o', '--output', action="store", default=None, dest="output", help="Specify the .txt output file"
        )

domains = []
args = parser.parse_args()

if len(sys.argv) <=1:
    parser.print_help()
    sys.exit(1)

json_file = args.file
output_file = args.output

with open(json_file, 'r') as jfile:
    content = json.loads(jfile.read())
    for domain in content:
        domains.append(domain)
domains.pop()
try:
    with open(output_file, 'a') as outfile:
        for domain in domains:
            outfile.write(domain + '\n')
except FileNotFoundError:
    with open(output_file, 'w') as outfile:
        for domain in domains:
            outfile.write(domain + '\n')

jfile.close()
outfile.close()
