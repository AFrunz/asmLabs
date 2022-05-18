CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /opt/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu/

REFIX = /usr/local/arm64



CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld



AS_FLAGS =
LD_FLAGS =  -static
CC_FLAGS =  -c


LIBPATH = -L $(PREFIX)/lib/gcc/aarch64-linux-gnu/7.5.0 -L $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
OBJPATH = $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
LIBS = -lgcc -lgcc_eh -lc -lm
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

SRCS = main.c prog5.s
HEAD = stb_image.h stb_image_write.h
OBJS = main.o prog5.o

EXE = prog5



all: $(SRCS) $(EXE)


clean:
	rm -rf $(OBJS)


$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LD_FLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@


.c.o:
	$(CC) $(CC_FLAGS) $< -o $@

.s.o:
	$(AS) $(AS_FLAGS) $< -o $@

