% add release library to path
addpath /home/chidi/repos/neurobase/doanalysis/SurfaceFormat/library/gifti-release
%% Example
% read and view the GIFTI surface mesh
lh_pial='/home/chidi/repos/neurobase/DATA/T1w/100307/surf/lh.orig'
lh_pial_mesh = gifti(lh_pial);



figure; plot(lh_pial_mesh)
%save as ascii to see xml
save(gmesh,'mri.surf.gii','ASCII');

%read the curvature and display on mesh
curvature='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.shape.gii';
gcurv = gifti(curvature);

% plot mesh with curvature
figure; plot(gmesh,gcurv)

%%
% HCP Data

% grab a native mesh
DATA='/home/chidi/repos/CFN/DATA';
FILE='/MNINonLinear/Native/100307.L.midthickness.native.surf.gii'
gmesh_hcp = gifti(strcat(DATA,FILE));
figure; plot(gmesh_hcp)

% surface parameters
faces = gmesh_hcp.faces;
vertices = gmesh_hcp.vertices;

% Look at HCP data resting state data in GIFTI format
DATA='/home/chidi/repos/CFN/DATA';
FILE='/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR.L.native.func.gii'
grest_hcp = gifti(strcat(DATA,FILE));






