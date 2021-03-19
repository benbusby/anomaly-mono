CC=gcc
DEPS=anomaly_mono_regular.h
OBJ=anomaly_mono_regular.o draw_text.o
OUT=draw_text

%.o: %.c
	$(CC) $< -c -o $@

draw_text: $(OBJ)
	$(CC) $^ -o $(OUT)

clean:
	rm -f *.o
