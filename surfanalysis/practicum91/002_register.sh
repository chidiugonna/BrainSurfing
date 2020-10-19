#!/bin/bash
#
# TASK 002: Register subject to 164K_fs_LR 
#
# Run using docker from a terminal starting in the practicum91 folder. Use the command below:
#
#     `docker run -v $PWD:/mnt --rm -it --entrypoint bash tigrlab/fmriprep_ciftify:v1.3.2-2.3.3 /mnt/002_register.sh`
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
# NOTE:  This script could take a considerable time to run on your machine if you run msm.
#


CWD=/mnt
########CWD=$PWD

SUB=sub-02
DATA=${CWD}/DATA/${SUB}
CONFIG=${CWD}/DATA/config
OUTPUT=${CWD}/output/${SUB}

echo "Running TASK 002: Register subject to 164K_fs_LR on $SUB"

mkdir -p ${OUTPUT}
chmod -R 777 $OUTPUT


# Seperate out the Left and right sulc overlays as GIFTIs
echo "Seperate out the sulc CIFTI into Left  and Right Cortex for $SUB"
CIFTI_SULC=${DATA}/MNINonLinear/Native/${SUB}.sulc.native.dscalar.nii
L_SULC=${OUTPUT}/${SUB}.L.sulc.native.shape.gii
R_SULC=${OUTPUT}/${SUB}.R.sulc.native.shape.gii
wb_command -cifti-separate-all ${CIFTI_SULC}  -left ${L_SULC} -right ${R_SULC}


# Use MSMSulc (uses Sulc overlay as the registration template) to register subject sphere
# to 164K standard sphere
L_SPHERE=${DATA}/MNINonLinear/Native/${SUB}.L.sphere.rot.native.surf.gii
L_SPHERE_REFERENCE=${CONFIG}/fsaverage.L_LR.spherical_std.164k_fs_LR.surf.gii
L_SULC_REFERENCE=${CONFIG}/L.refsulc.164k_fs_LR.shape.gii
MSMCONFIG=${CONFIG}/MSMSulcStrainFinalconf
MSM_L=${DATA}/MSMSulc/L.
mkdir -p ${DATA}/MSMSulc


# msm sulc runs now - this creates the registered sphere L.sphere.reg.surf.gii 
# in the folder MSMSulc - we will use this to create registered surfaces and overlays
#
# This has been run earlier for you as the registration can take about an hour. If you want to run this step yourself then
# change BYPASS="Y" to "BYPASS="N"
BYPASS="Y"
if [ $BYPASS = "N" ]
then
echo "Started MSM Sulc on $SUB. This may take about 45 - 60 minutes."
echo msm --conf=${MSMCONFIG} --inmesh=${L_SPHERE} --refmesh=${L_SPHERE_REFERENCE} --indata=${L_SULC} --refdata=${L_SULC_REFERENCE} --out=${MSM_L} --verbose
msm --conf=${MSMCONFIG} --inmesh=${L_SPHERE} --refmesh=${L_SPHERE_REFERENCE} --indata=${L_SULC} --refdata=${L_SULC_REFERENCE} --out=${MSM_L} --verbose
echo "MSM Sulc completed on $SUB for Left hemisphere."
fi

PREFIX=amended.
# resample the midthickness to 164K
L_MID=${DATA}/MNINonLinear/Native/${SUB}.L.midthickness.native.surf.gii
L_MID_164=${OUTPUT}/${PREFIX}${SUB}.L.midthickness.164k_fs_LR.surf.gii
L_SPHERE_164=${L_SPHERE_REFERENCE}
L_SPHERE_REG=${MSM_L}sphere.reg.surf.gii
wb_command -surface-resample ${L_MID} ${L_SPHERE_REG} ${L_SPHERE_164} BARYCENTRIC ${L_MID_164}
echo "Resampled Midthickness mesh (Left Hemisphere) from Native surface to 164K surface for $SUB."

CIFTI_THICKNESS=${DATA}/MNINonLinear/Native/${SUB}.thickness.native.dscalar.nii
L_THICKNESS=${OUTPUT}/${SUB}.L.thickness.native.shape.gii
R_THICKNESS=${OUTPUT}/${SUB}.R.thickness.native.shape.gii
wb_command -cifti-separate-all ${CIFTI_THICKNESS}  -left ${L_THICKNESS} -right ${R_THICKNESS}


L_THICKNESS_164=${OUTPUT}/${PREFIX}${SUB}.L.thickness.164k_fs_LR.shape.gii
wb_command -metric-resample ${L_THICKNESS} ${L_SPHERE_REG} ${L_SPHERE_164} ADAP_BARY_AREA ${L_THICKNESS_164} -area-surfs  ${L_MID} ${L_MID_164}
echo "Resampled Thickness Overlay (Left Hemisphere) from Native surface to 164K surface for $SUB."


CIFTI_SULC=${DATA}/MNINonLinear/Native/${SUB}.sulc.native.dscalar.nii
L_SULC=${OUTPUT}/${SUB}.L.sulc.native.shape.gii
R_SULC=${OUTPUT}/${SUB}.R.sulc.native.shape.gii
wb_command -cifti-separate-all ${CIFTI_SULC}  -left ${L_SULC} -right ${R_SULC}

L_SULC_164=${OUTPUT}/${PREFIX}${SUB}.L.sulc.164k_fs_LR.shape.gii
wb_command -metric-resample ${L_SULC} ${L_SPHERE_REG} ${L_SPHERE_164} ADAP_BARY_AREA ${L_SULC_164} -area-surfs  ${L_MID} ${L_MID_164}
echo "Resampled Sulc Overlay (Left Hemisphere) from Native surface to 164K surface for $SUB."

chmod -R 777 $OUTPUT
chmod -R 777 ${DATA}/MSMSulc