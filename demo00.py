#!/usr/local/bin/python3.5 -u
import sys

# prints square of the first given amount of elements

print("Enter amount of elements (integer > 0): ")

i = float(sys.stdin.readline())
x = 1
if i <= 0:
    print("Invalid: must enter an integer greater than 0.")
    print("Would you like to quit (y/n)?.")
    q = sys.stdin.readline()
    if q == "y":
        print("Successful.")
        sys.exit(0);

    else:
        print("Replacing initial value to 1.")
        sys.stdout.write("let x = %s therefore x * x = " % (x))
        y = x * x
        print(y)
else:
    while x <= i:
        sys.stdout.write("let x = x therefore x * x = ")
        y = x * x
        print(y)
        x += 1
