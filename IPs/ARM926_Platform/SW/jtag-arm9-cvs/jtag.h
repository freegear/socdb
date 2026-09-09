/* include file for jtag functions */

#define JTAG_TMS	0x02
#define JTAG_CLK	0x04
#define JTAG_TDI	0x08
#define JTAG_PWR	0x80

#define JTAG_TDO	0x80	/* remember this signal is inverted */

#define JTAG_IRLENGTH	4

#define JTAG_EXTEST	0x00
#define JTAG_SCAN_N	0x02
#define JTAG_INTEST	0x0C
#define JTAG_IDCODE	0x0E
#define JTAG_BYPASS	0x0F
#define JTAG_CLAMP	0x05
#define JTAG_HIGHZ	0x07
#define JTAG_CLAMPZ	0x09
#define JTAG_SAMPLE	0x03
#define JTAG_RESTART	0x04

extern unsigned long Data[10];

int jtag_ireg(unsigned long *data, unsigned int length);
int jtag_dreg(unsigned long *data, unsigned int length);

int jtag_init(void);
int jtag_reset(int argc, char **argv);
int jtag_idcode(int argc, char **argv);
