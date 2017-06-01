#!/usr/bin/perl -w
# testing exit

print "Enter age...\n";
$age = <STDIN>;
if ($age < 18){
    print "Age is too young to drink alcohol.\n";
    exit(1);
}

print "Age is sufficient to drink alcohol.\n";
