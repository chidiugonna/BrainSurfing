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


%% C Find Medial vertices
%find medial vertices - these are removed from the cifti
totverts=ciiall.diminfo{1}.models{1}.numvert;
totverts=[0:totverts-1];
visverts=ciiall.diminfo{1}.models{1}.vertlist;
medialverts = setdiff(totverts, visverts)
% You can confirm this by opening gifti surface in wb_view

%% D load associated surface and find all the vertices connected and confirm with visualization
% to a particular vertex 119115
mysurf='./DATA/HCP/100307/MNINonLinear/Native/100307.L.midthickness.native.surf.gii';
[neighbors,neighmatlab, allverts, allvertmatlab]=get_neighbors(mysurf, 119115);
visverts=ciiall.diminfo{1}.models{1}.vertlist;
neighindex=ismember(visverts,allverts);
findneighbors=find(neighindex);
thickness = zeros(size(findneighbors,2),2)
thickness = [(visverts(findneighbors))' ciiall.cdata(findneighbors)]

%% E change cifti and write new thickness values of 2mm

ciiall.cdata(findneighbors)=ones(size(findneighbors))*2;
cifti_write(ciiall,'amended.100307.thickness.native.dscalar.nii')

%%  Helper Functions are Defined below
% 
%
%
%
%
%% traverse_cifti : Opens a Cifti file and does a quick traverse of the data 
%
%
%
function ciiall = traverse_cifti(ciftifile)

% open the data using HCP's alpha testing library
ciiall= cifti_read(ciftifile);

format longG
dimensions=size(ciiall.diminfo,2);
fprintf('Cifti file spans %d dimensions\n',dimensions);
for dims=1:dimensions
    
    if strcmp(ciiall.diminfo{dims}.type, 'dense')
        models=size(ciiall.diminfo{dims}.models,2);
        fprintf('Cifti dimension %d  is of type %s and represents %d models\n',dims, 'dense',models);
    else
        fprintf('Cifti dimension %d  is of type %s\n',dims, ciiall.diminfo{dims}.type);
        models=1;
    end

    fprintf('This is actually Dimension  %d in reality in the XML\n',dimensions - dims);
    if dims == 1
       fprintf('This is the COLUMN Mapping\n') 
    else
       fprintf('This is the ROW Mapping\n') 
    end
    
    for mods=1:models
        if strcmp(ciiall.diminfo{dims}.type, 'dense')
            if strcmp(ciiall.diminfo{dims}.models{mods}.type,'surf')
               fprintf('Model %d is a surface of %s with  %d  verts valued out of %d vertices; start from %d and end at %d\n', ...
                        mods, ...
                        ciiall.diminfo{dims}.models{mods}.struct, ...
                        ciiall.diminfo{dims}.models{mods}.count, ...
                        ciiall.diminfo{dims}.models{mods}.numvert, ...
                        ciiall.diminfo{dims}.models{mods}.start, ...
                        ciiall.diminfo{dims}.models{mods}.start + ciiall.diminfo{dims}.models{mods}.count - 1 );
                        
            else
                fprintf('Model %d is a volume of %s with  %d voxels; start from %d and end at %d\n', ...
                        mods, ...
                        ciiall.diminfo{dims}.models{mods}.struct, ...
                        ciiall.diminfo{dims}.models{mods}.count, ...
                        ciiall.diminfo{dims}.models{mods}.start, ...
                        ciiall.diminfo{dims}.models{mods}.start + ciiall.diminfo{dims}.models{mods}.count - 1 );
            end
        else
          fprintf('Data is of type %s with  %d  value per voxel/vertex\n',ciiall.diminfo{dims}.type, ciiall.diminfo{dims}.length)
        end
    end
end
end


%% get_cifti_xml: looks at the Cifti XML
% lets view the xml using ft_open_read in the FieldTrip library

function ciixml = get_cifti_xml(ciftifile, varargin)
ciiallft= ft_read_cifti(ciftifile,'debug','true');
ciixml = xml2struct('debug.xml');

if (~isempty(varargin))
      system(sprintf('%s debug.xml &',string(varargin(1))));
else
    system('firefox debug.xml &');
end

end

%% get_neighbors: gets vertex neighbours
%
function [neighborscifti, neighbors, allvertscifti, allverts] = get_neighbors(mysurf, vertexind)

fprintf('Reading Surface %s\n',mysurf);
mysurfleft_mesh = gifti(mysurf);
fprintf('Surface has %d faces\n',size(mysurfleft_mesh.faces,1));
fprintf('Surface has %d vertices\n',size(mysurfleft_mesh.vertices,1));

% IMPORTANT - unfortunately matlab starts indexing from 1 while wb_view
% indexes from 0!
% so our vertex that was numbered 119115 is actually 119116 in matlab
% so make sure you add 1 to the vertex numbers you get from wb_view
ciftivind=vertexind;

matlabvind=ciftivind + 1;
% find all triplets where vertex is 1st triangle
faces = mysurfleft_mesh.faces;

%combine instead as follows [ind, vol] = find((faces(:,1)==matlabvind));
C=(faces(:,1)==matlabvind);
[ind, vol] = find((C) > 0);
ind1=faces(ind,:);
ind1=ind1(:);

C=(faces(:,2)==matlabvind);
[ind, vol] = find((C) > 0);
ind2=faces(ind,:);
ind2=ind2(:);
 
C=(faces(:,3)==matlabvind);
[ind, vol] = find((C) > 0);
ind3=faces(ind,1:2);
ind3=ind3(:);

allverts=union(ind1,union(ind2,ind3));
neighbors=allverts(allverts ~= matlabvind);
fprintf('The vertices (using Matlab indices) neighboring %d are:\n', matlabvind);
fprintf('%d ',neighbors);
fprintf('\n');

allvertscifti=allverts - 1;
neighborscifti=neighbors - 1;
fprintf('The vertices (using Cifti indices) neighboring %d are:\n', ciftivind);
fprintf('%d ',neighborscifti);
fprintf('\n');
end

%% get file size
%
function filesize = getfilesize(IMAGE1) 
fid = fopen(IMAGE1);
fseek(fid, 0, 'eof');
filesize = ftell(fid);
fclose(fid);
end


%% get nifti extents
%
% read extent codes
function [exts, extent]=get_nifti2_extents(IMAGE1)
fid = fopen(IMAGE1);
hdr = fread(fid,540,'char');
exts = fread(fid,4,'char');
extent = fread(fid,2,'int32');
fclose(fid);
end
