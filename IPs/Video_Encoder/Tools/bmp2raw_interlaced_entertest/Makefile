#
# Makefile for venc
#
CFLAGS = -g 
CC = gcc
LDFLAGS = -lm 

ALL_TOOLS = bmp2c 

all: $(ALL_TOOLS)

Encoder: bmp2c.c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(ALL_TOOLS)
