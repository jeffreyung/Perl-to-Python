#!/usr/bin/perl -w

print "Please type 'hello world' (case sensitive):\n";
$text = <STDIN>;
chomp $text;
if ($text eq "hello world") {
    print "correct\n";
} else {
    print "wrong\n";
}
