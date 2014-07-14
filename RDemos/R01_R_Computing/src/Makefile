#
ROOT:=`git rev-parse --show-toplevel`/Templates/tex
DOC=INTRO_R
OUT=../R01_Intro_to_R

all: $(OUT).pdf

$(OUT).pdf: $(DOC).md
	pandoc -t beamer -S $(DOC).md -o $(OUT).pdf -V theme=default -V colortheme=default  -V logodir=$(ROOT) -H $(ROOT)/header.tex

clean:
	rm -f $(DOC).pdf
