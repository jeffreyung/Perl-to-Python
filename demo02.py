#!/usr/local/bin/python3.5 -u
import sys

print("(Enter positive integer:)")

n = float(sys.stdin.readline())
y = n
while y > 0:
    x = y
    while x > 0:
        if x == 1:
            print("*")
        else:
            sys.stdout.write("*")
        x -= 1
    y -= 1
