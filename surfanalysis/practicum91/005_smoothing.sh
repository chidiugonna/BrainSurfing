#!/bin/bash
#
# TASK 004: Spatial Smoothing on functional CIFTI
#
# Run using docker from the a terminal open in the practicum91 folder using the command below:
#
#     `docker run -v $PWD:/mnt --rm -it --entrypoint bash tigrlab/fmriprep_ciftify:v1.3.2-2.3.3 /mnt/005_smoothing.sh`
#
# IMPORTANT: These steps have been copied from the HCP and ciftify pipelines and are used just to demonstrate conceptual ideas. 
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
#
CWD=/mnt
#CWD=$PWD


SUB=sub-01
DATA=${CWD}/DATA/${SUB}
CONFIG=${CWD}/DATA/config
OUTPUT=${CWD}/output/${SUB}

mkdir -p ${OUTPUT}
echo "TASK 005: Perform Spatial Smoothing on CIFTI fMRI for $SUB"

FUNCPREFIX=created.den-91k.
CIFTIFMRI=${OUTPUT}/${FUNCPREFIX}${SUB}_rest.dtseries.nii

MYPREFIX=amended.
MY_L_MID=${OUTPUT}/${MYPREFIX}${SUB}.L.midthickness.32k_fs_LR.surf.gii
MY_R_MID=${OUTPUT}/${MYPREFIX}${SUB}.R.midthickness.32k_fs_LR.surf.gii

# Use large FWHM for dramatic effect!
SurfaceSigma=6
VolumeSigma=6
CIFTIFMRI_SMOOTH=${OUTPUT}/${FUNCPREFIX}${SUB}_rest.smoothed.dtseries.nii

echo "Started Spatial smoothing for Surface (sigma=${SurfaceSigma} mm) and Volume (sigma=${VolumeSigma} mm)"
wb_command -cifti-smoothing ${CIFTIFMRI} ${SurfaceSigma} ${VolumeSigma} COLUMN ${CIFTIFMRI_SMOOTH} -left-surface ${MY_L_MID} -right-surface ${MY_R_MID}
echo "Completed Spatial Smoothing."

chmod -R 777 $OUTPUT