TEMPLATE := $(shell find logos -type d) index.html
ASSETS := $(shell find assets -type d)
SOURCE := markdown.md


help:
	echo "Possible options are:"
	echo "    help"
	echo "    upload"
	echo "    serve"


upload: upload.sh $(SOURCE) $(ASSETS) $(TEMPLATE)
	./upload.sh

serve:
	open http://0.0.0.0:8000/
	python3 -m http.server
