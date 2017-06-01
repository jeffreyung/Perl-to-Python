#!/usr/bin/perl -w

@fib = ();
$i = 0;

while ($i < 5) {
    push @fib, $i;
    $i++;
}

print join(', ', @fib), "\n";

pop @fib;
pop @fib;

print join(', ', @fib), "\n";