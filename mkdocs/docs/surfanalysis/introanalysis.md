# Working with Surface-based Formats

## Surface Processing

## Sulc - Freesurfer Pipeline Review 
A really helpful review of the freesurfer pipeline is provided by Doug Greve in [Part 1](https://www.youtube.com/watch?v=8Ict0Erh7_c&t=28s) and [Part 2](https://www.youtube.com/watch?v=KncPouQWAp0) of the 2013 Freesurfer course.

### The Pipeline outputs
Quick review of the freesurfer pipeline detailing the created volumes and surfaces.

* Volumetric pipeline - from T1w > orig.mgz > T1.mgz > brainmask.mgz > aseg.mgz > wm.mgz

* Surface pipeline - from wm.mgz > lh.orig > lh.white > lh.pial etc..

### Medial layer
Each hemisphere analysed separately. Medial wall of hemosphere has non-cortical areas (subcortical structures. corpus callosum) and so to retain closed Spherical Topology the medial layer is usually enclosed in the white and pial layers and is masked out during analysis.

### Error Checking
Initial pial and white surfaces are critical for rest of pipeline - good to learn how to apply some quality control and manual editting if possible. Also good to review volumetric steps like segmentation, skull stripping that may have been erroneous

### Vertex Correspondence
In the same subject, vertices in each of the hemispheric surfaces correspond. So vertex 22 in lh.pial will have been created by nudging vertex 22 in the lh.white and so on. However there is no correspondence between different hemispheres or between different subjects in this native space.

!!! Note

    Freesurfer took the engineering choice to relax vertex alignment at the subject level to prevent bias in vertex sampling and enable all subjects to have the same sampling density regardless of anatomical variability. 

### Overlays
Some important overlays are created as part of the Freesurfer pipeline that aid with registration
* curv - 3D mean curvature of the vertex - average of the principal curvatures which are maximum bending and minimum bending curvature.

* sulc - dot product of movement vector during inflation and the surface normal - megative if gyral, positive if sulcal - reveals large scale geometric features of the cortex better than mean curvature which has a lot of highfrequency information that is not as good for intersubject registration.

* thickness - 

### Standard Spaces and Registration
Mesh in native space - would be good to register all subjects to a standard space. In Freesurfer this is the fsaverage,  spherical template which has been created from 40 subjects.

#### 2D Surface Coordinate System
Analogous to volumetric coordinate system in 3D. The Cortical sheet is cut in several places to turn it into a flat map. Most easilly visualzied however as a sphere using 2D coordinate system of latitude and longitude - just like the earth - this latter approach is continuous without cuts and has a value represented at each point. Spheres are obtained by inflating the surface until it is as spherical as possible with minimal distortion. The fsaverage mesh and the sulc and curv overlays can be used to register subjects to the same space for comparison.


### Smoothing
Smoothing on the surface increase SNR and to improve intersubject registration. Smoothing kernels chosen by convention to be about 10mm - by matched filter theory would smoothing using a kernel size that matched the expected "blob" but not clear what this size is and it will also vary across space. Smoothing on the Surface is more accurate than in the volume as it avoids mixing signals across sulci/gyri boundaries. Quote references to demonstrate the advantages of surface smoothing - for example Doug Greve showed an asymmetric fmri study of serotonin receptors that demonstrated much more realistic activation after surface smoothing using a range of kernels.

### Surface-based Clustering and Multiple Comparisons
Clusters in surface space are planar entities with area - this improves power as our correction for multiple comparisons is less severe as the search space is smaller - number of tests is reduced.

## Beyond Sulc - HCP Pipeline Review 