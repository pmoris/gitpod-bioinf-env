FROM docker.io/gitpod/workspace-base:2023-11-04-12-07-48

USER root

# Install util tools.
RUN apt-get update --quiet && \
    apt-get install --quiet --yes \
        apt-transport-https \
        apt-utils \
        sudo \
        git \
        less \
        wget \
        curl \
        tree \
        graphviz

# User permissions
RUN mkdir -p /workspace/data \
    && chown -R gitpod:gitpod /workspace/data

# create gitpod user
USER gitpod

# install miniconda/mamba using miniforge
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh && \
    bash Miniforge3-Linux-x86_64.sh -b -p "${HOME}/conda" && \
    rm Miniforge3-Linux-x86_64.sh

# source "${HOME}/conda/etc/profile.d/conda.sh"
# # For mamba support also run the following command
# source "${HOME}/conda/etc/profile.d/mamba.sh"

ENV PATH="${HOME}/conda/bin:$PATH"

# Uncomment if we need to pin the Nextflow version
# ENV NXF_EDGE=1
# ENV NXF_VER=22.09.7-edge

# Install nextflow, nf-core, Mamba, and pytest-workflow
RUN conda config --add channels bioconda && \
    mamba install --quiet --yes --name base \
        fastqc \
        bwa \
        samtools \
        vcftools \
        gatk4 \
	sra-tools \
	ffq \
        nextflow \
        nf-core \
        pytest-workflow && \
    mamba clean --all -f -y

RUN unset JAVA_TOOL_OPTIONS

RUN export PS1='\t -> '
