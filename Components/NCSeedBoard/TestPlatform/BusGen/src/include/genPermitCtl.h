# ifndef GenPermit_H
# define GenPermit_H

#define STATE00_START   "//STATE00_START\n"
#define STATE00_END     "//STATE00_END\n"

#define STATE01_START   "//STATE01_START\n"
#define STATE01_END     "//STATE01_END\n"

#define STATE02_START   "//STATE02_START\n"
#define STATE02_END     "//STATE02_END\n"

#define STATE03_START   "//STATE03_START\n"
#define STATE03_END     "//STATE03_END\n"

#define STATE04_START   "//STATE04_START\n"
#define STATE04_END     "//STATE04_END\n"

#define STATE05_START   "//STATE05_START\n"
#define STATE05_END     "//STATE05_END\n"

#define STATE06_START   "//STATE06_START\n"
#define STATE06_END     "//STATE06_END\n"

#define STATE07_START   "//STATE07_START\n"
#define STATE07_END     "//STATE07_END\n"

#define STATE08_START   "//STATE08_START\n"
#define STATE08_END     "//STATE08_END\n"

#define STATE09_START   "//STATE09_START\n"
#define STATE09_END     "//STATE09_END\n"

#define STATE10_START   "//STATE10_START\n"
#define STATE10_END     "//STATE10_END\n"

#define STATE11_START   "//STATE11_START\n"
#define STATE11_END     "//STATE11_END\n"

#define Code_END        "//Code_END\n"

#define STATE_START     "//STATE_START\n"
#define STATE_END       "//STATE_END\n"

/* 
 * mode = 1 :: Write channel mode
 * mode = 0 :: Read Channel mode
 */

unsigned int genSimPermitCtl(char *OutFileName, 
                             DefMaster *VAL_MASTER, int mode);
unsigned int genAdPermitCtl(char *OutFileName, 
                            DefMaster *VAL_MASTER, int mode);

//unsigned int genSimPermitCtl(DefMain *, DefMaster *, DefSlave *, int mode);
# else
# endif
