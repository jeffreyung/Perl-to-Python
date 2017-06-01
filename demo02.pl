#!/usr/bin/perl -w

# prints a triangle size is proportional to the entered integer

printf("Enter positive integer:\n");

$n = <STDIN>;
$y = $n;
while ($y > 0) {
    $x = $y;
    while ($x > 0) {
        if ($x == 1) {
            print "*\n";
        } else {
            print "*";
        }
        $x--;
    }
    $y--;
}
