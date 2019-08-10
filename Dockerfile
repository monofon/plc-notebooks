# Dockerfile for mybinder.org
#
# https://github.com/jamesdbrock/learn-you-a-haskell-notebook/blob/master/Dockerfile
#
# Test this Dockerfile:
#
#     docker build -t learn-you-a-haskell .
#     docker run --rm -p 8888:8888 --name learn-you-a-haskell --env JUPYTER_TOKEN=x learn-you-a-haskell:latest
#

FROM crosscompass/ihaskell-notebook:e763dc764d90

USER root

RUN mkdir /home/$NB_USER/plc
COPY ./*.ipynb /home/$NB_USER/plc/
# COPY ./img /home/$NB_USER/plc/img
RUN chown --recursive $NB_UID:users /home/$NB_USER/plc

USER $NB_UID

ENV JUPYTER_ENABLE_LAB=yes