#!/usr/bin/perl -w

# Fibonacci numbers using while loop
# Written by Jeffrey Ung

@fib = (1, 1);

print "Enter amount of element of fibonacci numbers:\n";
$n = <STDIN>;

if ($n < 0) {
    print "Can only enter non-negative integers!\n";
    exit(0);
}
$i = 2;
while ($i < $n) {
    $val = $fib[$i - 1] + $fib[$i - 2];
    push @fib, $val;
    $i++;
}

if ($n == 0) {
    pop @fib;
    pop @fib;
} elsif ($n == 1) {
    pop @fib;
}

print "> ";
print join(', ', @fib), "\n";