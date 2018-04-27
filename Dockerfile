# Creates docker container that runs afqbrowser
#
# Example usage: XXX
#   docker run --rm -ti \
#       -v <aFolderWithAfqMAT>:/flywheel/v0/input \
#       -v <emptyOutputFolder>:/flywheel/v0/output \
#       scitran/afqbrowser

# Start with an ubuntu image
FROM ubuntu:14.04
MAINTAINER Michael Perry <lmperry@stanford.edu>

# Install packages
RUN apt-get update -qq \
    && apt-get install -y \
    git \
    python-dev \
    libblas-dev \
    liblapack-dev \
    libatlas-base-dev \
    gfortran \
    python-numpy \
    python-pandas \
    python-scipy \
    python-pip 

# We need to start by upgrading setuptools, or run into https://github.com/yeatmanlab/AFQ-Browser/issues/101
RUN pip install --upgrade setuptools 
# Install AFQ-Browser from my branch:
RUN pip install git+https://github.com/arokem/AFQ-Browser.git@pathlib

ENV BUSTCACHE 2

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
RUN mkdir -p ${FLYWHEEL}
WORKDIR ${FLYWHEEL}

# Add manifest
COPY manifest.json ${FLYWHEEL}/manifest.json
# Add run file 
COPY run ${FLYWHEEL}/run  

# Configure entrypoint
ENTRYPOINT ["/flywheel/v0/run"]