#!/usr/local/bin/python3.5 -u
import sys

# Fibonacci numbers using while loop
# Written by Jeffrey Ung

fib = [1, 1]

print("Enter amount of element of fibonacci numbers:")
n = float(sys.stdin.readline())

if n < 0:
    print("Can only enter non-negative integers!")
    sys.exit(0);

i = 2
while i < n:
    val = fib[i - 1] + fib[i - 2]
    fib.append(val)
    i += 1

if n == 0:
    fib.pop()
    fib.pop()
elif n == 1:
    fib.pop()

sys.stdout.write("> ")
print(', '.join(map(str, fib)))
