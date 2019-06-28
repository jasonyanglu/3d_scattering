## Introduction

Matlab code of 3d scattering

Author: [Yang Lu](https://jasonyanglu.github.io/)

Contact: lylylytc@gmail.com



## Instruction

The 3d scattering is implemented in the framework of [scatnet-0.2](https://www.di.ens.fr/data/software/scatnet/). The 3d scattering components are in the folder scatnet-0.2/3d_scat.

Please add libsvm-3.17 and scatnet-0.2 with all subfolders to the path. Then run

1. generate_scattering.m to generate the scattering features of the hyperspectal image. It will generate a data file like img_scat_J2_L22_M2.mat.
2. run.m to train SVM classifiers with the original hyperspectral image and the scattering features.



## Paper

Please cite the paper if the codes are helpful for you research.

Yuan Yan Tang, Yang Lu, Haoliang Yuan, “Hyperspectral Image Classification Based on Three-Dimensional Scattering Wavelet Transform”, *IEEE Transactions on Geoscience and Remote Sensing (TGRS)*, vol. 53, no. 5, pp. 2467-2480, 2015.