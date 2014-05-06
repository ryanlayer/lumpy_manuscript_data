
## PacBio/Moleculo-based truth set

This truth set is based on the calls made by either LUMPY, DELLY, GASVPro or
DELLY that were validated (using the steps below).  All overlapping calls were
merged by taking the minimum shared interval among the overlapping set.

    
    FILES="lumpy.del.bedpe
    delly.del.bedpe
    gasvpro.del.bedpe
    pindel.del.bedpe"

    rm -f full.hit.val.bedpe

    for FILE in $FILES
    do
        cat $FILE \
        | awk '$(NF-1)>1 || $NF>0' \
        | cut -f1-10 \
        >> full.hit.val.bedpe
    done

    bedpe_sort.py \
        -g genome.txt \
        -b full.hit.val.bedpe \
        > full.hit.val.sort.bedpe

    merge_bedpe.py \
        -b full.hit.val.sort.bedpe \
        > full.hit.val.sort.merge.bedpe

The file used for the LUMPY manuscript is include

    full.hit.val.sort.merge.20140505.bedpe

## LUMPY calls for all variant types

LUMPY calls.  All variant types and validated and un-validated.

   lumpy.NA12878.mol_pb_val.bedpe 

## PacBio/Moleculo deletion validation

Tools Used

- https://github.com/hall-lab/sv-tools/blob/master/splitterToBreakpoint
- https://github.com/hall-lab/sv-tools/blob/master/splitReadSamToBedpe
- https://github.com/hall-lab/soup/blob/master/mp_val_ncol.sh

Download and Format PacBio Data

    # a. Download the data
    /n/sw/aspera/bin/ascp -QT -l 300m -i /n/sw/aspera/etc/asperaweb_id_dsa.putty anonftp@ftp-trace.ncbi.nlm.nih.gov:/1000genomes/ftp/technical/working/20131209_na12878_pacbio/Schadt/alignment/NA12878.pacbio_fr_MountSinai.bwa-sw.20140211.bam .
    /n/sw/aspera/bin/ascp -QT -l 300m -i /n/sw/aspera/etc/asperaweb_id_dsa.putty anonftp@ftp-trace.ncbi.nlm.nih.gov:/1000genomes/ftp/technical/working/20131209_na12878_pacbio/Schadt/alignment/NA12878.pacbio_fr_MountSinai.bwa-sw.20140211.bam.bai .

    # b. Read sort the file
    sambamba sort -m 20G -o NA12878.pacbio_fr_MountSinai.bwa-sw.20140211.readsort.bam -n -t 20 --tmpdir=temp NA12878.pacbio_fr_MountSinai.bwa-sw.20140211.bam

    # c. Convert the split reads to bedpe format
    sambamba view -h -F "not duplicate" NA12878.pacbio_fr_MountSinai.bwa-sw.20140211.readsort.bam | /n/hsphS10/hsphfs1/chb/projects/hall_lumpy_validation/tools/sv-tools/splitReadSamToBedpe -i stdin | gzip -c > NA12878.pacbio.splitreads.excldups.bedpe.gz

    # d. Convert the split reads to breakpoint calls (slop of 5 on each side of break)
    zcat NA12878.pacbio.splitreads.excldups.bedpe.gz \
        | /n/hsphS10/hsphfs1/chb/projects/hall_lumpy_validation/tools/sv-tools/splitterToBreakpoint -s 5 -i stdin -r 1000000 \
        | awk '{ if ($2<0) $2=0; if ($4<0) $4=0; print }' OFS="\t" \
        | awk '{ if ($1!=$4) { $18="DISTANT_INTER" } else { gsub("deletion","DEL",$18); gsub("duplication","DUP",$18);     gsub("inversion","INV",$18); gsub("^local","LOCAL",$18); gsub("^distant","DISTANT",$18); } print }' OFS="\t" \
        | awk '$18~"_DEL$"' \
        | bgzip -c > NA12878.pacbio.splitreads.excldups.breakpoint.bedpe.dels.gz

Download and Format Moleculo Data

    # a. Download Moleculo data
    /n/sw/aspera/bin/ascp -i /n/sw/aspera/etc/asperaweb_id_dsa.putty -QTr -l 1000M anonftp@ftp-trace.ncbi.nlm.nih.gov:/1000genomes/ftp/technical/working/20131209_na12878_moleculo/alignment/NA12878.moleculo.bwa-mem.20140110.bam .
    /n/sw/aspera/bin/ascp -i /n/sw/aspera/etc/asperaweb_id_dsa.putty -QTr -l 1000M anonftp@ftp-trace.ncbi.nlm.nih.gov:/1000genomes/ftp/technical/working/20131209_na12878_moleculo/alignment/NA12878.moleculo.bwa-mem.20140110.bam.bai .

    # b. Read sort the file
    samba sort -m 32G --tmpdir=temp -n -p -t 24 -o NA12878.moleculo.bwa-mem.20140110.readsort.bam NA12878.moleculo.bwa-mem.20140110.bam

    # c. Convert the split reads to bedpe format
    time sambamba view -h -F "not duplicate" NA12878.moleculo.bwa-mem.20140110.readsort.bam | /n/hsphS10/hsphfs1/chb/projects/hall_lumpy_validation/tools/sv-tools/splitReadSamToBedpe -i stdin | bedtools sort | gzip -c > NA12878.moleculo.splitreads.excldups.bedpe.gz

    # d. Convert to breakpoint calls (slop of 5 on each side of break)
    zcat NA12878.moleculo.splitreads.excldups.bedpe.gz \
        | /n/hsphS10/hsphfs1/chb/projects/hall_lumpy_validation/tools/sv-tools/splitterToBreakpoint -s 5 -i stdin -r 1000000 \
        | awk '{ if ($2<0) $2=0; if ($4<0) $4=0; print }' OFS="\t" \
        | awk '{ if ($1!=$4) { $18="DISTANT_INTER" } else { gsub("deletion","DEL",$18); gsub("duplication","DUP",$18); gsub("inversion","INV",$18); gsub("^local","LOCAL",$18); gsub("^distant","DISTANT",$18); } print }' OFS="\t" \
        | awk '$18~"_DEL$"' \
        | bgzip -c \
        > NA12878.moleculo.splitreads.excldups.breakpoint.dels.bedpe.gz

Validation of NA12878 Deletions

Use ```mp_val_ncol.sh``` to validate deletions, which can be found at



These steps are based David Jenkins's testing.

