#!/usr/local/bin/python3.5 -u
import sys
# writen by andrewt@cse.unsw.edu.au as a COMP2041 example
# implementation of /bin/echo

print(' '.join(map(str, sys.argv[1:])))
