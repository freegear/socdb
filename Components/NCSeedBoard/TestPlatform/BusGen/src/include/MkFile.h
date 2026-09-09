#ifndef _MKFILE_H_
#define _MKFILE_H_
#endif

#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>


#include "Bus.h"

#define ChangeChar "??"

struct codeLine{
    char *code;
    struct codeLine *next_ptr;
};

/* line dump wirte */
unsigned int fileDumpLine(char *, char *);
/* intitial make directory */
unsigned int initDir(void); 
/* link list print to screen */
void printLink(struct codeLine *);
/* link list print to file */
unsigned int fprintLink(struct codeLine *, char *, char *);
/* link list add */
unsigned int inDataLink(struct codeLine *, char *);
/* change string */
unsigned int changeStr(char *, char *, char *, char *);
unsigned int changeDelStr(char *chString, 
                char *outString, char *eqString, char *afterString);

/* make simple input output port */
unsigned int mkSimpleInOutPort(char *fileName, 
               struct codeLine *start_ptr, char *Name);
/* Before *In, making string */
unsigned int mkBeforeStr(FILE *Fp, 
                struct codeLine *start_ptr, char *In);
/* Buffer changing */
unsigned int mkBuffChange(FILE *Fp, 
                          struct codeLine *head_ptr, 
                          int endi, char *FINDSTR,
                          int *Connect
                          );

unsigned int mkBuffChangeSt2St(FILE *Fp, 
                               struct codeLine *head_ptr, 
                               int endi, char *FINDSTR,
                               char *st1, char *st2,
                               int *Connect);

unsigned int mkSlaveChange(FILE *Fp, DefMaster *VAL_MASTER,
                              struct codeLine *head_ptr);

/* remove new line '\n' */
void rmNewLine(char *SEL);

/* Make MuX type0~2 */
unsigned int mkMUX(FILE *InFp, struct codeLine *head_ptr, 
                   int endi, char *widTh,
                   int * Connect);

/* Make Arbiter */
unsigned int mkArbiter(FILE *InFp, 
                       struct codeLine *head_ptr, 
                       int endi,
                       DefMaster *VAL_MASTER,
                       char *slaveWid,
                       int *Connect,
                       int masterPriority[MAXMASTER]);

unsigned int mkChannelLink(FILE *Fp,
                           struct codeLine *head_ptr,
                           int ReadWrite );

unsigned int mkChannelLinkSi2Mi(FILE *Fp,
                        struct codeLine *head_ptr, int ReadWrite);

unsigned int mkChannelLinkMi2Si(FILE *Fp,
                        struct codeLine *head_ptr,
                        int ReadWrite);

unsigned int mkModule(struct codeLine *head_ptr, 
                      int SlaveMaster);

unsigned int getConnectSlave(DefMaster *VAL_MASTER, 
                        int *Connect);

/*
 * ReadWrite == 0  Write channel
 * ReadWrite == 1  Read channel
*/
unsigned int getConnectMaster(DefSlave *VAL_SLAVE, 
                        int *Connect, int ReadWrite);


unsigned int mkBuffChangeWire(FILE *Fp, struct codeLine *head_ptr, 
                          int endk,
                          int endi, 
                          char *FINDSTR,
                          int SlaveMaster);


unsigned int fileCopy(const char *read_file_name, 
                      const char *dest_file_name );

unsigned int genScript(char *fileName, char *DirFileName);

/*
 *   mode == 0  None slice
 *   mode == 1  Full slice
 *   mode == 2  Foward slice
 */
unsigned int mkRegSlice(
                        char *OutFileName,
                        char *name, 
                        char *sel, 
                        int wid, 
                        int mode);

/*
 * SlaveMaster = 0 -> slave
 * SlaveMaster = 1 -> master
 */
unsigned int mkWriteRS(
                DefMaster *VAL_MASTER,
                DefSlave *VAL_SLAVE,
                struct codeLine *head_ptr,
                int SlaveMaster);


/*
 * SlaveMaster = 0 -> slave
 * SlaveMaster = 1 -> master
 */
unsigned int mkReadRS(
                DefMaster *VAL_MASTER,
                DefSlave *VAL_SLAVE,
                struct codeLine *head_ptr,
                int SlaveMaster);

/*
 * ReadWrite = 00 -> single Write mode
 * ReadWrite = 01 -> single Read mode
 * ReadWrite = 10 -> dual Write mode
 * ReadWrite = 11 -> dual Read mode
 */
unsigned int mkRsModule(FILE *Fp, struct codeLine *head_ptr,
                        DefMaster *VAL_MASTER,
                        DefSlave  *VAL_SLAVE,
                        int ReadWrite);


/*
 * ReadWrite = 00 -> single Write mode
 * ReadWrite = 01 -> single Read mode
 * ReadWrite = 10 -> dual Write mode
 * ReadWrite = 11 -> dual Read mode
 */
unsigned int mkRsWire(FILE *Fp, struct codeLine *head_ptr,
                        DefMaster *VAL_MASTER,
                        DefSlave  *VAL_SLAVE,
                        int ReadWrite);

unsigned int mkBuffChangeENSI(FILE *Fp, struct codeLine *head_ptr, 
                          int endi, char *FINDSTR, 
                          int *Connect,
                          int ReadWrite);


unsigned int mkLockLink( FILE *Fp,struct codeLine *head_ptr, 
                            int ReadWrite );

