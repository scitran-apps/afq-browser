# Creates docker container that runs dcm2niix
#
# Example usage:
#   docker run --rm -ti \
#       -v <someDirWithDicoms>:/flywheel/v0/input/dcm2niix_input \
#       -v <emptyOutputFolder>:/flywheel/v0/output \
#       scitran/afqbrowser
#
#

# Start with neurodebian image
FROM neurodebian:trusty
MAINTAINER Michael Perry <lmperry@stanford.edu>

# Install packages
RUN apt-get update -qq \
    && apt-get install -y \
    git \
    python

# Install AFQ-Browser
RUN pip install afq-browser

# Make directory for flywheel spec (v0)
ENV FLYWHEEL /flywheel/v0
WORKDIR ${FLYWHEEL}

# Add manifest
COPY manifest.json ${FLYWHEEL}/manifest.json

# Configure entrypoint
ENTRYPOINT ["/flywheel/v0/run.py"]