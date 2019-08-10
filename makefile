# Run JupyterLab with the Haskell kernel
nb:
	stack exec jupyter -- notebook --port 9999

lab:
	stack exec jupyter -- lab --port 9999

to-notebook: notebook-python-deck.ipynb

%.ipynb : %.md
	/usr/local/bin/pandoc $^ -t ipynb -s -o $(@:.md=.ipynb) 
