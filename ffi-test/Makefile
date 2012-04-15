CC   = gcc

default: all

clib.o: clib.c
	$(CC) -fPIC -c $<

libclib.so: clib.o
	$(CC) -shared -Wl,-soname,libclib.so -Wall -o libclib.so $<

enum.o: enum.c
	$(CC) -c -Wall -I. $<

callback.o: callback.c
	$(CC) -c -Wall -I. $<

enum: enum.o libclib.so
	$(CC) enum.o -L. -lclib -lcrypto -o enum

callback: callback.o libclib.so
	$(CC) callback.o -L. -lclib -lcrypto -o callback

all: enum callback

clean:
	rm -f enum callback *.o *.so *~

