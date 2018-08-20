#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, print_function

from sys import argv


def read_file(file_name):

    log = []

    with open(argv[-1]) as log_file:
        log = log_file.read().split("\n")

    return filter(None, log)


def get_order(line):

    return (2**(len(line) - line.index('1')) - 1)


def add(op1, op2, out):

    return ((op1 ^ op2) == out)


def mul(op1, op2, out, order):

    return (((op1 + op2) % order) == out)


def div(op1, op2, out, order):

    return (((op1 - op2) % order) == out)


def _log(op1, op2, out):

    return (op1 == out)


def cprint(result):

    if result:
        print("\x1b[1;32;40mCorrect\x1b[0m")
    else:
        print("\x1b[1;31;40mIncorrect\x1b[0m")


def parse_log(log):

    order = 0
    for line in log:
        raw_line = line
        line = line.split()
        if (len(line) == 1):
            print("New polynomial:", line[0])
            order = get_order(line[0])
        else:
            line[1:] = [int(i) for i in line[1:]]
            print(raw_line, end=" ")
            if (line[0] == "add"):
                cprint(add(*line[1:]))
            if (line[0] == "mul"):
                cprint(mul(*line[1:], order=order))
            if (line[0] == "div"):
                cprint(div(*line[1:], order=order))
            if (line[0] == "log"):
                cprint(_log(*line[1:]))


if __name__ == '__main__':

    parse_log(read_file("fhsf"))
