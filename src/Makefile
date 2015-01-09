PHP := $(wildcard *.php)
HTML := $(patsubst %.php,dist/%.html,$(PHP))

all : dist_directory $(HTML)
	

dist/%.html : %.php
	php $< > $@

dist_directory :
	mkdir -p dist && \
	cp -r media/ dist/

clean :
	rm -rf dist/
