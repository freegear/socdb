all : mm

mm : main.o
	gcc -W -Wall -g -o scaler.exe main.o

main.o : main.c
	gcc -W -Wall -c -o main.o main.c

clean : 
	rm -fr *.o
	rm -fr scaler.exe
