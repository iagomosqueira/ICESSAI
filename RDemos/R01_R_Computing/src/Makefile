THEME=Iago
COLORTHEME=dolphin

all:
	pandoc --listings intro_r.md -t beamer -V theme:${THEME} -V colortheme:${COLORTHEME} -o ../R01_Intro_to_R.pdf

clean:
	rm ../R01_Intro_to_R.pdf
