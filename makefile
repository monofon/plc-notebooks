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

run-local:
	docker run --rm \
		-p 8888:8888 \
		-v $(PWD):/home/jovyan/plc \
		--env JUPYTER_ENABLE_LAB=yes \
		--env JUPYTER_TOKEN=x \
		--name plc \
		crosscompass/ihaskell-notebook:latest
	open -a safari http://localhost:8888?token=x

.PHONY: build debug