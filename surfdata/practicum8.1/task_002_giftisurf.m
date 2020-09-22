%  add GIFTI release library to path
clear
close all
clc
addpath ./matlab-library/gifti-release

%% A. Open HCP Native lh pial mesh
% read and view the GIFTI surface mesh
mysurf='./DATA/HCP/100307/MNINonLinear/Native/100307.L.pial.native.surf.gii';
fprintf('Reading Surface %s\n',mysurf);
mysurfleft_mesh = gifti(mysurf);
fprintf('Surface has %d faces\n',size(mysurfleft_mesh.faces,1));
fprintf('Surface has %d vertices\n',size(mysurfleft_mesh.vertices,1));
% view the right surface
figure; plot(mysurfleft_mesh)

%% B find all the vertices connected and confirm with visualization
% to a particular vertex 119115

% IMPORTANT - unfortunately matlab starts indexing from 1 while wb_view
% indexes from 0!
% so our vertex that was numbered 119115 is actually 119116 in matlab

% this is the index of the vertex from wb_view
ciftivind=119115;

%  we add 1 to the vertex numbers we get from wb_view to use matlab
%  indexing
matlabvind=ciftivind + 1;

% find all triplets where vertex is 1st triangle
faces = mysurfleft_mesh.faces;

%perhaps in future use this construct [vol, ind] = find((faces(:,1)==matlabvind));

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
ind3=faces(ind,:);
ind3=ind3(:);

allVerticesMatlab=union(ind1,union(ind2,ind3));
neighborsMatlab=allVerticesMatlab(allVerticesMatlab ~= matlabvind);
fprintf('The vertices (using Matlab indices) neighboring %d are:\n', matlabvind);
fprintf('%d ',neighborsMatlab);
fprintf('\n');

allVerticesCifti=allVerticesMatlab - 1;
neighborsCifti=neighborsMatlab - 1;
fprintf('The vertices (using workbench indices) neighboring %d are:\n', ciftivind);
fprintf('%d ',neighborsCifti);
fprintf('\n');

%% C Nudge all of the vertex locations by a random amount and create a new GIFTI file
% Note we will need to use the Matlab indices
format shortG
for neighbors=1:size(neighborsMatlab,1)
   vind=neighborsMatlab(neighbors);
   
   %translate x,y,z in random direction between -2 and 2mm
   a=-2;
   b=2;
   dx = a + (b-a).*rand;
   dy = a + (b-a).*rand;
   dz = a + (b-a).*rand;
   X=mysurfleft_mesh.vertices(vind,1);
   Y=mysurfleft_mesh.vertices(vind,2);
   Z=mysurfleft_mesh.vertices(vind,3);
   fprintf('perturbing vertex %d at %d,%d,%d to',vind-1,X,Y,Z);
   mysurfleft_mesh.vertices(vind,1:3)=[X+dx Y+dy Z+dz];
   fprintf(' %d,%d,%d\n',X+dx,Y+dy,Z+dz);
   
end

%Let's save our new gifti - we will save it in Compressed Base 64 binary
%for efficiency
%once saved you can try and open it up in wb_view
save(mysurfleft_mesh,'amended.100307.L.pial.native.surf.gii','GZipBase64Binary');
fprintf('Successfully saved amended GIFTI surface\n')

%% D
% View the XML Metadata of GIFTI using a browser 
% A bit of a long-winded way to see the GIFTI header because xmlread cannot cope with !DOCTYPE
%  save the gifti in ascii format then we can open it in Chrome, Firefox
save(mysurfleft_mesh,'mygifti_allxml.gii','ASCII');
% using firefox to look at the XML on mac or linux (firefox will need to be
% on your path) - if below doesn't work then just open a broser and open
% the file in it.
system('firefox mygifti_allxml.gii &')
fprintf('Look in browser to see Gifti XML or open mygifti_allxml.gii directly in your browser\n')

% Notice that data is read in column-major order
% this means that columns are read before rows


%% OPTIONAL E1
% Load the XML into a structure for reading

% we will need the xml2struct library to read the xml which can 
% obtained from https://www.mathworks.com/matlabcentral/fileexchange/28518-xml2struct
addpath ./matlab-library/xml2struct

% To read XML we may need to remove the DOCTYPE line in the xml - this
% caused errors with my version of matlab 
% if on unix (Mac, Linux) then use sed command to remove 2nd line which is DOCTYPE 

system('sed 2d mygifti_allxml.gii > mygifti_xml.gii &')

% if on windows then will need to do this using powershell
%
% >> !powershell
% Get-Content mygifti_allxml.gii  | Where {$_ -notmatch 'DOCTYPE'} | Set-Content mygifti_xml.gii
% >> exit

%% OPTIONAL E2

myXML = xml2struct('mygifti_xml.gii')
fprintf('Gifti has %d datarrays\n',size(myXML.GIFTI.DataArray,2))
szarray=size(myXML.GIFTI.DataArray,2);

if szarray > 1
    for arraynum=1:szarray
        fprintf('Attributes of DataArray %d',arraynum)
        myXML.GIFTI.DataArray{arraynum}.Attributes
        fprintf('Data stored for DataArray %d',arraynum)    
        myXML.GIFTI.DataArray{arraynum}.Data
    end
else
     fprintf('Attributes of DataArray')
     myXML.GIFTI.DataArray.Attributes
     fprintf('Data stored for DataArray %d',arraynum)    
     myXML.GIFTI.DataArray.Data
end








