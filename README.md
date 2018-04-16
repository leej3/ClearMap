# ClearMap


ClearMap is a toolbox for the analysis and registration of volumetric data
from cleared tissues.

ClearMap is targeted towards large lightsheet volumetric imaging data
of iDISCO+ cleared mouse brains samples, their registration to the Allen brain atlas,
volumetric image processing and statistical analysis.

The method is fully described in this [Cell paper](http://www.cell.com/cell/abstract/S0092-8674%2816%2930555-4).
For further details visit the [iDISCO website](https://idisco.info) and 
the [ClearMap documentation](https://rawgit.com/ChristophKirst/ClearMap/master/docs/_build/html/index.html).


## Installation

### Using Docker

The easiest way to use clearmap is to run it in a docker container. For example, with docker installed on a Unix-like system, to get shell access to an environment with clearmap installed:



    $ docker pull timdanaos/clearmap
    $ docker run -v $PWD:/mnt --rm -ti timdanaos/clearmap

To change to the directory that was being used outside the container and start an ipython session:


    $ cd /mnt
    $ ipython

To import ClearMap:


    In [1]: import ClearMap



### Using Singularity

Singularity is a solution to using ClearMap on HPC systems where Docker cannot be used. To use ClearMap using Singularity:


    $ mkdir ~/temporary_directory_for_singularity
    $ umask 002
    $ singularity pull docker://timdanaos/clearmap
    $ singularity shell -B $PWD:/mnt -H ~/temporary_directory_for_singularity clearmap*img


### ClearMap software development with containers

For the development of ClearMap, this repository can be mounted in the container so that changes made to the code can be run in the context of the working container.
For example in docker:


    $ docker run  -v [absolute_path_to_repo]:/opt/conda/src/clearmap/ timdanaos/clearmap


In singularity:

    $ singularity shell -B $PWD:/mnt -B [absolute_path_to_repo]:/opt/conda/src/clearmap/ -H ~/temporary_directory_for_singularity [path_to_clearmap_image]




### Manual installation

Install ClearMap by first cloning this repository.

See [GIT.md](https://github.com/ChristophKirst/ClearMap/blob/master/GIT.md) for basic help with git.

If you want to register data to reference images via elastix or
classify pixels via ilastik configure the /ClearMap/Settings.py file.

You will most likely also need to install several python packages e.g. via 
pip or apt-get.

See the [documentation](https://rawgit.com/ChristophKirst/ClearMap/master/docs/_build/html/index.html) for more details.

Additional files for mouse brain registration can be found on the `[iDISCO website](https://idisco.info/).


## Quickstart

* see the template scripts in the [./ClearMap/Scripts](https://github.com/ChristophKirst/ClearMap/tree/master/ClearMap/Scripts) folder 
* see the [ClearMap documentation](https://rawgit.com/ChristophKirst/ClearMap/master/docs/_build/html/index.html)


## Copyright
    (c) 2016 Christoph Kirst
    The Rockefeller University, 
    ckirst@rockefeller.edu

## License
    GPLv3, see LICENSE.txt for details.



