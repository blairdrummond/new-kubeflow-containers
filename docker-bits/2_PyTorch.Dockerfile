# Install PyTorch
RUN conda config --set channel_priority false && \
    conda create -n torch python=3.9 && \
    conda install -n torch --quiet --yes \
      'cmake' \
      'cffi' \
      'mkl' \
      'mkl-include' \
      'pyyaml' \
      'setuptools' \
      'typing' \
      'pytorch' \
      'torchvision' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
