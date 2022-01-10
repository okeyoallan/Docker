FROM ubuntu:20.04

LABEL  maintainer "Okeyo Allan, <okeyoallan8@gmail.com>" \
       		  "Joyce Wangari, <wangarijoyce.jw@gmail.com>" \
       description "Variant calling pipeline with GATK4" \
       version "1.0"
      
# package required dependencies
RUN apt-get update --fix-missing -qq && apt-get install -y -q \
    curl \
    wget \
    locales \
    libncurses5-dev \
    libncursesw5-dev \
    build-essential \
    pkg-config \
    zlib1g-dev \
    bzip2 \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz && \
    tar -xzf jdk-17_linux-x64_bin.tar.gz \
    update --alternatives  

# Install samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.14/samtools-1.14.tar.bz2 && \
	tar -xf samtools-1.14.tar.bz2 && \
	cd samtools-1.14 && \
	./configure --prefix=/bin/ && \	
	make && \
	make install

# Install bcftools
RUN wget https://github.com/samtools/bcftools/releases/download/1.14/bcftools-1.14.tar.bz2 && \
	tar -xf bcftools-1.14.tar.bz2 && \
	cd bcftools-1.14 && \
	./configure --prefix=/bin/ && \
	make && \
	make install 

# Install htslib
RUN wget https://github.com/samtools/htslib/releases/download/1.14/htslib-1.14.tar.bz2 | tar -xf htslib-1.14.tar.bz2 && \
	cd htslib-1.14 && \
	./configure --prefix=/bin && \
	make && make install 

# Install vcftools
RUN wget https://sourceforge.net/projects/vcftools/files/vcftools_0.1.13.tar.gz/download | tar -xzf vcftools_0.1.13.tar.gz \
	rm vcftools_0.1.13.tar.gz && \
	cd vcftools_0.1.13 && \
	./configure --prefix=/bin/ && \
	make && \
	make install 


# Install BWA
RUN sudo apt update && \
	sudo apt install bwa

# Install fastqc
RUN wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip && \
	unzip fastqc_v0.11.9.zip && \
	cd fastqc_v0.11.9 \
	./configure --prefix=/bin/ && \
	make && \
	make install 

# Install GATK4
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.2.4.1/gatk-4.2.4.1.zip && \
	unzip gatk-4.2.4.1.zip && \
	cd gatk-4.2.4.1 && \ 
	./configure --prefix=/bin/ && \
	make && \
	make install 

# Install trimmomatic
RUN sudo apt-get update -y && \
     sudo apt-get install -y trimmomatic
#Install SNPeff
RUN wget https://snpeff.blob.core.windows.net/versions/snpEff_latest_core.zip && \
	unzip snpEff_latest_core.zip \
	./confirgure --prefix=/bin/ && \
	make \
	make install  

RUN useradd --create-home --shell /bin/bash ubuntu && \
  chown -R ubuntu:ubuntu /home/ubuntu

USER ubuntu

CMD ["/bin/bash","-i"]
