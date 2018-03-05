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

list:
	bash -c 'for fn in $$(ssh chrisburr.me echo "'"/usr/share/nginx/html/presentations/*/*/"'"); do printf "%-50s | https://chrisburr.me/presentations/%s/%s/\n" $$(basename $$fn) $$(basename $$(dirname $$fn)) $$(basename $$fn); done | sort'
