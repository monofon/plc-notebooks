source := src
notebook := plc/notebook

pandoc := /usr/local/bin/pandoc

md := $(wildcard $(source)/*.md)
ipynb := $(md:$(source)/%.md=$(notebook)/%.ipynb)

default: run-docker

build: $(ipynb) makefile

$(notebook)/%.ipynb : $(source)/%.md
	$(pandoc) $^ --to ipynb-raw_html-raw_tex+raw_attribute --standalone --output $@ 

# Start the local Jupyter server directly from the local file system. No docker
# is required, but a local Jupyter installation with all the kernels is. NOT
# RECOMENDED. Local installation might not be in sync with the docker images.
run-local: browser
	jupyter notebook --port 8192

# Start a local notebook server that can serve to iframes. It uses the same
# docker image that would be used on mybinder.org. This allows saving the
# notebooks into the local repository.
run-docker: browser
	docker run --rm \
		-p 8192:8888 \
		-v $(PWD)/plc:/home/jovyan/plc \
		--name plc \
		monofon/plc:latest

# Start a local notebook server that can serve to iframes. It uses the same
# docker image that would be used on mybinder.org. This does NOT allow to save
# notebooks into the local repository.
run-docker-read-only: browser
	docker run --rm \
		-p 8192:8888 \
		--name plc-notebook \
		monofon/plc-notebook:latest

build-docker:
	(cd docker; make)

# Build the plc-notebook for local read-only use during lectures
plc-notebook: build-docker
	docker build --tag=plc-notebook .
	docker tag plc-notebook monofon/plc-notebook
	docker push monofon/plc-notebook

browser:
	(sleep 2; open http://localhost:8192?token=plc)&

.PHONY: build debug browser run-docker build-docker plc-notebook
