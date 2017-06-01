#!/usr/local/bin/python3.5 -u
import sys

# prints square of the first given amount of elements

print("Enter amount of elements (integer > 0): ")

i = float(sys.stdin.readline())
x = 1
while x <= i:
    sys.stdout.write("let x = x therefore x * x = ")
    y = x * x
    print(y)
    x += 1
