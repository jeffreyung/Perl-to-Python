#!/usr/local/bin/python3.5 -u
import sys
# testing exit

print("Enter age...")
age = float(sys.stdin.readline())
if age < 18:
    print("Age is too young to drink alcohol.")
    sys.exit(1);


print("Age is sufficient to drink alcohol.")
