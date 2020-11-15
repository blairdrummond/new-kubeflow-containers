FROM jupyter/datascience-notebook:42f4c82a07ff
# FROM jupyter/minimal-notebook:42f4c82a07ff
USER root
ENV PATH="/home/jovyan/.local/bin/:${PATH}"

RUN apt-get update --yes \
    && apt-get install --yes language-pack-fr \
    && rm -rf /var/lib/apt/lists/*
