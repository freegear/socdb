all: support.o reset-nocache.o reset-ic.o reset-dc.o reset-icdc.o except.o

support.o: support.c
	or32-rtems-gcc -O2 -c -o $@ $?

reset-nocache.o: reset-nocache.S
	or32-rtems-gcc -O2 -c -o $@ $?

reset-ic.o: reset-ic.S
	or32-rtems-gcc -O2 -c -o $@ $?

reset-dc.o: reset-dc.S
	or32-rtems-gcc -O2 -c -o $@ $?

reset-icdc.o: reset-icdc.S
	or32-rtems-gcc -O2 -c -o $@ $?

except.o: except.S
	or32-rtems-gcc -O2 -c -o $@ $?

clean:
	rm -rf *.o
