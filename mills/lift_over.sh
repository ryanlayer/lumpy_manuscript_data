BPS="ab.txt.bedpe
bc.txt.bedpe
bg.txt.bedpe
ln.txt.bedpe
ox.txt.bedpe
sd.txt.bedpe
si.txt.bedpe
uw.txt.bedpe
wu.txt.bedpe
yl.txt.bedpe"



for BP in $BPS
do
    B=`basename $BP .txt.bedpe`
    cat $BP | cut -f 1,2,3,7 > $B.c1
    cat $BP | cut -f 4,5,6,7 > $B.c2
    liftOver $B.c1 hg18ToHg19.over.chain.gz $B.b37.c1 $B.c1.unlift
    liftOver $B.c2 hg18ToHg19.over.chain.gz $B.b37.c2 $B.c2.unlift
    python match_bed_bed_bedpe.py $B.b37.c1 $B.b37.c2 $BP > $B.b37.bedpe
done
