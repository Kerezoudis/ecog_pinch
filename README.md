# ecog_pinch
ECoG data comparing pinch with individual finger flexion

This repository contains all the MATLAB functions necessary to reproduce the analysis and figures
included in the manuscript on spatial overlap between thumb-index pinch and individual finger 
flexion in patients with medically refractory epilepsy implanted with subdural electrocorticography
grids.

If you use the code in your publications, please cite the following bibliography: 
- Kerezoudis, P., Jensen, M.A., Huang, H., Ojemann, J.G., Klassen, B.T., Ince, N.F., Hermes, D. and Miller, K.J., 2024.
  Spatial and spectral changes in cortical surface Potentials during pinching versus Thumb and index finger flexion. Neuroscience Letters, p.138062.
- Miller, K. J. (2019). A library of human electrocorticographic data and analyses. Nature human behaviour, 3(11), 1225-1235.

All the data used for analysis are available in the open access library, available at https://searchworks.stanford.edu/view/zk881ps0522. 
The data are contained in the gestures folder. 

Please refer to the document in the repository titled "pk_sharing_statement" for more details on the data sharing agreement, 
the structure of the curated data and the pipeline for running the analysis on your personal computer. 

The curated data are available for download at Open Science Framework. 
link: https://osf.io/jy6ve/?view_only=b5f4c3b93df641a6add0ebc115047900 

The data are organized into two main folders: (1) fingerflex and (2) pinch, corresponding to the two behavioral paradigms. 
Each folder contains a sub-folder, named after the 2-letter code for each subject. 
Each sub-folder contains the following components: 
  - a file named "_fingerflex.mat" or "_pinch.mat", that contains the intracranial neural data, the data glove behavioral vector and the stimulus vector.
  - a file named "_beh.mat.", that contains the segmented behavioral data.
  - a file named "_brain.mat", that contains the 3D electrode coordinated in native space, and a struct variable/surface object, with vertices and faces, to plot 3D brain renderings.
  - a folder named "figs", where figures from running the master file, will be saved at. 

If you have any questions or concerns, please email me at 
kerezoudis.panagiotis@mayo.edu. 

Have fun coding and learning!

