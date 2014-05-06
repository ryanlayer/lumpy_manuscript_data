rm -f all.b37.del.bedpe

for S in `wc -l *.b37.del.bedpe | grep -v total | sort -nr | awk '{print $2;}'`
do
    cat $S \
        | awk '$5>$3' \
        | awk '{OFS="\t"; print $1,$2,$6,$7}' > $S.inner.bed
done

for f in `ls *.inner.bed`
do
    head -n 1 $f > $f.u

    tail -n+1 $f | while read l
    do 
        echo $l | awk '{OFS="\t"; print $1,$2,$3,$4;}'> .t
        bedtools intersect -v -a .t -b $f.u >> $f.u
    done
done


rm -f all.bed

for S in `wc -l *.b37.del.bedpe | grep -v total | sort -nr | awk '{print $2;}'`
do
    if [ -s "all.bed" ]
    then
        bedtools intersect -v -a $S.inner.bed.u -b all.bed > new.bed
        cat new.bed >> all.bed
    else
        cat $S.inner.bed.u > all.bed
    fi
done

cat all.bed | awk '{print "\t"$4"\t";}' > ids.txt

grep -f ids.txt *.b37.del.bedpe | cut -d":" -f2,3 > non_ol.del.bedpe

cat *.b37.del.bedpe > all.b37.del.bedpe

