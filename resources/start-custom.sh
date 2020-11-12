#!/bin/bash

if [ -d /var/run/secrets/kubernetes.io/serviceaccount ]; then
  while ! curl -s -f http://127.0.0.1:15020/healthz/ready; do sleep 1; done
fi

test -z "$GIT_EXAMPLE_NOTEBOOKS" || git clone "$GIT_EXAMPLE_NOTEBOOKS"

if [ -f /tmp/oh-my-zsh-install.sh ]; then
  sh /tmp/oh-my-zsh-install.sh --unattended --skip-chsh
  echo >> /home/${NB_USER}/.bashrc
  echo '[ -z "$PS1" ] && zsh' >> /home/${NB_USER}/.bashrc
fi

if conda --help > /dev/null 2>&1; then
  conda init bash
  conda init zsh
fi

jupyter notebook --notebook-dir=/home/${NB_USER} \
                 --ip=0.0.0.0 \
                 --no-browser \
                 --port=8888 \
                 --NotebookApp.token='' \
                 --NotebookApp.password='' \
                 --NotebookApp.allow_origin='*' \
                 --NotebookApp.base_url=${NB_PREFIX} \
                 --NotebookApp.default_url=${DEFAULT_JUPYTER_URL:-/tree}
