FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04


# File Author / Maintainer
MAINTAINER Laurent Jourdren <jourdren@biologie.ens.fr>

ARG PACKAGE_VERSION=4.5.2
ARG BUILD_PACKAGES="wget apt-transport-https"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt install --yes $BUILD_PACKAGES \
                      libzmq5 \
                      libcurl3 \
                      libhdf5-cpp-11 \
                      libssl1.0.0 \
                      libboost-atomic1.58.0 \
                      libboost-chrono1.58.0 \
                      libboost-date-time1.58.0 \
                      libboost-filesystem1.58.0 \
                      libboost-iostreams1.58.0 \
                      libboost-program-options1.58.0 \
                      libboost-regex1.58.0 \
                      libboost-system1.58.0 \
                       wget curl bzip2 ca-certificates gnupg2 squashfs-tools git \
                      libboost-log1.58.0 && \
    cd /tmp &&\
    wget -q https://mirror.oxfordnanoportal.com/software/analysis/ont_guppy_${PACKAGE_VERSION}-1~xenial_amd64.deb && \
    dpkg -i --ignore-depends=nvidia-384,libcuda1-384 /tmp/ont_guppy_${PACKAGE_VERSION}-1~xenial_amd64.deb && \
    rm *.deb
    ADD . /tmp/repo
    WORKDIR /tmp/repo
    ENV PATH /opt/conda/bin:${PATH}
    ENV LANG C.UTF-8
    ENV SHELL /bin/bash
    RUN /bin/bash -c "curl -L https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh > miniconda.sh && \
        bash miniconda.sh -b -p /opt/conda && \
        rm miniconda.sh"
    RUN /bin/bash -c "conda install -y -c conda-forge mamba && \
        mamba create -q -y -c conda-forge -c bioconda -n snakemake snakemake snakemake-minimal --only-deps && \
        source activate snakemake && \
        mamba install -q -y -c conda-forge singularity && \
        conda clean --all -y && \
        which python && \
        pip install .[reports,messaging,google-cloud]"
    RUN echo "source activate snakemake" > ~/.bashrc
    ENV PATH /opt/conda/envs/snakemake/bin:${PATH}

