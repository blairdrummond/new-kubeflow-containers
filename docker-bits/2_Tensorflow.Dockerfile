# Install Tensorflow
RUN conda config --set channel_priority false && \
    conda install --quiet --yes \
      'tensorflow' \
      'keras' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
