#!/bin/bash

shopt -s nocaseglob	# Case insensitive

# Create link files from in files
for inputfile in *.in
do
    outputfile=$(sed "s/.in/.links/g" <<<"$inputfile")	# define output filename
    rm -f $outputfile	# remove existing output file, if present

    # Read in file, replace all tabs with next line, remove any extra lines present in the in file and add .bz2 at the end.
    # Assuming, the file names in the list are like A2018176173000.L1A_LAC
    cat $inputfile | tr -s '\t' '\n' | tr -d '\t' | awk 'NF' | sed "s/.L1A_LAC/.L1A_LAC.bz2/g" > tmpfile

    # Create link for the files by adding https://oceandata.sci.gsfc.nasa.gov/ob/getfile/ at the begining of each line
    sed -e 's/^/https\:\/\/oceandata.sci.gsfc.nasa.gov\/ob\/getfile\//' tmpfile > sorted

    # Sorting filelist in increasing order and saving it to output filename
    sort sorted > $outputfile

    # Cleaning temporary files
    rm -f tmpfile
    rm -f sorted
    rm $inputfile
done

# Read the link files created in th previous section of this code
for inputfile in *.links
do
    foldername=$(sed "s/.links//g" <<<"$inputfile") # Define folder name to download images
    mkdir $foldername	# Create folder
    cd $foldername	# Change directory to the newly created folder

    # Download all the file links in the links file
    cat ../$inputfile | wget --user=USERNAME --password=PASSWORD --auth-no-challenge=on --keep-session-cookies -i -

    cd ..  # get back to the folder containing link files
done
