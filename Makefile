# Dockerfile Builder
# ==================
#
# All the content is in `docker-bits`; this Makefile
# just builds target dockerfiles by combining the dockerbits.

Tensorflow-CUDA := 11.1
PyTorch-CUDA    := 11.0

# Concatenate files, but add a newline between them.
# https://stackoverflow.com/questions/8183191/concatenating-files-and-insert-new-line-in-between-files
CAT := sed -e '$$s/$$/\n/' -s
SRC := docker-bits
RESOURCES := resources
OUT := output
TMP := .tmp

.PHONY: clean .output all

clean:
	rm -rf $(OUT) $(TMP)

.output:
	mkdir -p $(OUT)/ $(TMP)/

all: JupyterLab RStudio VSCode
	@echo "All dockerfiles created."

build:
	for d in output/*; do \
		tag=$$(basename $$d | tr '[:upper:]' '[:lower:]'); \
		echo $$tag; \
		cd $$d; \
		docker build . -t kubeflow-$$tag; \
		cd ../../; \
	done;

######################
###    R-Studio	   ###
######################

# Only one output version
RStudio: .output
	mkdir -p $(OUT)/$@
	cp -r resources/* $(OUT)/$@

	$(CAT) \
		$(SRC)/0_Base.Dockerfile \
		$(SRC)/2_Spark.Dockerfile \
		$(SRC)/3_Kubeflow.Dockerfile \
		$(SRC)/4_CLI.Dockerfile \
		$(SRC)/5_DB-Drivers.Dockerfile \
		$(SRC)/6_$(@).Dockerfile \
		$(SRC)/∞_CMD.Dockerfile \
	>   $(OUT)/$@/Dockerfile

##############################
###    Python & Jupyter    ###
##############################

# Configure the "Bases".
#
# NOTE: At the time of writing, CPU is an alias for Spark.
PyTorch Tensorflow CPU: .output
	# Configure for either PyTorch or Tensorflow
	cp $(SRC)/0_Base.Dockerfile $(TMP)/$@.Dockerfile

	# Handle the GPU/CUDA business.
	if [ "$@" = PyTorch ] || [ "$@" = Tensorflow ]; then \
		$(CAT) \
			$(SRC)/1_CUDA-$($(@)-CUDA).Dockerfile \
		>> $(TMP)/$@.Dockerfile; \
	fi

	$(CAT) \
		$(SRC)/2_$@.Dockerfile \
	>> $(TMP)/$@.Dockerfile


JupyterLab VSCode: PyTorch Tensorflow CPU

	for type in $^; do \
		mkdir -p $(OUT)/$@-$${type}; \
		cp -r resources/* $(OUT)/$@-$${type}/; \
		$(CAT) \
			$(TMP)/$${type}.Dockerfile \
			$(SRC)/3_Kubeflow.Dockerfile \
			$(SRC)/4_CLI.Dockerfile \
			$(SRC)/5_DB-Drivers.Dockerfile \
			$(SRC)/6_$(@).Dockerfile \
			$(SRC)/∞_CMD.Dockerfile \
		>   $(OUT)/$@-$${type}/Dockerfile; \
	done
