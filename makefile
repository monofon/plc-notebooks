source := src
notebook := notebook

pandoc := /usr/local/bin/pandoc

md := $(wildcard $(source)/*.md)
ipynb := $(md:$(source)/%.md=$(notebook)/%.ipynb)

debug:
	@echo $(md)
	@echo $(ipynb)

build: $(ipynb) makefile

$(notebook)/%.ipynb : $(source)/%.md
	$(pandoc) $^ --to ipynb-raw_html-raw_tex+raw_attribute --standalone --output $@ 

# Start a local notebook serve that can serve to iframes. It uses the same
# docker image that would be used on mybinder.org.
docker:
	docker run --rm \
		-p 8192:8888 \
		-v $(PWD):/home/jovyan/plc \
		--env JUPYTER_ENABLE_LAB=no \
		--env JUPYTER_TOKEN=plc \
		--name plc \
		crosscompass/ihaskell-notebook:latest
	open -a safari http://localhost:8192?token=plc

# Start a local notebook server that can serve to iframes. It uses the local
# jupyter installation and configuration from ./jupyter.
jupyter: 
	env JUPYTER_CONFIG_DIR=jupyter \
	jupyter notebook --port 8192 \
		--NotebookApp.allow_origin='http://localhost:8888' \
		--NotebookApp.token='plc'
		

safari:
	(sleep 2; open -a safari http://localhost:8192?token=plc)&

run-haskell: safari
	docker run --rm -p 8192:8888 plc-haskell:latest

run-java: safari
	docker run --rm -p 8192:8888 plc-java:latest

.PHONY: build debug safari run-local jupyter
