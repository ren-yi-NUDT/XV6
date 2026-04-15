
FLAGS = -Wall -pthread
INCLUDES = /home/os/examples/include

all: a.out

clean:
	rm -f a.out *.o *.gch

a.out: main.c bound-buffer.c bound-buffer.h
	gcc -I $(INCLUDES) $^ $(FLAGS)
