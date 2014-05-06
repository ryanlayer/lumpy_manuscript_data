import sys

if len(sys.argv) != 4:
    print "usage:" + sys.argv[0] + " <col1> <col2> <bedpe>"
    exit(1)

col1_file = sys.argv[1]
col2_file = sys.argv[2]
bedpe_file = sys.argv[3]

col1 = {}
col2 = {}
bedpe = {}

f = open(col1_file, 'r')
for l in f:
    a = l.rstrip().split('\t')
    col1[a[3]] = a
f.close()

f = open(col2_file, 'r')
for l in f:
    a = l.rstrip().split('\t')
    col2[a[3]] = a
f.close()

f = open(bedpe_file, 'r')
for l in f:
    a = l.rstrip().split('\t')
    bedpe[a[6]] = a
f.close()


for col in col1:
    if col in col2:
        print '\t'.join( (\
                col1[col][0], col1[col][1], col1[col][2],\
                col2[col][0], col2[col][1], col2[col][2],\
                bedpe[col][6], \
                bedpe[col][7], \
                bedpe[col][8], \
                bedpe[col][9], \
                bedpe[col][10] \
                ))

