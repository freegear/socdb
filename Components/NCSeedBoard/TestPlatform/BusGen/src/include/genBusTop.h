# ifndef GenBusTop_H
# define GenBusTop_H

#define ADDRDECODER_GEN_START   "//ADDRDECODER_GEN_START\n"
#define STATE_END               "//STATE_END\n"

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

#define STATE12_START   "//STATE12_START\n"
#define STATE13_START   "//STATE13_START\n"
#define STATE14_START   "//STATE15_START\n"
#define STATE15_START   "//STATE16_START\n"
#define STATE16_START   "//STATE17_START\n"
#define STATE17_START   "//STATE18_START\n"
#define STATE18_START   "//STATE19_START\n"

#define INOUT_STATE00_START "//INOUT_STATE00_START\n"
#define INOUT_STATE01_START "//INOUT_STATE01_START\n"
#define INOUT_STATE02_START "//INOUT_STATE02_START\n"
#define INOUT_STATE03_START "//INOUT_STATE03_START\n"
#define INOUT_STATE04_START "//INOUT_STATE04_START\n"
#define INOUT_STATE05_START "//INOUT_STATE05_START\n"
#define INOUT_STATE06_START "//INOUT_STATE06_START\n"
#define INOUT_STATE07_START "//INOUT_STATE07_START\n"
#define INOUT_STATE08_START "//INOUT_STATE08_START\n"
#define INOUT_STATE09_START "//INOUT_STATE09_START\n"
#define INOUT_STATE10_START "//INOUT_STATE10_START\n"
#define INOUT_STATE11_START "//INOUT_STATE11_START\n"
#define INOUT_STATE12_START "//INOUT_STATE12_START\n"
#define INOUT_STATE13_START "//INOUT_STATE13_START\n"
#define INOUT_STATE14_START "//INOUT_STATE14_START\n"

#define MASTER_MODULE_GEN   "//MASTER_MODULE_GEN\n"
#define SLAVE_MODULE_GEN    "//SLAVE_MODULE_GEN\n"

#define STATE_END           "//STATE_END\n"

#define INOUT_END           "//INOUT_END\n"
#define DEF_STATE           "//DEF_STATE\n"

#define MUX_GEN_START       "//MUX_GEN_START\n"
#define ARBITER_GEN_START   "//ARBITER_GEN_START\n"
#define STATE_START         "//STATE_START\n"
#define STATE_END           "//STATE_END\n"
#define SLAVE_MODULE_GEN    "//SLAVE_MODULE_GEN\n"
#define Code_END            "//Code_END\n"

unsigned int genBusTop(char *OutFileName);
unsigned int genTestbench(char *OutFileName);
unsigned int genTestMaster(DefMaster *VAL_MASTER, char *OutFileName);
unsigned int genIntSRAMController(char *OutFileName, DefSlave *VAL_SLAVE);
unsigned int genTOPBlock(char *OutFileName);
unsigned int genTestSSRAM(DefSlave *VAL_SLAVE, char *OutFileName);
#else 

#endif
