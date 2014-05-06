BPS="ab.b37.bedpe
bc.b37.bedpe
bg.b37.bedpe
ln.b37.bedpe
ox.b37.bedpe
sd.b37.bedpe
si.b37.bedpe
uw.b37.bedpe
wu.b37.bedpe
yl.b37.bedpe"

for BP in $BPS
do
    B=`basename $BP .bedpe`
    rm -f $B.del.bedpe
    grep "TYPE:DEL" $BP >> $B.del.bedpe
done
