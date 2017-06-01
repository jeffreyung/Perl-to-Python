#!/usr/bin/perl -w

@odd = ();
@even = ();

print "Enter max value (positive integer only): \n";
$max_val = <STDIN>;

$i = 1;
while ($i <= $max_val) {
    if ($i % 2 == 0) {
    	push @even, $i;
    } else {
        push @odd, $i;
    }
    $i++;
}

print "odd numbers: ";
print join(', ', @odd), "\n";

print "even numbers: ";
print join(', ', @even), "\n";