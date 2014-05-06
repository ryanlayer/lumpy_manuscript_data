FS="ab.txt
bc.txt
bg.txt
ln.txt
ox.txt
sd.txt
si.txt
uw.txt
wu.txt
yl.txt"

for F in $FS
do
    cat $F \
        | grep NA12878 \
        | awk '$24=="validated"' \
        | awk '{OFS="\t"; print "chr"$4,$34,$32+1,"chr"$4,$33,$35+1,$3,$10,"+","+","TYPE:"$9}' \
        | sed -e "s/DEL/DELETION/g" | \
        sed -e "s/INS/INSERTION/g" \
        > $F.bedpe
        #| awk '{OFS="\t"; print "chr"$4,$7,$5+1,"chr"$4,$6,$8+1,$3,0,"+","+","TYPE:"$9}' \
done
