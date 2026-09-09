


CC = gcc
CFLAGS = -g
#LDFLAGS = 

BUILD = gaswmodel
BUILD_DIR = build

SRC_C = axi_if.c \
	   	brush_buff.c \
		gbus.c \
	    ld_file.c \
        wr_file.c \
		pcache.c \
		line.c \
		line_param.c \
		gpu.c \
	    cmd_buff.c \
		cmd_queue.c \
		hrange.c \
		gradient_color.c \
		dst_pat_buff.c \
		dst_pic.c \
		src_pic.c \
		dst_rd_buff.c \
		dst_wr_buff.c \
		src_pal_buff.c \
		src_pat_buff.c \
		src_rd_buff.c \
		overlay.c \
		drawing.c \
		ga.c \
		gaswmodel.c

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
