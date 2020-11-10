# Default environment
RUN pip install --quiet \
      'jupyter-lsp==0.9.2' \
      'jupyter-server-proxy==1.5.0' \
    && \
    conda install --quiet --yes \
    -c conda-forge \
      'ipympl==0.5.8' \
      'jupyter_contrib_nbextensions==0.5.1' \
      'jupyterlab-git==0.20.0' \
      'xeus-python==0.8.4' \
      'nodejs==13.13.0' \
      'python-language-server==0.31.10' \
    && \
    conda install --quiet --yes \
      'pyarrow==0.17.1' \
      'r-tidyr==1.1.2' \
      'r-jsonlite==1.7.1' \
      'r-rstan==2.21.2' \
    && \
    conda install --quiet --yes \
      -c plotly \
      'jupyter-dash==0.3.0' \
    && \
    conda clean --all -f -y && \
    jupyter nbextension enable codefolding/main --sys-prefix && \
    jupyter labextension install --no-build \
      '@ijmbarr/jupyterlab_spellchecker@0.1.6' \
      '@hadim/jupyter-archive@0.7.0' \
      '@krassowski/jupyterlab-lsp@2.0.7' \
      '@lckr/jupyterlab_variableinspector@0.5.1' \
      '@jupyterlab/debugger@0.3.2' \
      '@jupyterlab/github@2.0.0' \
      '@jupyterlab/git@0.20.0' \
      '@jupyterlab/toc@4.0.0' \
      'jupyterlab-execute-time@1.0.0' \
      'jupyterlab-plotly@4.10.0' \
      'jupyterlab-theme-solarized-dark@1.0.2' \
      'jupyterlab-spreadsheet@0.3.2' \
      'nbdime-jupyterlab@2.0.0' \
    && \
    jupyter lab build && \
    jupyter lab clean && \
  npm cache clean --force && \
  rm -rf /home/$NB_USER/.cache/yarn && \
  rm -rf /home/$NB_USER/.node-gyp && \
  fix-permissions $CONDA_DIR && \
  fix-permissions /home/$NB_USER

# Solarized Theme and Cell Execution Time
RUN echo '{ "@jupyterlab/apputils-extension:themes": {"theme": "JupyterLab Dark"}, "@jupyterlab/notebook-extension:tracker": {"recordTiming": true}}' > /opt/conda/share/jupyter/lab/settings/overrides.json && \
    fix-permissions /home/$NB_USER

ENV DEFAULT_JUPYTER_URL=/lab
ENV GIT_EXAMPLE_NOTEBOOKS=https://github.com/statcan/jupyter-notebooks
