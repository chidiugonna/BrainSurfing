# Cifti

## Data
An assortment of CIFTI and GIFTI files are available from OSF:
If you have the python client `osfclient` installed then use:

    osf -p hetgq fetch /Data/HCP .


## Python
Possible free jupyter option is https://colab.research.google.com 


## Matlab
There are libraries available in matlab for working with CIFTI.

This [FAQ](https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ#HCPUsersFAQ-2.HowdoyougetCIFTIfilesintoMATLAB?) from the Human Connectome Project provides 3 approaches for loading CIFTI files. For HCP 

### Approach 1 : For HCP MEG data
The FieldTrip [toolbox](http://www.fieldtriptoolbox.org/download/) provides a matlab library for working with CIFTI files. It is for use with HCP MEG Data. It is not advised for use with MRI data because it pads the CIFTI matrix with **NaN** values however it is a completely independent library. The field trip toolbox functions are prefixed by `ft_` as in [`ft_read_cifti`](http://www.fieldtriptoolbox.org/reference/ft_read_cifti/)

### Approach 2 : For HCP MRI data
From the [HCP FAQ](https://wiki.humanconnectome.org/display/PublicData/HCP+Users+FAQ#HCPUsersFAQ-2.HowdoyougetCIFTIfilesintoMATLAB?) download just the following 3 matlab functions [ciftiopen.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftiopen.m?version=5&modificationDate=1543341721133&api=v2),[ciftisave.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftisave.m?version=4&modificationDate=1543341731171&api=v2) and [ciftisavereset.m](https://wiki.humanconnectome.org/download/attachments/63078513/ciftisavereset.m?version=2&modificationDate=1543341735194&api=v2) and place in your path.

You will need need the gifti matlab library as well. You can download a release version `gifti-zip`from [here](https://www.artefact.tk/software/matlab/gifti/). Unzip to a folder and in matlab add to your path as `addpath /path/to/gifti`

We will also need access to `wb_command`

### Approach 3: Alpha Testing for HCP MRI Data
This [library](https://github.com/Washington-University/cifti-matlab.git)  is in alpha testing phase and is based on the `Field Trip` fieldbox. It should resolve the issues with **Approach 1** but it is still strictly in development and so changes are possible. The field trip library that it is based on is also included in subfolder `ft_cifti`

For this exploration we will proceed with **Approach 3** 

`git clone https://github.com/Washington-University/cifti-matlab.git`

## Container

Singularity and Docker containers with the HCP Workbench are available for exploring CIFTI data.

The singularity image can be run as follows:

`singularity run --nv -B $PWD:/mnt workbench.sif --homedir /mnt wb_view`

The docker image can be run as

`docker run --rm --user=developer -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/developer/.Xauthority -it --net=host --pid=host --ipc=host aacazxnat/workbench:0.1 wb_view`


## Problems with opening wb_view using Docker on gpu enabled computer

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
