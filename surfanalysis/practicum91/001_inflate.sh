#!/bin/bash
#
# TASK 001: Create midthickness and inflated, very-inflated surfaces
#
# Run using docker from a terminal starting in the practicum91 folder. Use the command below:
#
#     `docker run -v $PWD:/mnt --rm -it --entrypoint bash tigrlab/fmriprep_ciftify:v1.3.2-2.3.3 /mnt/001_inflate.sh`
#
# IMPORTANT: These steps have been copiedfrom the HCP and ciftify pipelines and are used just to demonstrate conceptual ideas. 
#            Please refer to the HCP Pipelines for HCP Data or to CIFTIFY for non-HCP data for the appropriate way to perform 
#            these surface-based analysis steps.
#

# HCP Pipelines: https://github.com/Washington-University/HCPpipelines
# Ciftify: https://github.com/edickie/ciftify
#
# References:
# 
# Glasser MF, Sotiropoulos SN, Wilson JA, Coalson TS, Fischl B, Andersson JL, Xu J, Jbabdi S, Webster M, Polimeni JR, Van Essen DC, Jenkinson M, WU-Minn HCP Consortium. The minimal preprocessing pipelines for the Human Connectome Project. Neuroimage. 2013 Oct 15;80:105-24. PubMed PMID: 23668970; PubMed Central PMCID: PMC3720813.
#
# Dickie, E. W., Anticevic, A., Smith, D. E., Coalson, T. S., Manogaran, M., Calarco, N., ... & Voineskos, A. N. (2019). ciftify: A framework for surface-based analysis of legacy MR acquisitions. Neuroimage, 197, 818-826.


CWD=/mnt
######CWD=$PWD

SUB=sub-01
DATA=${CWD}/DATA/${SUB}
OUTPUT=${CWD}/output/${SUB}

mkdir -p ${OUTPUT}

MYPREFIX="amended."

echo "Running TASK 001: Create Left midthickness and inflated, very-inflated surfaces on $SUB"

# create midthickness layer
L_PIAL=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.L.pial.32k_fs_LR.surf.gii
L_WHITE=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.L.white.32k_fs_LR.surf.gii
MY_L_MID=${OUTPUT}/${MYPREFIX}${SUB}.L.midthickness.32k_fs_LR.surf.gii

wb_command -surface-average ${MY_L_MID} -surf ${L_WHITE} -surf ${L_PIAL}
wb_command -set-structure ${MY_L_MID} CORTEX_LEFT -surface-type ANATOMICAL -surface-secondary-type MIDTHICKNESS

echo "Left midthickness layer created for $SUB"

# create inflated  surfaces
MY_L_INFLATED=${OUTPUT}/${MYPREFIX}${SUB}.L.inflated.32k_fs_LR.surf.gii
MY_L_VERY_INFLATED=${OUTPUT}/${MYPREFIX}${SUB}.L.very_inflated.32k_fs_LR.surf.gii
# iterations scaling of 2.5 is recommended by HCP
wb_command -surface-generate-inflated ${MY_L_MID}  ${MY_L_INFLATED} ${MY_L_VERY_INFLATED} -iterations-scale 2.5
wb_command -set-structure ${MY_L_INFLATED} CORTEX_LEFT
wb_command -set-structure ${MY_L_VERY_INFLATED} CORTEX_LEFT

echo "Left inflated and very_inflated surfaces created for $SUB"

chmod -R 777 $OUTPUT