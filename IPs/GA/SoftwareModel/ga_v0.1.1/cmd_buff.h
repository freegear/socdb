/*************************************************************************

   Header of the Command Buffer

   file name : cmdbuff.h

   created by gtlee

   data : 2006.6.26

   note :
        Depth : 32
          
   history :

************************************************************************/


//================================================
// Global


// Command code
// command kind
#define   LINEDRW         0x42
#define   FILLDRW         0x44
#define   BLTDRW          0x60
#define   ROTDRW          0x70
#define   CCONV           0x20

// length of the command structure 
#define   FILLCMDLEN      18
#define   BLTCMDLEN       29
#define   ROTCMDLEN       19
#define   CCONVCMDLEN     12


// Command Buffer
#define   CMDBUFF_DEPTH    32




#ifdef   __CMD_BUFF__
// Local

int lnklist(uint s_addr, uint e_addr);
int set_cmd_pnt(void);
int set_nxt_cmd(void);
int rd_cmds(int spos,int max_num);
uint rd_cmd_wd(int pos);

#else 
// External
extern uint    cmd_buff[CMDBUFF_DEPTH];

extern int lnklist(uint s_addr, uint e_addr);
extern int set_cmd_pnt(void);
extern int set_nxt_cmd(void);
extern int rd_cmds(int spos,int max_num);
extern uint rd_cmd_wd(int pos);

#endif
