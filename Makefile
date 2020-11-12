# Concatenate files, but add a newline between them.
# https://stackoverflow.com/questions/8183191/concatenating-files-and-insert-new-line-in-between-files
CAT := sed -e '$$s/$$/\n/' -s
SRC := docker-bits
RESOURCES := resources
OUT := output

Tensorflow-CUDA := 11.1
PyTorch-CUDA    := 11.0

.PHONY: clean

clean:
	rm -rf $(OUT)

.output:
	mkdir -p $(OUT)/
	cp -r $(RESOURCES)/* $(OUT)/

all: JupyterLab RStudio VSCode
	@echo "All dockerfiles created."

# Skip GPU & Python
RStudio: .output
	$(CAT) \
		$(SRC)/0_Base.Dockerfile \
		$(SRC)/3_Kubeflow.Dockerfile \
		$(SRC)/4_CLI.Dockerfile \
		$(SRC)/5_DB-Drivers.Dockerfile \
		$(SRC)/7_$(@).Dockerfile \
		$(SRC)/∞_CMD.Dockerfile \
	>   $(OUT)/$@-cpu.Dockerfile
	@echo
	@echo "$(@)-cpu.Dockerfile written."
	@echo
	@echo


# Configure the "Bases"
PyTorch Tensorflow: .output
	# Configure for either PyTorch or Tensorflow
	$(CAT) \
		$(SRC)/0_Base.Dockerfile \
		$(SRC)/1_CUDA-$($(@)-CUDA).Dockerfile \
		$(SRC)/2_$@.Dockerfile \
	> $(OUT)/$@.Dockerfile


JupyterLab VSCode: PyTorch Tensorflow

	for type in $^; do \
		$(CAT) \
			$(OUT)/$${type}.Dockerfile \
			$(SRC)/3_Kubeflow.Dockerfile \
			$(SRC)/4_CLI.Dockerfile \
			$(SRC)/5_DB-Drivers.Dockerfile \
			$(SRC)/6_Julia.Dockerfile \
			$(SRC)/7_$(@).Dockerfile \
			$(SRC)/∞_CMD.Dockerfile \
		>   $(OUT)/$@-$${type}.Dockerfile; \
	done


	# # Configure the cpu v.s. gpu bases
	# $(CAT) $(SRC)/0_Base.Dockerfile \
	# | tee $(OUT)/$@-cpu.Dockerfile $(OUT)/$@-gpu.Dockerfile > /dev/null

	# # GPU only
	# $(CAT) $(SRC)/GPU_Cuda.Dockerfile >> $(OUT)/$@-gpu.Dockerfile
	# $(CAT) $(SRC)/GPU_ML.Dockerfile   >> $(OUT)/$@-gpu.Dockerfile


	# 	$(SRC)/1_Kubeflow.Dockerfile \
	# 	$(SRC)/2_CLI.Dockerfile \
	# 	$(SRC)/3_DB-Drivers.Dockerfile \


	# # Everything here is shared
	# $(CAT) \
	# 	$(SRC)/1_Kubeflow.Dockerfile \
	# 	$(SRC)/2_CLI.Dockerfile \
	# 	$(SRC)/3_DB-Drivers.Dockerfile \
	# 	$(SRC)/4_$(@).Dockerfile \
	# 	$(SRC)/∞_CMD.Dockerfile \
	# | tee -a $(OUT)/$@-cpu.Dockerfile >> $(OUT)/$@-gpu.Dockerfile
	# @echo
	# @echo "$(@)-cpu.Dockerfile written."
	# @echo "$(@)-gpu.Dockerfile written."
	# @echo
	# @echo
