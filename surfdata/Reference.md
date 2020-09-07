

## Schedule
Class [Homepage](https://d2l.arizona.edu/d2l/home/924931)

| Date   |   Title    | Description        |
| ---    |  ---       | ---                |
| Oct 13 | Intro to Surface-based Image Formats     |   Quick overview of surface-based formats (NIFTI-2, GIFTI and CIFTI) and their utility  |  
| Oct 20 | Working with Surface-based Image Formats | Introduction to manipulating and analysing surface-based formats     |

## Links to class materials

Class (Slides)[https://drive.google.com/drive/folders/1T380VMVZLCijBHTlmxv1E1CKJOdfosrU]

Reading (List)[https://drive.google.com/drive/folders/1CFM3Od6_1XVESm5Z8NtyOIl4uev-y0-G]


## Appendix 1 : Using osfclient  
Guide is available [here](https://osfclient.readthedocs.io/en/latest/cli-usage.html)


### install osfclient

    pip install --user osfclient

### dicoms

[here](https://osf.io/5q8fb/)

    osf -p rghtc fetch /Data/dicoms_heudiconv.zip dicoms_heudiconv.zip

### nifti
download `sub-219_bids_datalad.zip` manually from [here](https://osf.io/r5w93/)

    osf -p rghtc fetch /Data/sub-219_bids_datalad.zip sub-219_bids_datalad.zip

### fmriprep
download `sub-219_fmriprep.zip` manually from [here](https://osf.io/jftsg/)

    osf -p rghtc fetch /Data/sub-219_fmriprep.zip sub-219_fmriprep.zip


### Hcp

upload 

    osf -u chidiugonna@email.arizona.edu -p hetgq upload MNINonLinear.zip /Data/HCP/MNINonLinear.zip

download

    osf -p hetgq fetch /Data/HCP/MNINonLinear.zip /Data/HCP/MNINonLinear.zip
    osf -p hetgq fetch /Data/HCP/T1w.zip /Data/HCP/T1w.zip

