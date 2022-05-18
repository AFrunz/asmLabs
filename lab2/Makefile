CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

AS_FLAGS = -g
LD_FLAGS = -g -static


SRCS = lab3.s
OBJS = $(SRCS:.s=.o)

EXE = lab3



all: $(SRCS) $(EXE)


clean:
	rm -rf $(OBJS)


$(EXE): $(OBJS)
	$(LD) $(LD_FLAGS) $(OBJS) -o $@



.s.o:
	$(AS) $(AS_FLAGS) $< -o $@

