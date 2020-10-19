#!/bin/bash
#
# TASK 004: Convert volumetric functional data into a CIFTI file
#
# Run using docker from a terminal starting in the practicum91 folder. Use the command below:
#
#     docker run -v $PWD:/mnt --rm -it --entrypoint bash tigrlab/fmriprep_ciftify:v1.3.2-2.3.3 /mnt/004_ciftigen.sh
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
########CWD=$PWD

SUB=sub-01
DATA=${CWD}/DATA/${SUB}
CONFIG=${CWD}/DATA/config
OUTPUT=${CWD}/output/${SUB}

mkdir -p ${OUTPUT}

echo "TASK 004: Convert volumetric functional data into a CIFTI file for $SUB"
FUNC_VOL=${DATA}/MNINonLinear/Results/task-rhymejudgment/task-rhymejudgment.nii.gz
MYPREFIX="amended."
L_FUNC=${OUTPUT}/${SUB}.L.midthickness.32k_fs_LR.func.gii

# create Right midthickness layer
R_PIAL=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.R.pial.32k_fs_LR.surf.gii
R_WHITE=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.R.white.32k_fs_LR.surf.gii
MY_R_MID=${OUTPUT}/${MYPREFIX}${SUB}.R.midthickness.32k_fs_LR.surf.gii

wb_command -surface-average ${MY_R_MID} -surf ${R_WHITE} -surf ${R_PIAL}
wb_command -set-structure ${MY_R_MID} CORTEX_RIGHT -surface-type ANATOMICAL -surface-secondary-type MIDTHICKNESS
echo "Right midthickness layer created for $SUB"

# Create a CIFTI file from a Volume
R_PIAL=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.R.pial.32k_fs_LR.surf.gii
R_WHITE=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.R.white.32k_fs_LR.surf.gii
R_MID=${DATA}/MNINonLinear/fsaverage_LR32k/${SUB}.R.midthickness.32k_fs_LR.surf.gii
R_FUNC=${OUTPUT}/${SUB}.R.midthickness.32k_fs_LR.func.gii
echo "Starting Projection of volume data to Right midthickness layer for $SUB."
wb_command -volume-to-surface-mapping ${FUNC_VOL} ${MY_R_MID} ${R_FUNC} -ribbon-constrained ${R_PIAL} ${R_WHITE}
echo "Completed Projection of volume data to Right midthickness layer for $SUB."

SUBCORTROI=${DATA}/MNINonLinear/ROIs/ROIs.2.nii.gz
SUBCORTLABEL=${CONFIG}/Atlas_ROIs.2.nii.gz
echo "Started sampling of volume data tonto sub-cortical voxels of $SUB."
wb_command -cifti-create-dense-timeseries ${OUTPUT}/temp_subject.dtseries.nii -volume ${FUNC_VOL} ${SUBCORTROI}
# Dilate out zeros
wb_command -cifti-dilate ${OUTPUT}/temp_subject.dtseries.nii COLUMN 0 10 ${OUTPUT}/temp_subject_dilate.dtseries.nii
wb_command -cifti-create-label ${OUTPUT}/temp_template.dlabel.nii -volume ${SUBCORTLABEL} ${SUBCORTLABEL}
wb_command -cifti-resample ${OUTPUT}/temp_subject_dilate.dtseries.nii COLUMN ${OUTPUT}/temp_template.dlabel.nii COLUMN ADAP_BARY_AREA CUBIC ${OUTPUT}/temp_atlas.dtseries.nii -volume-predilate 10
wb_command -cifti-separate ${OUTPUT}/temp_atlas.dtseries.nii COLUMN -volume-all ${OUTPUT}/rest_AtlasSubcortical_s0.nii.gz
echo "Completed sampling of volume data tonto sub-cortical voxels of $SUB."

TR=2
L_MASK=${CONFIG}/L.atlasroi.32k_fs_LR.shape.gii
R_MASK=${CONFIG}/R.atlasroi.32k_fs_LR.shape.gii
PREFIX=created.den-91k.
echo "Started creation of CIFTI dense timeseries."
wb_command -cifti-create-dense-timeseries ${OUTPUT}/${PREFIX}${SUB}_rest.dtseries.nii -volume ${OUTPUT}/rest_AtlasSubcortical_s0.nii.gz ${SUBCORTLABEL} -left-metric ${L_FUNC} -roi-left ${L_MASK} -right-metric ${R_FUNC} -roi-right ${R_MASK} -timestep ${TR} 

echo "Created CIFTI."
# clean up
rm ${OUTPUT}/temp*

chmod -R 777 ${OUTPUT}