#!/usr/bin/env python
import sys
import numpy as np

from optparse import OptionParser

LC=0
LS=1
LE=2
RC=3
RS=4
RE=5

parser = OptionParser()

parser.add_option("-b",
    "--bedpe_file",
    dest="bedpe_file",
    help="Sorted BEDPE file")

(options, args) = parser.parse_args()

if not options.bedpe_file:
    parser.error('Sorted BEDPE file not given')

f = open(options.bedpe_file,'r')

lA = []
for l in f:
    A = l.rstrip().split('\t')

    if len(lA) == 0:
        lA = A
    else:
        # test to see if the lA and current A intersect
        if ( (lA[LC] == A[LC]) and \
             (lA[RC] == A[RC]) and \
             (int(lA[LS]) <= int(A[LE]) and int(lA[LE]) >= int(A[LS])) and \
             (int(lA[RS]) <= int(A[RE]) and int(lA[RE]) >= int(A[RS])) ):
            lA[LS] = str(max(int(lA[LS]),int(A[LS])))
            lA[LE] = str(min(int(lA[LE]),int(A[LE])))
            lA[RS] = str(max(int(lA[RS]),int(A[RS])))
            lA[RE] = str(min(int(lA[RE]),int(A[RE])))
        else:
            print '\t'.join(lA[0:10])
            lA = A
f.close()

print '\t'.join(lA[0:10])
