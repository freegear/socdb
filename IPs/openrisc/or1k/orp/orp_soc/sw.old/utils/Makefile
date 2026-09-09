all: dummy

bin2c: bin2c.c
	gcc -O2 -o bin2c bin2c.c

bin2srec: bin2srec.c
	gcc -O2 -o bin2srec bin2srec.c

loader: loader.c
	gcc -O2 -o loader loader.c

bin2flimg: bin2flimg.c
	gcc -O2 -o bin2flimg bin2flimg.c

bin2hex: bin2hex.c
	gcc -O2 -o bin2hex bin2hex.c

dummy: bin2c bin2srec loader bin2flimg bin2hex

clean:
	rm -rf bin2c bin2srec loader bin2flimg bin2hex *~ *.bak
