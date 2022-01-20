FROM ubuntu:20.04
LABEL authors="Joyce Wangari and Okeyo Allan " \
      description="Docker image packaged with all software and tools for running the variant calling pipeline"


# Install dependencies
RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc
    
 
# Install the conda environment
COPY /environment.yml /
RUN conda env create --quiet -f /environment.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/var/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name var-call > variant-call.yml


ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
