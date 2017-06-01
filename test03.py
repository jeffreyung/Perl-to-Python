#!/usr/local/bin/python3.5 -u

fib = []
i = 0

while i < 5:
    fib.append(i)
    i += 1

print(', '.join(map(str, fib)))

fib.pop()
fib.pop()

print(', '.join(map(str, fib)))
