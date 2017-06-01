#!/usr/local/bin/python3.5 -u
import sys
# Reads lines of input until end-of-input
# Print snap! if two consecutive lines are identical
# taken from lecture example <http://www.cse.unsw.edu.au/~cs2041/code/perl/code_examples.html>

i = 3
print("1. Enter line:")
last_line = sys.stdin.readline()
print("2. Enter line:")
for line in sys.stdin:
    if line == last_line:
        print("Snap!")
    last_line = line
    print("%s. Enter line:" % (i))
    i += 1
