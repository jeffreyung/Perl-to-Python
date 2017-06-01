#!/usr/bin/perl -w

# prints square of the first given amount of elements

print "Enter amount of elements (integer > 0): \n";

$i = <STDIN>;
$x = 1;
while ($x <= $i) {
    print "let x = x therefore x * x = ";
    $y = $x * $x;
    print "$y\n";
    $x++;
}
