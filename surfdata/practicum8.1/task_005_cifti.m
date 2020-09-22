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


%% A: Read CIFTI dtseries of L, R Cortex and Sub-Cortical structures on subsampled mesh
%
ciftioverlay='./DATA/HCP/100307/MNINonLinear/Results/rfMRI_REST1_LR/rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii';
ciiall = traverse_cifti(ciftioverlay);
%run code as follows if firefox not on path - pass in full path to firefox
%or alternate browser
%ciixml = get_cifti_xml(ciftioverlay,'/usr/bin/firefox');

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

% choosing 55,56,30 and find neighbors
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

%% F Save Cifti
%
ciftinew = cifti_struct_create_from_template(ciiall, newcdata, 'dtseries','start',0,'step',1,'unit', 'SECOND'); 
ciftisave(ciftinew,'amended.rfMRI_REST1_LR_Atlas_hp2000_clean.dtseries.nii')


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
filesize = ftell(fid)
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
