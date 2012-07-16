THEME=Iago
COLORTHEME=dolphin

all:
	pandoc --listings intro_r.md -t beamer -V theme:${THEME} -V colortheme:${COLORTHEME} -o intro_r.pdf

html:
	pandoc -s -S -i -t dzslides --mathjax intro_r.md -o intro_r.html
clean:
	rm intro_r.pdf
