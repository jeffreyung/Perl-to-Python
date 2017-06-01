#!/usr/bin/perl -w

# prints square of the first given amount of elements

print "Enter amount of elements (integer > 0): \n";

$i = <STDIN>;
$x = 1;
if ($i <= 0) {
    print "Invalid: must enter an integer greater than 0.\n";
    print "Would you like to quit (y/n)?\n";
    $q = <STDIN>;
    if ($q eq "y") {
        print "Successful.\n";
        exit(0);
    } else {
        print "Replacing initial value to 1.\n";
        print "let x = $x therefore x * x = ";
        $y = $x * $x;
        print "$y\n";
    }
} else {
    while ($x <= $i) {
        print "let x = x therefore x * x = ";
        $y = $x * $x;
        print "$y\n";
        $x++;
    }
}
