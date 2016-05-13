# OBI-HOWL Makefile
# James A. Overton <james@overton.ca>
# 2016-05-05
#
# This file defines tasks for converting OBI from OWL format to HOWL format,
# then converting the HOWL back to OWL.


### Configuration
#
# These are standard options to make Make sane:
# <http://clarkgrubb.com/makefile-style-guide#toc2>

MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
#.DELETE_ON_ERROR:
.SUFFIXES:
.SECONDARY:

XLSX := xlsx2csv --delimiter tab --escape


### Convert OWL to HOWL

build:
	mkdir -p $@

build/%.nt: lib/howl.jar build/%.howl | build
	java -jar $^ --output ntriples > $@

build/%.ttl: build/%.nt
	rapper --input ntriples \
	--output turtle \
	-f 'xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"' \
	-f 'xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"' \
	-f 'xmlns:xsd="http://www.w4.org/2001/XMLSchema#"' \
	-f 'xmlns:owl="http://www.w3.org/2002/07/owl#"' \
	$< > $@

build/%.owl: build/%.ttl
	robot convert --input $< --output $@


### Paneptino 2002

build/Panepinto2002-specimen-collection.tsv: panepinto/Panepinto2002.xlsx | build
	$(XLSX) --sheet 1 $< > $@

build/Panepinto2002-assays.tsv: panepinto/Panepinto2002.xlsx | build
	$(XLSX) --sheet 2 $< > $@

build/Panepinto2002-data-transformation.tsv: panepinto/Panepinto2002.xlsx | build
	$(XLSX) --sheet 3 $< > $@

build/Panepinto2002-specimen-collection.howl: panepinto/template.py build/Panepinto2002-specimen-collection.tsv
	$^ > $@

build/Panepinto2002-assays.howl: panepinto/template.py build/Panepinto2002-assays.tsv
	$^ > $@

build/Panepinto2002-data-transformation.howl: panepinto/template.py build/Panepinto2002-data-transformation.tsv
	$^ > $@

build/Panepinto2002-partial.howl: panepinto/Panepinto2002.howl build/Panepinto2002-specimen-collection.howl build/Panepinto2002-assays.howl build/Panepinto2002-data-transformation.howl
	cat $^ > $@

build/Panepinto2002-terms.howl: panepinto/collect.py build/Panepinto2002-partial.howl panepinto/terms.tsv | build
	$^ > $@

build/Panepinto2002.howl: panepinto/prefixes.howl panepinto/labels.howl panepinto/context.howl build/Panepinto2002-terms.howl build/Panepinto2002-partial.howl
	cat $^ > $@

Panepinto2002.ttl: build/Panepinto2002.ttl
	cp $< $@

### Common Tasks

.PHONY: all
all: Panepinto2002.ttl

.PHONY: clean
clean:
	rm -rf build Panepinto2002.ttl


