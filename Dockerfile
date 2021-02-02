From ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

#Modified by Joseph Outten in fork https://github.com/itsyosef/READemption
MAINTAINER Konrad Förstner <konrad.foerstner@uni-wuerzburg.de>

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y python3 python3-setuptools python3-pip python3-matplotlib cython3 zlib1g-dev make libncurses5-dev r-base libxml2-dev wget 

RUN apt-get install -y libcurl4-openssl-dev pkg-config

# install HTSlib (may not need all this)
ARG HTSLIB_VERSION=1.9
WORKDIR /opt
RUN wget https://github.com/samtools/htslib/archive/${HTSLIB_VERSION}.tar.gz && \
    tar xzf ${HTSLIB_VERSION}.tar.gz && \
    cd htslib-${HTSLIB_VERSION} && \
    autoheader && \
    autoreconf && \
    ./configure --prefix /opt/htslib/${HTSLIB_VERSION} && \
    make && \
    make install && \
    cd .. && \
    rm ${HTSLIB_VERSION}.tar.gz && \
    rm -rf htslib-${HTSLIB_VERSION}
ENV PATH="/opt/htslib/${HTSLIB_VERSION}/bin:${PATH}"
ENV LD_LIBRARY_PATH="/opt/htslib/${HTSLIB_VERSION}/lib:${LD_LIBRARY_PATH}"
ENV PKG_CONFIG_PATH="/opt/htslib/${HTSLIB_VERSION}/lib/pkgconfig"

WORKDIR /opt

RUN apt-get install -y curl 

RUN curl http://www.bioinf.uni-leipzig.de/Software/segemehl/downloads/segemehl-0.3.4.tar.gz > segemehl-0.3.4.tar.gz && \
    tar xzf segemehl-0.3.4.tar.gz && \
    cd segemehl*/ && make && cd ../ && \
    cp segemehl*/segemehl.x /usr/bin/ && \
    rm -rf segemehl*

#    cp segemehl*/lack.x /usr/bin/  && \
RUN echo 'source("http://bioconductor.org/biocLite.R"); biocLite("DESeq2")' | R --no-save
RUN pip3 install READemption==0.6.0

WORKDIR /opt

