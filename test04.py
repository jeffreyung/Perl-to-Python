#!/usr/local/bin/python3.5 -u
import sys

odd = []
even = []

print("Enter max value (positive integer only): ")
max_val = float(sys.stdin.readline())

i = 1
while i <= max_val:
    if i % 2 == 0:
     even.append(i)
    else:
        odd.append(i)
    i += 1

sys.stdout.write("odd numbers: ")
print(', '.join(map(str, odd)))

sys.stdout.write("even numbers: ")
print(', '.join(map(str, even)))
