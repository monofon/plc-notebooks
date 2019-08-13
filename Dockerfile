# Dockerfile for mybinder.org
#
# From:
# - https://github.com/jamesdbrock/learn-you-a-haskell-notebook/blob/master/Dockerfile
#
# Test this Dockerfile:
#
#     docker build -t plc .
#     docker run --rm -p 8888:8888 --name plc --env JUPYTER_TOKEN=x plc:latest
#

FROM crosscompass/ihaskell-notebook:e763dc764d90

USER root

RUN mkdir -p /home/$NB_USER/plc/notebook
RUN mkdir -p /home/$NB_USER/plc/img

COPY notebook /home/$NB_USER/plc/notebook
COPY img /home/$NB_USER/plc/img

RUN chown --recursive $NB_UID:users /home/$NB_USER/plc

USER $NB_UID

ENV JUPYTER_ENABLE_LAB=yes