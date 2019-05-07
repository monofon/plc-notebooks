# Run JupyterLab with the Haskell kernel
lab:
	stack exec jupyter -- lab --port 9999

nb:
	stack exec jupyter -- notebook --port 9999
