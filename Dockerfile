FROM debian:jessie
MAINTAINER dave@axiomdatascience.com

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    wget

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda-3.10.1-Linux-x86_64.sh && \
    /bin/bash /Miniconda-3.10.1-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda-3.10.1-Linux-x86_64.sh && \
    /opt/conda/bin/conda install --yes conda==3.14.1

ENV PATH /opt/conda/bin:$PATH

COPY conda-requirements.txt /tmp/
RUN conda install \
    --channel daf \
    --channel ioos \
    --channel prometeia \
    --file /tmp/conda-requirements.txt

RUN mkdir -p /srv/oillib
COPY . /srv/oillib
WORKDIR /srv/oillib
RUN python setup.py develop

CMD pserve --reload container.ini

EXPOSE 9898

