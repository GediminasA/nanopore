FROM nvidia/cuda:11.2.2-cudnn8-devel-ubuntu18.04


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
sudo apt-get -y  update  && \
sudo apt-get -y update && \
sudo apt-get -y install ont-guppy


