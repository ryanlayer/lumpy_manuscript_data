# Mills et al. truth set

This process requires the program ```liftOver```, which can be found at http://genome.ucsc.edu/util.html.

Start by downloading and unzipping the data from Mills et al.

    wget http://www.nature.com/nature/journal/v470/n7332/extref/nature09708-s5.zip
    unzip nature09708-s5.zip

This will produce the file ```2010-08-10613C-Supplementary_Table_4.xls```.
Save each tabe as a tab-delmitted text file where the name is the lower-case
version of the tab name.  For example ```AB``` is stored as ```ab.txt````.
When this is complete, there should be 10 files:

    ab.txt
    bc.txt
    bg.txt
    ln.txt
    ox.txt
    sd.txt
    si.txt
    uw.txt
    wu.txt
    yl.txt

Then run the following commands:

    bash to_bedpe.sh
    bash lift_over.sh
    bash get_del.sh
    bash find_non_ol_set.sh
