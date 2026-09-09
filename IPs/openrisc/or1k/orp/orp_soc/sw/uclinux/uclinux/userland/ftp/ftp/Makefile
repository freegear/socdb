CC = or32-uclibc-gcc
LD = or32-uclibc-gcc
STRIP = or32-uclibc-strip


EXEC = ftp
OBJS = cmds.o cmdtab.o domacro.o ftp.o glob.o main.o ruserpass.o

CFLAGS := $(CFLAGS) -Wall -Werror-implicit-function-declaration -DEMBED
LDFLAGS := -r -d

all: $(EXEC)

$(EXEC): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)
	$(STRIP) -g $@

clean:
	-rm -f $(EXEC) *.gdb *.elf *.o

