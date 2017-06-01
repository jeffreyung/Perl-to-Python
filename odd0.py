#!/usr/local/bin/python3.5 -u
import sys

number = 0
while number >= 0:
    print("Enter number:")
    number = float(sys.stdin.readline())
    if number >= 0:
        if number % 2 == 0:
            print("Even test")
        else:
            print("Odd test")
print("Bye")
