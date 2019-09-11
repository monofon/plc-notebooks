# The base image for the PLC course. It contains:
#
# - a basic Jupyter server
# - IHaskell
# - IJava
#
# More languages will probably be added.
#
# It is meant to be used as the base image for mybinder.org deployments
# of exercise note books and as the Jupyter server for ThebeLab in
# decker slide sets. Can also very well be used locally.
#
FROM crosscompass/ihaskell-notebook:latest

MAINTAINER Henrik Tramberend <henrik.tramberend@beuth-hochschule.de>

# Java 11 (Inspired by the official OpenJDK Dockerfile)
USER root

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
        unzip \
		wget \
	; \
	rm -rf /var/lib/apt/lists/*

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8

ENV JAVA_HOME /usr/local/openjdk-11
ENV PATH $JAVA_HOME/bin:$PATH

# backwards compatibility shim
RUN { echo '#/bin/sh'; echo 'echo "$JAVA_HOME"'; } > /usr/local/bin/docker-java-home && chmod +x /usr/local/bin/docker-java-home && [ "$JAVA_HOME" = "$(docker-java-home)" ]

# https://adoptopenjdk.net/upstream.html
ENV JAVA_VERSION 11.0.3
ENV JAVA_BASE_URL https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.3%2B7/OpenJDK11U-
ENV JAVA_URL_VERSION 11.0.3_7
# https://github.com/docker-library/openjdk/issues/320#issuecomment-494050246

RUN set -eux; \
	\
	dpkgArch="$(dpkg --print-architecture)"; \
	case "$dpkgArch" in \
		amd64) upstreamArch='x64' ;; \
		arm64) upstreamArch='aarch64' ;; \
		*) echo >&2 "error: unsupported architecture: $dpkgArch" ;; \
	esac; \
	\
	wget -O openjdk.tgz.asc "${JAVA_BASE_URL}${upstreamArch}_linux_${JAVA_URL_VERSION}.tar.gz.sign"; \
	wget -O openjdk.tgz "${JAVA_BASE_URL}${upstreamArch}_linux_${JAVA_URL_VERSION}.tar.gz" --progress=dot:giga; \
	\
	mkdir -p "$JAVA_HOME"; \
	tar --extract \
		--file openjdk.tgz \
		--directory "$JAVA_HOME" \
		--strip-components 1 \
		--no-same-owner \
	; \
	rm openjdk.tgz*; \
# https://github.com/docker-library/openjdk/issues/331#issuecomment-498834472
	find "$JAVA_HOME/lib" -name '*.so' -exec dirname '{}' ';' | sort -u > /etc/ld.so.conf.d/docker-openjdk.conf; \
	ldconfig; \
	\
# basic smoke test
	javac --version; \
	java --version

# IJava from paulbuis/jupyter-many

# iJava comes from https://github.com/SpencerPark/IJava
USER root
ENV IJAVA_HOME /usr/local/ijava

RUN mkdir "$IJAVA_HOME" && chown $NB_UID:$NB_GID "$IJAVA_HOME"

USER $NB_USER
RUN cd "$IJAVA_HOME" && \
    wget -q https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.py --user && \
    jupyter kernelspec list && \
    jupyter nbextension list

ENV JDK_JAVA_OPTIONS -Xcomp -Xms2g -Xmx2g -XX:-PreserveFramePointer
USER $NB_USER