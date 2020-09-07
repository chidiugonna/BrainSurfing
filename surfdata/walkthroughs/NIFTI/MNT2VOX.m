addpath /usr/share/matlab/nifti2014
T1='sub-01_T1w.nii.gz'
T1hdr=load_nifti(T1);
T1vol=T1hdr.vol;
M=T1hdr.sform(1:3,1:3);
O=T1hdr.sform(1:3,4);

% from MNI to voxel
RAS=[71.52,166.14,166.08];
VOXT1 = inv(M)*(RAS' - O);
VOXT1 = round(VOXT1);

% from voxel to MNI
MNI = (M*VOXT1)+O;