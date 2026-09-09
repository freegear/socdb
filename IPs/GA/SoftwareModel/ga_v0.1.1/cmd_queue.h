/*************************************************************************

   Header Command Queue

   file name : cmd_queue.c

   created by gtlee

   data : 2006.6.26

   note :
        Depth : 8
          
   history :

************************************************************************/

//=====================================
// Global




#ifdef __CMD_QUEUE__
// Local

int str_queue(uint cmd_point);
uint ld_queue(void);


#else
// External

extern int str_queue(uint cmd_point);
extern uint ld_queue(void);



#endif
