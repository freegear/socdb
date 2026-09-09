#
# Makefile for venc
#
CFLAGS = -g -o2
CC = gcc
LDFLAGS = -lm 

ALL_TOOLS = Encoder 

all: $(ALL_TOOLS)

Encoder: Encoder.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(ALL_TOOLS)
