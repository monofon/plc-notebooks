source := src
notebook := plc/notebook

pandoc := /usr/local/bin/pandoc

md := $(wildcard $(source)/*.md)
ipynb := $(md:$(source)/%.md=$(notebook)/%.ipynb)

build: $(ipynb) makefile

$(notebook)/%.ipynb : $(source)/%.md
	$(pandoc) $^ --to ipynb-raw_html-raw_tex+raw_attribute --standalone --output $@ 

# Start the local Jupyter server directly from the local file system.
run-local: browser
	jupyter notebook --port 8192

# Start a local notebook serve that can serve to iframes. It uses the same
# docker image that would be used on mybinder.org. This allows saving the
# notebooks into the local repository.
run-docker: browser
	docker run --rm \
		-p 8192:8888 \
		-v $(PWD)/plc:/home/jovyan/plc \
		--name plc \
		monofon/plc:latest

build-docker:
	(cd docker; make)

browser:
	(sleep 2; open http://localhost:8192?token=plc)&

.PHONY: build debug browser run-docker build-docker
