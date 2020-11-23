# Kubeflow Containers

```
.
├── Makefile                    # Cats the docker-bits together
│
├── docker-bits                 # The docker snippets. Numbering indicates the DAG.
│   ├── 0_Base.Dockerfile
│   ├── 1_CUDA-11.0.Dockerfile
│   ├── 1_CUDA-11.1.Dockerfile
│   ├── 2_PyTorch.Dockerfile
│   ├── 2_Tensorflow.Dockerfile
│   ├── 3_Kubeflow.Dockerfile
│   ├── 4_CLI.Dockerfile
│   ├── 5_DB-Drivers.Dockerfile
│   ├── 6_JupyterLab.Dockerfile
│   ├── 6_RStudio.Dockerfile
│   ├── 6_VSCode.Dockerfile
│   └── ∞_CMD.Dockerfile
│
├── resources                   # the Docker context (files for COPY)
│   ├── clean-layer.sh
│   ├── helpers.zsh
│   ├── jupyterlab-overrides.json
│   ├── landing_page
│   ├── nginx
│   ├── README.md
│   └── start-custom.sh
│
├── scripts                     # Helper Scripts
│   ├── CHECKSUMS
│   ├── checksums.sh
│   ├── get-nvidia-stuff.sh
│   └── README.md
│
└── output                       # Staging area for a `docker build .`
    ├── JupyterLab-CPU/
    ├── JupyterLab-PyTorch/
    ├── JupyterLab-Tensorflow/
    ├── RStudio/
    ├── VSCode-CPU/
    ├── VSCode-PyTorch/
    └── VSCode-Tensorflow/
```
