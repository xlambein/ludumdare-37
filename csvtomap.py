#!/usr/bin/env python3

import sys


def emptyLine(line):
    return not list(filter(None, line[:-1].split(',')))



with open(sys.argv[1]) if len(sys.argv) >= 2 else sys.stdin as f:
    print("local map = {")
    for line in f:
        if emptyLine(line):
            break
        print("\t{{{}}},".format(line[:-1]))
    print("}")
    print()
    print("local entities = {")
    for line in f:
        if emptyLine(line):
            break
        vals = filter(None, line[:-1].split(','))
        vals = list(map(lambda s: s.replace('"', ''), vals))
        if len(vals) == 3:
            print("\t{{type = '{}', x = {}, y = {}}},".format(*vals))
        else:
            print("\t{{type = '{}', x = {}, y = {}, args = {{{}}}}},".format(vals[0], vals[1], vals[2], ','.join(vals[3:])))
    print("}")
    print()
    print("local player = {{x = {}, y = {}}}".format(*filter(None, f.readline()[:-1].split(','))))
    print()
    print("return {map = map, entities = entities, player = player}")
