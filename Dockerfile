FROM ubuntu:16.04

ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" \
    ENTRYPOINT_SCRIPT="/entrypoint/startup.sh"

# Prepare environment
RUN apt-get update \
    && apt-get install -y --no-install-recommends --allow-unauthenticated \
                    curl \
                    bzip2 \
                    ca-certificates \
                    cython3 \
                    build-essential \
                    autoconf \
                    libtool \
                    pkg-config \
                    libsm6 \
                    elastix \
                    libxext6 \
                    libxrender1 \
                    vim

RUN chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /entrypoint \
    && if [ ! -f "$ENTRYPOINT_SCRIPT" ]; then \
         echo '#!/usr/bin/env bash' >> $ENTRYPOINT_SCRIPT \
         && echo 'set +x' >> $ENTRYPOINT_SCRIPT \
         && echo 'if [ -z "$*" ]; then /usr/bin/env bash; else $*; fi' >> $ENTRYPOINT_SCRIPT; \
       fi \
    && chmod -R 777 /entrypoint && chmod a+s /entrypoint


ENTRYPOINT ["/entrypoint/startup.sh"]

# Create new user: neuro
RUN useradd --no-user-group --create-home --shell /bin/bash neuro
USER neuro
RUN mkdir -p /opt/conda/src/clearmap
RUN mkdir /opt/conda/src/ilastik
RUN cd /opt/conda/src/ilastik  \
    && curl http://files.ilastik.org/ilastik-1.3.0-Linux.tar.bz2 >ilastik.tar.bz2 \
    && tar xjf ilastik.tar.bz2 \
    && sync \
    && rm ilastik.tar.bz2

#------------------
# Install Miniconda
#------------------

ENV CONDA_DIR=/opt/conda \
    PATH=/opt/conda/bin:$PATH
RUN echo "Downloading Miniconda installer ..." \
    && miniconda_installer=/tmp/miniconda.sh \
    && curl -sSL --retry 5 -o $miniconda_installer https://repo.continuum.io/miniconda/Miniconda2-latest-Linux-x86_64.sh \
    && /bin/bash $miniconda_installer -u -b -p $CONDA_DIR \
    && rm -f $miniconda_installer \
    && conda config --system --prepend channels conda-forge \
    && conda config --system --set auto_update_conda false \
    && conda config --system --set show_channel_urls true \
    && conda update -n base conda \
    && conda clean -tipsy && sync

# Installing precomputed python packages
RUN conda install -c conda-forge -y openblas=0.2.14; \
    sync && \
    conda install -c conda-forge -y \
    cython=0.23.1 \
    h5py=2.6.0 \
    mahotas \
    matplotlib \
    numpy \
    opencv=2.4.10 \
    scikit-image=0.12.3 \
    scipy=0.16.0 \
    natsort \
    tifffile \
    ipython \
    libgfortran==1 \
    ; \
    sync \
    && conda clean -tipsy && sync

RUN python -c "from matplotlib import font_manager"

# Installing clearmap
ENV CLEARMAP_CONTAINER="yes"
USER root
WORKDIR /opt/conda/src/clearmap
COPY . /opt/conda/src/clearmap
RUN  pip install -e . && \
    rm -rf ~/.cache/pip
RUN chmod -R a+rX /opt/conda/src/clearmap && \
    chmod +x /opt/conda/bin/*



