USER ${NB_USER}

#RUN npm install -g --production code-server && \
#    npm cache clean --force && \
#    rm -rf $HOME/.npm/* $HOME/.node-gyp/* && \
#    pip install --quiet \
#      'jupyter-vscode-proxy==0.1' \
#      'jupyter-server-proxy==1.5.0'

ARG CODESERVER_URL="https://github.com/cdr/code-server/releases/download/1.1119-vsc1.33.1/code-server1.1119-vsc1.33.1-linux-x64.tar.gz"
ARG CODESERVER="code-server1.1119-vsc1.33.1-linux-x64"
ARG CODESERVER_SHA=dcd024301226eb493db2d06454b5d57a3499fbbc17fd816a68a2333ee3482685


ARG VSCODE_VERSION=3.6.2
ARG VSCODE_SHA=71edb5776a7f965bf720c9814ab2e762fbaa0ddad4d9f4f85848c3912df1b67c
ARG VSCODE_URL=https://github.com/cdr/code-server/releases/download/v${VSCODE_VERSION}/code-server_${VSCODE_VERSION}_amd64.deb

USER root
RUN wget -q "${VSCODE_URL}" -O ./vscode.deb \
    && echo "${VSCODE_SHA}  ./vscode.deb" | sha256sum -c - \
    && apt-get update \
    && apt-get install -y nginx \
    && apt-get install -y ./vscode.deb \
    && rm ./vscode.deb \
    && rm -f /etc/apt/sources.list.d/vscode.list \
    && echo "Install codeserver" \
    && wget -q ${CODESERVER_URL} \
    && echo "${CODESERVER_SHA}  ${CODESERVER}.tar.gz" | sha256sum -c - \
    && tar xvf ${CODESERVER}.tar.gz \
    && mv ${CODESERVER}/code-server /usr/local/bin/ \
    && rm -rf code-server*
    #&& pip install jupyter-vscode-proxy jupyter-server-proxy \
    #&& jupyter serverextension enable --py jupyter_server_proxy \
    #&& jupyter labextension install @jupyterlab/server-proxy \
    #&& jupyter lab build \
    #&& rm -rf /home/$NB_USER/.cache/yarn \
    #&& rm -rf /home/$NB_USER/.node-gyp \
    #&& fix-permissions /home/$NB_USER

COPY landing_page/* /usr/share/nginx/html/
COPY nginx/*        /etc/nginx/

ENV DEFAULT_JUPYTER_URL=/lab
ENV GIT_EXAMPLE_NOTEBOOKS=https://github.com/statcan/jupyter-notebooks
