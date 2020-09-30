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
%% A : Brief look at NIFTI-2 Header

% cifti overlay for cortical thickness - has both L and R cortex values
ciftioverlay='./DATA/HCP/100307/MNINonLinear/Native/100307.thickness.native.dscalar.nii';

filesize=getfilesize(ciftioverlay);
fprintf('The CIFTI file is stored in NIFTI-2 and is %d bytes in size\n',filesize);
nii2 = read_nifti2_hdr(ciftioverlay);
fprintf('The NIFTI-2 voxel-offset is %d bytes\n',nii2.vox_offset);
fprintf('The NIFTI-2 has %d floats in its data section\n',nii2.dim(7));
fprintf('This is equivalent to %d bytes in its data section\n',nii2.dim(7)*4);
fprintf('data size of %d + vox offset of %d = filesize of %d bytes\n',nii2.vox_offset, nii2.dim(7)*4, filesize);
[exts, extents] = get_nifti2_extents(ciftioverlay);
fprintf('The CIFTI XML is stored in %d bytes\n',extents(1));
fprintf('This is equal to vox_offset %d bytes - 4 extension bytes - %d header bytes\n',nii2.vox_offset,nii2.sizeof_hdr);


%% B  Read CIFTI dscalar of L and R Cortex

ciiall = traverse_cifti(ciftioverlay);
ciixml = get_cifti_xml(ciftioverlay);

%run code as follows if firefox not on path - pass in full path to firefox
%or alternate browser
%ciixml = get_cifti_xml(ciftioverlay,'/usr/bin/firefox');
fprintf('You can view the XML in a browser by directly opening debug.xml.\n')

%% C Find Medial vertices
%find medial vertices - these are removed from the cifti
totverts=ciiall.diminfo{1}.models{1}.numvert;
totverts=[0:totverts-1];
visverts=ciiall.diminfo{1}.models{1}.vertlist;
medialverts = setdiff(totverts, visverts)
fprintf('medial vertices have been stored in variable medialverts. You can view some of these in wb_view\n')
% You can confirm this by opening gifti surface in wb_view

%% D load associated surface and find all the vertices connected and confirm with visualization
% to a particular vertex 119115
mysurf='./DATA/HCP/100307/MNINonLinear/Native/100307.L.midthickness.native.surf.gii';
[neighbors,neighmatlab, allverts, allvertmatlab]=get_neighbors(mysurf, 119115);
visverts=ciiall.diminfo{1}.models{1}.vertlist;
neighindex=ismember(visverts,allverts);
findneighbors=find(neighindex);
thickness = zeros(size(findneighbors,2),2);
thickness = [(visverts(findneighbors))' ciiall.cdata(findneighbors)]
fprintf('cortical thickness values for our selected vertex and close neighbors should match what we saw in wb_view\n')
%% E change cifti and write new thickness values of 2mm

ciiall.cdata(findneighbors)=ones(size(findneighbors))*2;
cifti_write(ciiall,'amended.100307.thickness.native.dscalar.nii')
fprintf('amended.100307.thickness.native.dscalar.nii created.\n')
