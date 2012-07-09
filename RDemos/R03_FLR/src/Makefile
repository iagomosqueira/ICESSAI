THEME=Iago
COLORTHEME=dolphin
FILE=03_Intro_FLR

all:
	pandoc --listings ${FILE}.md -t beamer -V theme:${THEME} -V colortheme:${COLORTHEME} -o ${FILE}.pdf

html:
	pandoc -s -S -i -t dzslides --mathjax ${FILE}.md -o ${FILE}.html
clean:
	rm ${FILE}.pdf
