#!/usr/local/bin/python3.5 -u
import sys

print("Please type 'hello world' (case sensitive):")
text = sys.stdin.readline()
text = text.rstrip()
if text == "hello world":
    print("correct")
else:
    print("wrong")
