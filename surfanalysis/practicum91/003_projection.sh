#!/bin/bash
#
# TASK 003: Project volumetric data onto surface
#
# Run using docker from a terminal starting in the practicum91 folder. Use the command below:
#
#     `docker run -v $PWD:/mnt --rm -it --entrypoint bash tigrlab/fmriprep_ciftify:v1.3.2-2.3.3 /mnt/003_projection.sh`
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
#######CWD=$PWD

SUB=sub-01
DATA=${CWD}/DATA/${SUB}
CONFIG=${CWD}/DATA/config
OUTPUT=${CWD}/output/${SUB}

mkdir -p ${OUTPUT}

echo "Running TASK 003: Project volumetric data onto surface for $SUB"

MYPREFIX="amended."
MY_L_MID=${OUTPUT}/${MYPREFIX}${SUB}.L.midthickness.32k_fs_LR.surf.gii

FUNC_VOL=${DATA}/MNINonLinear/Results/task-rhymejudgment/task-rhymejudgment.nii.gz
L_PIAL=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.L.pial.32k_fs_LR.surf.gii
L_WHITE=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.L.white.32k_fs_LR.surf.gii
L_FUNC=${OUTPUT}/${SUB}.L.midthickness.32k_fs_LR.func.gii

echo "Starting Projection of volume data to Left midthickness layer for $SUB."
wb_command -volume-to-surface-mapping ${FUNC_VOL} ${MY_L_MID} ${L_FUNC} -ribbon-constrained ${L_PIAL} ${L_WHITE}
echo "Completed Projection of volume data to Left midthickness layer for $SUB."

chmod -R 777 ${OUTPUT}