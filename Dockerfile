# Dockerfile for mybinder.org
#
# From:
# - https://github.com/jamesdbrock/learn-you-a-haskell-notebook/blob/master/Dockerfile
#
# Test this Dockerfile:
#
#     docker build -t plc-notebook .
#     docker run --rm -p 8888:8888 --name plc-notebook plc:latest
#

FROM monofon/plc:latest

USER $NB_USER

RUN mkdir -p /home/$NB_USER/plc
COPY plc /home/$NB_USER/plc
