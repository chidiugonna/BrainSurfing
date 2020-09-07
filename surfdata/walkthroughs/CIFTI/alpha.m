% Alpha 
addpath /home/chidi/repos/neurobase/doanalysis/SurfaceFormat/library/cifti-matlab
IMAGE1='/home/chidi/repos/neurobase/DATA/MNINonLinear/100307.sulc.164k_fs_LR.dscalar.nii';

%load cifti file and directly change cifti at location (LEFT CORTEX) and save

%ciiall= cifti_read(IMAGE1);

IMAGE2='/home/chidi/repos/neurobase/DATA/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas.dtseries.nii';
ciiall= cifti_read(IMAGE2);