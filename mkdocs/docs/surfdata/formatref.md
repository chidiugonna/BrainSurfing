# Neuroimaging Data Formats

## DICOM

Dicom information stored as tags. The Patient Coordinate System (PCS) is usually defined in LPS+ format but this could be different depending on the [Anatomical Orientation Type Field (0010,2210)]https://nipy.org/nibabel/dicom/dicom_orientation.html. The pixel data (7FE0, 0010) is mapped into a 3D matrix in voxel space using additional information from the fields  Image Position (0020,0032)  and  Image Orientation (0020,0037). This data is mapped for each image plane in row-major order from left to right, top to bottom.

## Nifti-1

### References

Brainder blog has a nice detailed descrption of [Nifti-2](https://brainder.org/2015/04/03/the-nifti-2-file-format/Blog) and [Nifti-1](https://brainder.org/2012/09/23/the-nifti-file-format/)


## Gifti

### Gifti Library
This library is matlab based and in addition to standard Gifti files with extension `.gii` can read in and export to a range of surface file formats like freesurfer `.pial`, `.sphere`, `.white`, `.surf`, `.curv` etc, as well as matlab `.mat` files, `.vtk` files and several others. This library is integrated into `SPM`.

You can download a release version `gifti-zip`from [here](https://www.artefact.tk/software/matlab/gifti/)

In linux command shell you can do:

    cd library
    wget https://github.com/gllmflndn/gifti/archive/master.zip
    unzip master.zip
    rm master.zip
    mv gifti-master gifti-release


For development updates, usage and to get latest code go to [github](https://github.com/gllmflndn/gifti.git) page.

    cd library
    git clone https://github.com/gllmflndn/gifti.git
    mv gifti gifti-latest
    
### Open Gifti File example

    % add release library to path
    addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release
    
    % read and view the GIFTI surface mesh
    surfacemesh='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.surf.gii'
    gmesh = gifti(surfacemesh);
    figure; plot(gmesh)
    
    %read the curvature and display on mesh
    curvature='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.shape.gii';
    gcurv = gifti(curvature);
    
    % plot mesh with curvature
    figure; plot(gmesh,gcurv)


### Create Gifti File example

    % add release library to path
    addpath /home/chidi/repos/CFN/SurfaceFormat/library/gifti-release
    
    load mri
    D = squeeze(D);
    Ds = smooth3(D);
    g = gifti(isosurface(Ds,5))
      
    h = plot(g);
    daspect([1,1,.4]); view(45,30); axis tight
    lightangle(45,30);
    set(h,'SpecularColorReflectance',0,'SpecularExponent',50)
       
    save(g,'mri.surf.gii','Base64Binary');
    
    gmri = gifti('mri.surf.gii');
    figure; plot(gmri)

### Viewing the XML header
The gifti file itself is basically a large xml file that describes th metadata and data contained for the surface. In ASCII format then it is simple enough to just open it in a text editor and peruse the contents. In some cases the data is encoded as Base64 binary and compressed which the gifti library can manage. In order to see the xml header for files that are not ascii then you can simple open the gifti and then resave it as an ascii gifti as follows

    surfacemesh='./exampleData/BV_GIFTI/GzipBase64/sujet01_Lwhite.surf.gii'
    gmesh = gifti(surfacemesh);
    save(gmesh,'asAscii.gii','ASCII');



## Nifti-2


### References

Brainder blog has a nice detailed descrption of [Nifti-2](https://brainder.org/2015/04/03/the-nifti-2-file-format/Blog) and [Nifti-1](https://brainder.org/2012/09/23/the-nifti-file-format/)

## Cifti

### Data
An assortment of CIFTI and GIFTI files are available from OSF:
If you have the python client `osfclient` installed then use:

    osf -p hetgq fetch /Data/HCP .


### Python
Possible free jupyter option is https://colab.research.google.com 


### Matlab
There are libraries available in matlab for working with CIFTI.

This [FAQ](https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ#HCPUsersFAQ-2.HowdoyougetCIFTIfilesintoMATLAB?) from the Human Connectome Project provides 3 approaches for loading CIFTI files. For HCP 

#### Approach 1 : For HCP MEG data
The FieldTrip [toolbox](http://www.fieldtriptoolbox.org/download/) provides a matlab library for working with CIFTI files. It is for use with HCP MEG Data. It is not advised for use with MRI data because it pads the CIFTI matrix with **NaN** values however it is a completely independent library. The field trip toolbox functions are prefixed by `ft_` as in [`ft_read_cifti`](http://www.fieldtriptoolbox.org/reference/ft_read_cifti/)

#### Approach 2 : For HCP MRI data
From the [HCP FAQ](https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ#HCPUsersFAQ-2.HowdoyougetCIFTIfilesintoMATLAB?) download just the following 3 matlab functions [ciftiopen.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftiopen.m?version=5&modificationDate=1543341721133&api=v2),[ciftisave.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftisave.m?version=4&modificationDate=1543341731171&api=v2) and [ciftisavereset.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftisavereset.m?version=2&modificationDate=1543341735194&api=v2) and place in your path.

You will need need the gifti matlab library as well. You can download a release version `gifti-zip`from [here](https://www.artefact.tk/software/matlab/gifti/). Unzip to a folder and in matlab add to your path as `addpath /path/to/gifti`

We will also need access to `wb_command`

#### Approach 3: Alpha Testing for HCP MRI Data
This [library](https://github.com/Washington-University/cifti-matlab.git)  is in alpha testing phase and is based on the `Field Trip` fieldbox. It should resolve the issues with **Approach 1** but it is still strictly in development and so changes are possible. The field trip library that it is based on is also included in subfolder `ft_cifti`

For this exploration we will proceed with **Approach 3** 

`git clone https://github.com/Washington-University/cifti-matlab.git`

### Container

Singularity and Docker containers with the HCP Workbench are available for exploring CIFTI data.

The singularity image can be run as follows:

`singularity run --nv -B $PWD:/mnt workbench.sif --homedir /mnt wb_view`

The docker image can be run as

`docker run --rm --user=developer -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/developer/.Xauthority -it --net=host --pid=host --ipc=host aacazxnat/workbench:0.1 wb_view`


### Problems with opening wb_view using Docker on gpu enabled computer

You will need to add Nvidia-Docker to your system. See [Github](https://github.com/NVIDIA/nvidia-docker) for instructions for installation which are replicated below:

    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list |     sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    
    sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
    sudo systemctl restart docker

Test nvidia-smi with the latest official CUDA image

     docker run --gpus all nvidia/cuda:10.2-base nvidia-smi

Now try the gpu image:

`docker run --gpus all --rm --user=developer -e DISPLAY=$DISPLAY -v /usr/lib/nvidia:/usr/lib/nvidia -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME:/mnt -v $HOME/.Xauthority:/home/developer/.Xauthority -it --net=host --pid=host  --device /dev/dri  --ipc=host --privileged aacazxnat/workbenchgpu_runtime:0.1 --homedir /mnt wb_view`
