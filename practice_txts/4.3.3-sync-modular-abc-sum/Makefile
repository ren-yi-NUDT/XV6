
FLAGS = -Wall -pthread
INCLUDES = ./include

all: a.out

clean:
	rm -f a.out *.o *.gch

a.out: main.c sync.c sync.h
	gcc -I $(INCLUDES) $^ $(FLAGS)
