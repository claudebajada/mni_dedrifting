#! /bin/bash
#
# dedrifting.sh
# Copyright (C) 2018 Claude Bajada <c.bajada@fz-juelich.de>
# 
# Credit to the HCP user group and Tim Coalson for his explanation in the thread below:
# https://www.mail-archive.com/hcp-users@humanconnectome.org/msg06443.html
# Note that the HCP project or any member of the user group did not pre-approve this script
#
# Distributed under terms of the MIT license.
#

# short script to create a warp that converts ACPC space to a "dedrifted" MNI
# space
#

PATH2WARP=$1
REF=$2
OUTPUT=$3
NUM=0

ListOfWarpFields=$(ls $PATH2WARP)
FirstWarp=$(ls $PATH2WARP | head -1)

EXE="fslmaths $FirstWarp -sub $FirstWarp $OUTPUT"
echo $EXE
eval $EXE

for image in ${ListOfWarpFields[@]}; do

  EXE="fslmaths $OUTPUT -add $image $OUTPUT"
  echo $EXE
  eval $EXE

  NUM=$(($NUM+1))

done

# creating average
EXE="fslmaths $OUTPUT -div $NUM $OUTPUT"
echo $EXE
eval $EXE

# inverse the warp
EXE="invwarp -w $OUTPUT -r $REF -o $OUTPUT"
echo $EXE
eval $EXE
