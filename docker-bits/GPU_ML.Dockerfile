# Install Tensorflow
RUN conda config --set channel_priority false && \
    conda install --quiet --yes \
      'tensorflow' \
      'keras' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install PyTorch
RUN conda config --set channel_priority false && \
    conda install --quiet --yes \
      'cmake==3.17.0' \
      'cffi==1.14.3' \
      'mkl==2020.2' \
      'mkl-include==2020.2' \
      'pyyaml==5.3.1' \
      'setuptools==49.6.0' \
      'typing==3.7.4.3' \
      'pytorch==1.3.1' \
      'torchvision==0.4.2' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install XGBoost
RUN conda config --set channel_priority false && \
    conda install --quiet --yes \
      'xgboost==1.2.0' \
    && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER
