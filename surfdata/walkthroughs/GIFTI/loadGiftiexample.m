% add release library to path
addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release
%% Example
% read and view the GIFTI surface mesh
surfacemesh='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.surf.gii'
gmesh = gifti(surfacemesh);
figure; plot(gmesh)
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

figure
t=ceil(rand(1)*size(grest_hcp.cdata,2))
timeslice=gifti(grest_hcp.cdata(:,t));
plot(gmesh_hcp,timeslice)


%% some mesh queries
% find all vertices that are connected to a particular vertex 17712

vind=17712;
faces = gmesh_hcp.faces;
C=(faces(:,1)==vind);
[ind, vol] = find((C) > 0);
ind1=faces(ind,2:3);
lenz=size(ind1);
ind1=reshape(ind1,lenz(1)*lenz(2),1)';

C=(faces(:,2)==vind);
[ind, vol] = find((C) > 0);
ind2=faces(ind,[1 3]);
lenz=size(ind2);
ind2=reshape(ind2,lenz(1)*lenz(2),1)';
 
C=(faces(:,3)==vind);
[ind, vol] = find((C) > 0);
ind3=faces(ind,1:2);
lenz=size(ind3);
ind3=reshape(ind3,lenz(1)*lenz(2),1)';

adj=union(union(ind1,ind2),ind3)




