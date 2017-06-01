#!/usr/bin/perl -w
# Reads lines of input until end-of-input
# Print snap! if two consecutive lines are identical
# taken from lecture example <http://www.cse.unsw.edu.au/~cs2041/code/perl/code_examples.html>

$i = 3;
print "1. Enter line:\n";
$last_line = <STDIN>;
print "2. Enter line:\n";
while ($line = <STDIN>) {
    if ($line eq $last_line) {
        print "Snap!\n";
    }
    $last_line = $line;
    print "$i. Enter line:\n";
    $i++;
}
