FROM debian:stable
LABEL authors="Joyce Wangari and Okeyo Allan " \
      description="Docker image packaged with all software and tools for running the variant calling pipeline"

# Install the conda environment
COPY ./environment.yml /
RUN conda env create --quiet -f /environment.yml && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/var/bin:$PATH

# Dump the details of the installed packages to a file for posterity
RUN conda env export --name var-call > variant-call.yml
