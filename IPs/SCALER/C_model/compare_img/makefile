all : mm

mm : compare_img.o
	gcc -W -Wall -g -o run.exe compare_img.o

compare_img.o : compare_img.c
	gcc -W -Wall -c -o compare_img.o compare_img.c

clean : 
	rm -fr *.o
	rm -fr scaler.exe
