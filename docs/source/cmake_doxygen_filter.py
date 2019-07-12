#!/usr/bin/python3

import sys

if len(sys.argv) != 2:
    raise Exception("Syntax: cmake_doxygen_filter.py <file_name>")

with open(sys.argv[1]) as f:
    in_fxn = False
    for l in f.readlines():

        line = l.strip().split()
        if len(line) == 0:
            sys.stdout.write(l)
            continue

        first_word = line[0]
        if "endfunction" in first_word or "endmacro" in first_word:
            sys.stdout.write("    return\n")
            in_fxn = False
            continue
        elif "function" in first_word or "macro" in first_word:
            sys.stdout.write("def ")
            temp = l.strip().split('(')
            in_fxn = True
            if len(temp) == 1:  # something like function(\n
                continue
            args = temp[1].split(')')[0].split()
            sys.stdout.write(args[0] + '(')
            for i,x in enumerate(args):
                if i != 0:
                    sys.stdout.write(',' + x)
                else:
                    sys.stdout.write(x)
            if ')' in l:
                sys.stdout.write('):\n')
        elif not in_fxn and l.strip()[0] == '#':
            sys.stdout.write(l)


