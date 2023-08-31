# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# app title
ENV TITLE=FreeCAD

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    ocl-icd-libopencl1 \
    flatpak \
    python3-pip \
    python3-git \
    python3-xdg \
    python3-pyside2.qtwebengine \
    python3-pyside2.qtwebenginecore \
    python3-pyside2.qtwebenginewidgets \
    python3-pyside2.qtwebchannel \
    xz-utils && \
  ln -s libOpenCL.so.1 /usr/lib/x86_64-linux-gnu/libOpenCL.so && \
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Create a startup script
RUN echo '#!/bin/bash\n \
if ! flatpak list | grep -q "org.freecadweb.FreeCAD"; then\n \
    flatpak install -y flathub org.freecadweb.FreeCAD\n \
fi\n \
flatpak run org.freecadweb.FreeCAD "$@"' > /usr/local/bin/freecad

# Make the script executable
RUN chmod +x /usr/local/bin/freecad

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
