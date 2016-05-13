# OBI Modelling Experiment: Panepinto 2002

This repository contains draft modelling of Figure 4AB from:

Panepinto, John C., et al. "Expression of the Aspergillus fumigatus rheb homologue, rhbA, is induced by nitrogen starvation." Fungal Genetics and Biology 36.3 (2002): 207-214. [PubMed:12135576](http://www.ncbi.nlm.nih.gov/pubmed/12135576)

View the results: [Panepinto2002.ttl](Panepinto2002.ttl?raw=true)

The goal was to test the range and detail of terms available in OBI for describing this one example. Keep in mind that OBI can work at many scales: a much smaller and simpler model will be sufficient for many purposes.

The key information is in two files:

- [Panepinto2002.howl](panepinto/Panepinto2002.howl) is a text file describing the relevant parts of the investigation
- [Panepinto2002.xlsx](panepinto/Panepinto2002.xlsx) is a spreadsheet with rows that trace each of the five exposures

These files are written in [HOWL](http://humaneowl.com) format, a new human-readable format for RDF and OWL. The [Makefile](Makefile) contains scripts for converting the files to Turtle format, which can be opened in [Protégé](http://protege.stanford.edu) (see the link above). Several tools required for this conversion, some are still in development, and some are ad hoc scripts, so it might be difficult to run the conversion yourself.

Requirements:

- Unix/Linux/Mac OS X
- GNU Make
- Java
- [xlsx2csv](https://github.com/dilshod/xlsx2csv)
- [ROBOT](https://github.com/ontodev/robot)
- [HOWL](http://humaneowl.com)

