# ifndef GenReqCnt_H
# define GenReqCnt_H

unsigned int genReqCnt(char *OutFileName, DefSlave *VAL_SLAVE);
unsigned int genLockCtl(char *OutFileName, 
                        DefSlave *VAL_SLAVE, int SlaveMaster);

# else
# endif
