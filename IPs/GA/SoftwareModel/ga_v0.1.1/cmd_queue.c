/*************************************************************************

   Command Queue

   file name : cmd_queue.c

   created by gtlee

   data : 2006.6.26

   note :
        Depth : 8
          
   history :

************************************************************************/


#ifndef  __CMD_QUEUE__
#define  __CMD_QUEUE__
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ga.h"

#include "cmd_queue.h"

#define  QUEUE_DEPTH      8

// Command queue
uint queue[QUEUE_DEPTH];

int   qstart = 0;
int   qend = 0;



//=====================================================
// store into the queue
//    use host processor
int str_queue(uint cmd_point)
// cmd_point : 저장할 data
// return : SUCC/FAIL
{
	int     end;
	int     start;

	// Check Full
	start = qstart;
	end = qend + 1;
	if(end >= QUEUE_DEPTH) end = 0;
	
	if(start == end) // Full
		return FAIL;
	
	qend = end;
	queue[qend] = cmd_point;

	return SUCC;

}// str_queue

//=====================================================
// command queue의 address를 fetch
uint ld_queue(void)
// return : command pointer
{
	int     start;

	// Check Empty
	if(qstart == qend) return 0; // empty

	start = qstart+1;
	if(start >= QUEUE_DEPTH) start = 0;
	
	qstart = start;
	return queue[qstart];
}
