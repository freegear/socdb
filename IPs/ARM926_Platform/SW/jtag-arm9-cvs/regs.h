/* status */
#define	ARM_RUNNING	0
#define ARM_HALTED	1
#define ARM_HALTED_WITH_REGS	2
#define ARM_HALTED_WITH_REGS_WRITTEN	3

/* mode */
#define ARM_THUMB	0
#define ARM_32BIT	1

struct regs_struct {
	int status;
	int mode;
	unsigned long r[16];
	unsigned long pc;
};

typedef struct regs_struct regs_type;

extern regs_type arm_regs;

int regs_print(void);
int regs_set(int reg, unsigned long value);
int regs_read(void);
int regs_write(void);
