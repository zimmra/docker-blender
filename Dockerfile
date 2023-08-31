# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# app title
ENV TITLE=FreeCAD

# Add FreeCAD PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:freecad-maintainers/freecad-stable

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install -y \
    build-essential \
    cmake \
    libtool \
    lsb-release \
    python3 \
    swig \
    libboost-dev \
    libboost-date-time-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-python-dev \
    libboost-regex-dev \
    libboost-serialization-dev \
    libboost-thread-dev \
    libcoin-dev \
    libeigen3-dev \
    libgts-bin \
    libgts-dev \
    libkdtree++-dev \
    libmedc-dev \
    libopencv-dev \
    libproj-dev \
    libvtk6-dev \
    libx11-dev \
    libxerces-c-dev \
    libzipios++-dev \
    qtbase5-dev \
    qttools5-dev \
    qt5-default \
    libqt5opengl5-dev \
    libqt5svg5-dev \
    qtwebengine5-dev \
    libqt5xmlpatterns5-dev \
    libqt5x11extras5-dev \
    libpyside2-dev \
    libshiboken2-dev \
    pyside2-tools \
    pyqt5-dev-tools \
    python3-dev \
    python3-matplotlib \
    python3-packaging \
    python3-pivy \
    python3-ply \
    python3-pyside2.qtcore \
    python3-pyside2.qtgui \
    python3-pyside2.qtsvg \
    python3-pyside2.qtwidgets \
    python3-pyside2.qtnetwork \
    python3-pyside2.qtwebengine \
    python3-pyside2.qtwebenginecore \
    python3-pyside2.qtwebenginewidgets \
    python3-pyside2.qtwebchannel \
    libocct*-dev \
    libocct-data-exchange-dev \
    libocct-draw-dev \
    libocct-foundation-dev \
    libocct-modeling-algorithms-dev \
    libocct-modeling-data-dev \
    libocct-ocaf-dev \
    libocct-visualization-dev \
    occt-draw \
    python3-pyside2uic \
    git && \
  ln -s libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

RUN add-apt-repository universe

RUN apt-get update && apt-get install -y libvtk7-dev
    
# Clone FreeCAD source
RUN git clone https://github.com/FreeCAD/FreeCAD.git freecad-source

# Create a build directory and compile FreeCAD
RUN mkdir freecad-build && \
    cd freecad-build && \
    cmake ../freecad-source && \
    make -j$(nproc --ignore=2)

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
