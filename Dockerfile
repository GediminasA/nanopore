FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu18.04
RUN ln -sf /bin/bash /bin/sh
ENV PATH /root/miniconda3/bin:${PATH}
ENV LANG C.UTF-8
ENV SHELL /bin/bash

# File Author / Maintainer
MAINTAINER Laurent Jourdren <jourdren@biologie.ens.fr>

ARG PACKAGE_VERSION=4.5.2
ARG BUILD_PACKAGES="wget apt-transport-https"
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get -y update && \
apt-get -y install wget lsb-release && \
export PLATFORM=$(lsb_release -cs) && \
wget -O- https://mirror.oxfordnanoportal.com/apt/ont-repo.pub | apt-key add -  && \
echo "deb http://mirror.oxfordnanoportal.com/apt ${PLATFORM}-stable non-free" | tee /etc/apt/sources.list.d/nanoporetech.sources.list  && \
apt-get -y  update  && \
apt-get -y update && \
apt-get -y install ont-guppy

RUN apt-get -y install curl && \
    curl -L https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > miniconda.sh && \
    bash miniconda.sh -b -&& \
    rm miniconda.sh && \
    /root/miniconda3/bin/conda init bash && \
    echo "Conda1:" 

RUN conda install -y -c conda-forge mamba && \
    mamba create -q -y -c conda-forge -c bioconda -n snakemake snakemake snakemake-minimal  && \
    source activate snakemake && \
    mamba install -y -c conda-forge singularity && \
    pip install reports messaging google-cloud && \
    mamba install -y -c bioconda -c conda-forge  qualimap multiqc samtools

RUN echo "conda activate snakemake" >> /root/.bashrc
ENV PATH /root/miniconda3/envs/snakemake/bin:${PATH}
##Cud
sudo rm /etc/apt/sources.list.d/cuda* && \
sudo apt remove --autoremove nvidia-cuda-toolkit && \
sudo apt remove --autoremove nvidia-* && \
sudo apt update && \
sudo add-apt-repository ppa:graphics-drivers && \
sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub && \
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list' && \
sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda_learn.list' && \
sudo apt install cuda-11-4 && \
sudo apt install libcudnn8
   
   
    

