


CC = gcc
CFLAGS = -g
#LDFLAGS = 

BUILD = gaswmodel
BUILD_DIR = build

SRC_C = axi_if.c \
	cmd_buff.c \
	cmd_queue.c \
	fromto32bpp.c \
	ga.c \
	gaswmodel.c \
	gbus.c \
	ld_file.c \
	wr_file.c \
	pcache.c 


OBJECTS = $(SRC_C:.c=.o)

.SUFFIXES: .o .c

all : $(BUILD)

$(BUILD) : $(BUILD_DIR) $(OBJECTS)
	@echo "  L: $(@F)"
	@cd $(BUILD_DIR) && \
		$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

.c.o:
	@echo "  C: $(@D)/$(<F)"
	@mkdir -p $(BUILD_DIR)/$(@D)
	@$(CC) $(CFLAGS) -c -o $(BUILD_DIR)/$@ $<

$(BUILD_DIR):
	@echo "  D: $(BUILD_DIR)"
	@mkdir -p $(BUILD_DIR)
