# Makefile for Linux

SHELL = /bin/sh

# System-specific settings

CC =		gcc
CCFLAGS =	-O -g -I/usr/local/include -DCHECK64 
LINK =		gcc
LINKFLAGS =	-O -g -L/usr/local/lib/
#LIB =		-lmpi

# Link target

gups:	gups.o
	$(LINK) $(LINKFLAGS) gups.o  -o ./bin/gups

hex2bin: hex2bin.o 
	$(LINK) $(LINKFLAGS) hex2bin.o  -o ./bin/hex2bin

# Compilation rules

%.o:%.c
	$(CC) $(CCFLAGS) -c $<
