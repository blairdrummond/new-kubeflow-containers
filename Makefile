# Concatenate files, but add a newline between them.
# https://stackoverflow.com/questions/8183191/concatenating-files-and-insert-new-line-in-between-files
CAT := sed -e '$$s/$$/\n/' -s
SRC := docker-bits
OUT := output

.PHONY: clean

clean:
	rm -rf $(OUT)

.output:
	mkdir -p $(OUT)
	cp -r context/* $(OUT)/

all: JupyterLab RStudio VSCode
	@echo "All dockerfiles created."


JupyterLab RStudio VSCode: .output
	# Configure the cpu v.s. gpu bases
	$(CAT) $(SRC)/0_Base.Dockerfile \
	| tee $(OUT)/$@-cpu.Dockerfile > $(OUT)/$@-gpu.Dockerfile

	# GPU only
	$(CAT) $(SRC)/GPU_Cuda.Dockerfile >> $(OUT)/$@-gpu.Dockerfile
	$(CAT) $(SRC)/GPU_ML.Dockerfile   >> $(OUT)/$@-gpu.Dockerfile

	# Everything here is shared
	$(CAT) \
		$(SRC)/1_Kubeflow.Dockerfile \
		$(SRC)/2_CLI.Dockerfile \
		$(SRC)/3_DB-Drivers.Dockerfile \
		$(SRC)/4_$(@).Dockerfile \
		$(SRC)/∞_CMD.Dockerfile \
	| tee -a $(OUT)/$@-cpu.Dockerfile >> $(OUT)/$@-gpu.Dockerfile
	@echo
	@echo "$@.Dockerfile written."
	@echo
	@echo
