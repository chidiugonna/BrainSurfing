clear
close all
clc

% add path to HCP cifti-matlab library - in alpha testing stage
addpath ./matlab-library/cifti-matlab

% addpath to FieldTrip
addpath ./matlab-library/cifti-matlab/ft_cifti

%  add GIFTI release library to path
addpath ./matlab-library/gifti-release

% add path to xml2struct
addpath ./matlab-library/xml2struct

% add path to helper functions
addpath ./matlab-library/helper-functions

fprintf('libraries added to path.\n')

%% A: Read CIFTI dtseries of L, R Cortex and Sub-Cortical structures on subsampled mesh
%
ciftioverlay='./DATA/HCP/100307/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii';
ciiall = traverse_cifti(ciftioverlay);
ciixml = get_cifti_xml(ciftioverlay,'/usr/bin/firefoxchop');
%run code as follows if firefox not on path - pass in full path to firefox
%or alternate browser
%ciixml = get_cifti_xml(ciftioverlay,'/usr/bin/firefox');
fprintf('You can view the XML in a browser by directly opening debug.xml.\n')
%% B Find neighbors to vertex 17617 
%
mysurf='./DATA/HCP/100307/MNINonLinear/fsaverage_LR32k/100307.R.midthickness.32k_fs_LR.surf.gii';
[neighbors,neighmatlab, allverts, allvertmatlab]=get_neighbors(mysurf, 17617);
visverts=ciiall.diminfo{1}.models{2}.vertlist;
neighindex=ismember(visverts,allverts);

findneighbors=find(neighindex);

%offset into Right Hemosphere
findRHneighbors=findneighbors + ciiall.diminfo{1}.models{2}.start -1;
figure;
plot(ciiall.cdata(findRHneighbors,:)')

%% C Find neighbors to vertex 8470
%
mysurf='./DATA/HCP/100307/MNINonLinear/fsaverage_LR32k/100307.R.midthickness.32k_fs_LR.surf.gii';
[neighborsA,neighmatlabA, allvertsA, allvertmatlabA]=get_neighbors(mysurf, 8470);
visvertsA=ciiall.diminfo{1}.models{2}.vertlist;
neighindexA=ismember(visvertsA,allvertsA);

findneighborsA=find(neighindexA);

%offset into Right Hemosphere
findRHneighborsA=findneighborsA + ciiall.diminfo{1}.models{2}.start -1;
figure;
plot(ciiall.cdata(findRHneighborsA,:)')


%% D Find neighbors to voxel 
% left Hippocampus is represented by model 14
ciiall.diminfo{1}.models{14}

%The list of voxels are in voxlist
ciiall.diminfo{1}.models{14}.voxlist;

% range of voxel coordinates
xrange=[min(ciiall.diminfo{1}.models{14}.voxlist(1,:)) max(ciiall.diminfo{1}.models{14}.voxlist(1,:))];
yrange=[min(ciiall.diminfo{1}.models{14}.voxlist(2,:)) max(ciiall.diminfo{1}.models{14}.voxlist(2,:))];
zrange=[min(ciiall.diminfo{1}.models{14}.voxlist(3,:)) max(ciiall.diminfo{1}.models{14}.voxlist(3,:))];

% choosing 56,56,25 and find neighbors
XO=56; YO=56; ZO=25;

voxexists=sum(ismember(ciiall.diminfo{1}.models{14}.voxlist', [XO YO ZO], 'rows'));

if ~voxexists 
    fprintf('Your choice of voxel %d,%d,%d is not in the structure. You may not find valid neighbors.\n',XO,YO,ZO)
else
    fprintf('Your choice of voxel %d,%d,%d is present in the structure.\n',XO,YO,ZO)
end

[X,Y,Z] = meshgrid(-1:1,-1:1,-1:1);
XX=X(:)+XO;
YY=Y(:)+YO;
ZZ=Z(:)+ZO;

neighvoxes=[XX YY ZZ];
voxneighindex=ismember(ciiall.diminfo{1}.models{14}.voxlist', neighvoxes, 'rows');
fprintf('found %d neighbors to chosen voxel\n',sum(voxneighindex) - 1)
findvoxneighbors=find(voxneighindex);

ciiall.diminfo{1}.models{14}.voxlist(:,findvoxneighbors)';

%offset into Hippocampus
findHipponeighbors=findvoxneighbors + ciiall.diminfo{1}.models{14}.start - 1;
figure;
plot(ciiall.cdata(findHipponeighbors,:)')


%% E Create Functionally connected zone in Right Cortex (17617) to aother vertex in right cortex (8470) 
% Remember that 8470 is indexed as 38167 in cdata (i.e. ciiall.diminfo{1}.models{2}.start + 8470)
%

% simulate fMRI signal
signalprint=15000 + 700*rand(1,1200);

newcdata=ciiall.cdata;

%copy signal into vertex 17617 and neighbors
newcdata(findRHneighbors,:)=ones(length(findRHneighbors),1200).*signalprint;

% copy signal into voxel 8470 and neighbors
newcdata(findRHneighborsA,:)=ones(length(findRHneighborsA),1200).*signalprint;

% copy signal into L Hippo voxel and neighbors
newcdata(findHipponeighbors,:)=ones(length(findHipponeighbors),1200).*signalprint;

fprintf('functional connection artificially created between vertices and voxel.\n')

%% F Save Cifti
%
ciftinew = cifti_struct_create_from_template(ciiall, newcdata, 'dtseries','start',0,'step',1,'unit', 'SECOND'); 
ciftisave(ciftinew,'amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii')
fprintf('amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii created.\n')

