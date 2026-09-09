#include <stdio.h>
#include <stdlib.h>
#include "vhpi_user.h"


// For socket programming
#define SOCKET
#ifdef SOCKET
#include <stdio.h>
#include <sys/types.h>
#include <sys/uio.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>

#define MAXMSG 256 /* 한번에 보낼 수 있는 메시지의 최대 길이 */
#define MAXHEAD 256 /* 메시지 해더의 최대 길이 */

char msg[MAXMSG], reply[MAXMSG]; /* 서버로 보낼 메시지와 Server에서 되돌아오는 메시지 */
char server_name[1024]; /* 서버명 */
char buf[1024];
int stdio_ta01_out=0;

char            header[MAXHEAD];
int             header_len=MAXHEAD;
char            data_buf[MAXMSG];
int             data_len=MAXMSG;
struct iovec    iobufs[2];


struct hostent *hp;
int t,n,sock1,sock2, clnt_len, serv_len,msglen,sendmsglen;
struct sockaddr_in serv_addr, clnt_addr;
char name[MAXHEAD],MSG[80];
int port_no;
#endif
#define OUT_TO_MONITOR 1
#define OUT_TO_SCSIM   2
#define OUT_TO_FILE	   3

/* =========================================================================
 * struct signal_t
 * struct stdio_ta01_t
 * ========================================================================= */

typedef enum endian_t { BIGENDIAN, LITTLEENDIAN } endian_t;

typedef struct signal_t
{
	vhpiHandleT port;
	vhpiValueT *value;
} signal_t;

typedef struct stdio_ta01_t
{
	signal_t clk,reset;
	signal_t da, ddout;
	signal_t dnmreq, dnrw;

	signal_t hgrant, hready, hresp, hrdata;
	signal_t hbusreq, hlock, htrans, haddr;

	unsigned long memsize;
	unsigned char *memarr;
	endian_t endian;
	int debug;
	FILE *fpOut;
} stdio_ta01_t;

/* =========================================================================
 * enum request_type_t
 * struct request_t
 * struct mreq_t
 * struct mstate_t
 * ========================================================================= */

typedef enum request_type_t
{
	req_idle, req_read, req_write
} request_type_t;

typedef enum request_size_t
{
	size_byte, size_half, size_word
} request_size_t;

typedef struct miss_t
{
	unsigned long freq;
	unsigned long delay;
} miss_t;

typedef struct mstate_t
{
	miss_t miss;
	request_type_t req;
	request_size_t size;
	unsigned long da;
	unsigned long tick;
	unsigned char ready;
} mstate_t;

static stdio_ta01_t stdio_ta01;
static mstate_t mstate;

/* =========================================================================
 * char *stdLogicLiterals[]
 * enum  stdLogicEnumT
 * ========================================================================= */

#if 0
char *stdLogicLiterals[] =
{
	"'U'", "'X'", "'O'", "'1'",
	"'Z'", "'W'", "'L'", "'H'",
	"'-'"
};
#endif

typedef enum
{
	STD_LOGIC_U,
	STD_LOGIC_X,
	STD_LOGIC_0,
	STD_LOGIC_1,
	STD_LOGIC_Z,
	STD_LOGIC_W,
	STD_LOGIC_L,
	STD_LOGIC_H,
	STD_LOGIC_D
} stdLogicEnumT;

/* =========================================================================
 * int get_enumvecval(unsigned long *value, vhpiEnumT *vec, int size)
 * int set_enumvecval(unsigned long *value, vhpiEnumT *vec, int size)
 * ========================================================================= */

static void write2stdio_ta01(char character);

static int get_enumvecval(unsigned long *value, vhpiEnumT *vec, int size)
{
	unsigned long bit = 0x80000000;
	int i;

	*value = 0x00000000;
	for (i = 0; i < size; i++)
	{
		if (vec[i] == STD_LOGIC_1 || vec[i] == STD_LOGIC_H)
		{
			*value |= bit;
		}
		else if (vec[i] == STD_LOGIC_0 || vec[i] == STD_LOGIC_L)
		{
		}
		else
		{
			return 0;
		}
		bit >>= 1;
	}
	return 1;
}

static int set_enumvecval(unsigned long value, vhpiEnumT *vec, int size)
{
	unsigned long bit = 0x80000000;
	int i;

	for (i = 0; i < size; i++)
	{
		vec[i] = value & bit ? STD_LOGIC_1 : STD_LOGIC_0;
		bit >>= 1;
	}
	return 1;
}

/* =========================================================================
 * void initStdio_ta01State(void);
 * void initStdio_ta01Memory(char *name)
 * ========================================================================= */

static void initStdio_ta01State(void)
{
	stdio_ta01.endian = LITTLEENDIAN;
	stdio_ta01.debug = 0;
	mstate.req = req_idle;
	stdio_ta01.fpOut = fopen("mon.out","wt");
}


/* =========================================================================
 * void evalStdio_ta01Signals(void)
 * void evalStdio_ta01DcacheSignals(void)
 * ========================================================================= */

static void evalStdio_ta01Signals(void)
{
	unsigned long data;

	if (mstate.ready)
	{
		switch (mstate.req)
		{
		case req_read:
			break;
		}

	}
	else
	{
	}
}

/* =========================================================================
 * void evalStdio_ta01IcacheClock(void)
 * void evalStdio_ta01DcacheClock(void)
 * ========================================================================= */

#if 0
void evalStdio_ta01IcacheClock(void)
{
	vhpiEnumT clk;
	vhpiEnumT dnmreq;

	vhpi_get_value(stdio_ta01.clk.port, stdio_ta01.clk.value);
	vhpi_get_value(stdio_ta01.dnmreq.port, stdio_ta01.dnmreq.value);
	vhpi_get_value(stdio_ta01.da.port, stdio_ta01.da.value);

	clk    = stdio_ta01.clk.value->value.enumval;
	dnmreq = stdio_ta01.dnmreq.value->value.enumval;

	if (clk == STD_LOGIC_1 || clk == STD_LOGIC_H)
	{
		if (mstate.icache.ready)
		{
			if (dnmreq == STD_LOGIC_0 || dnmreq == STD_LOGIC_L)
			{
				mstate.icache.req = req_read;
				get_enumvecval(&mstate.icache.da,
							   stdio_ta01.da.value->value.enums, 32);
			}
			else
			{
				mstate.icache.req = req_idle;
			}
		}

		if (mstate.icache.tick > 0) mstate.icache.tick--;
		if (mstate.icache.tick == 0) mstate.icache.ready = 1;

		evalStdio_ta01Signals();
	}
}
#endif

static void evalStdio_ta01Clock(void)
{
	vhpiEnumT clk;
	vhpiEnumT dnmreq;
	vhpiEnumT* da;
	vhpiEnumT* ddout;
	vhpiEnumT dnrw;
	unsigned char character;

	vhpi_get_value(stdio_ta01.clk.port, stdio_ta01.clk.value);
	vhpi_get_value(stdio_ta01.da.port, stdio_ta01.da.value);
	vhpi_get_value(stdio_ta01.ddout.port, stdio_ta01.ddout.value);
	vhpi_get_value(stdio_ta01.dnmreq.port, stdio_ta01.dnmreq.value);
	vhpi_get_value(stdio_ta01.dnrw.port, stdio_ta01.dnrw.value);

	clk    = stdio_ta01.clk.value->value.enumval;
	dnmreq = stdio_ta01.dnmreq.value->value.enumval;
	da   = stdio_ta01.da.value->value.enums;
	ddout   = stdio_ta01.ddout.value->value.enums;
	dnrw   = stdio_ta01.dnrw.value->value.enumval;

	if (clk == STD_LOGIC_1 || clk == STD_LOGIC_H)
	{
		{
			unsigned long data;
			switch (mstate.req)
			{
			case req_write:
				get_enumvecval(&data, stdio_ta01.ddout.value->value.enums, 32);
				character = data&0xFF;
				write2stdio_ta01(character);
				break;
			default:
				break;

			}

			if (dnmreq == STD_LOGIC_0 || dnmreq == STD_LOGIC_L)
			{
				if (dnrw == STD_LOGIC_0 || dnrw == STD_LOGIC_L)
					mstate.req = req_read;
				else if (dnrw == STD_LOGIC_1 || dnrw == STD_LOGIC_H)
					mstate.req = req_write;
				else
					mstate.req = req_idle;
				get_enumvecval(&mstate.da,
							   stdio_ta01.da.value->value.enums, 32);
//				genStdio_ta01DcacheMreq();
			}
			else
			{
				mstate.req = req_idle;
			}
		}

		if (mstate.tick > 0) mstate.tick--;
		if (mstate.tick == 0) mstate.ready = 1;

//		evalStdio_ta01DcacheSignals();
	}
}

/* =========================================================================
 * void initStdio_ta01Ports(vhpiHandleT compInst)
 * ========================================================================= */

static void initStdio_ta01Ports(vhpiHandleT compInst)
{
	stdio_ta01.da.port  = vhpi_handle_by_index(vhpiPortDecls, compInst, 1);
	stdio_ta01.ddout.port      = vhpi_handle_by_index(vhpiPortDecls, compInst, 2);
	stdio_ta01.dnmreq.port      = vhpi_handle_by_index(vhpiPortDecls, compInst, 3);
	stdio_ta01.dnrw.port  = vhpi_handle_by_index(vhpiPortDecls, compInst, 4);

	stdio_ta01.da.value  = (vhpiValueT *)malloc(sizeof (vhpiValueT));
	stdio_ta01.ddout.value      = (vhpiValueT *)malloc(sizeof (vhpiValueT));
	stdio_ta01.dnmreq.value      = (vhpiValueT *)malloc(sizeof (vhpiValueT));
	stdio_ta01.dnrw.value  = (vhpiValueT *)malloc(sizeof (vhpiValueT));

	stdio_ta01.da.value->format  = vhpiEnumVecVal;
	stdio_ta01.ddout.value->format      = vhpiEnumVecVal;
	stdio_ta01.dnmreq.value->format      = vhpiEnumVal;
	stdio_ta01.dnrw.value->format  = vhpiEnumVal;

	stdio_ta01.da.value->value.enums =
		(vhpiEnumT *)malloc(vhpi_value_size(stdio_ta01.da.port, vhpiEnumVecVal));
	stdio_ta01.ddout.value->value.enums =
		(vhpiEnumT *)malloc(vhpi_value_size(stdio_ta01.ddout.port, vhpiEnumVecVal));
	stdio_ta01.dnmreq.value->value.enums =
		(vhpiEnumT *)malloc(vhpi_value_size(stdio_ta01.dnmreq.port, vhpiEnumVal));
	stdio_ta01.dnrw.value->value.enums =
		(vhpiEnumT *)malloc(vhpi_value_size(stdio_ta01.dnrw.port, vhpiEnumVal));
}


/* =========================================================================
 * void handleErrors(vhpiCbDataT *cb)
 * void value_change_callback_on_clk_input(vhpiCbDataT *pCbData)
 * void stdio_ta01_elab(vhpiHandleT compInst)
 * void stdio_ta01_init(vhpiHandleT compInst)
 * ========================================================================= */

static void handleErrors(vhpiCbDataT *cb)
{
	vhpiErrorInfoT g_error;
	while (vhpi_chk_error(&g_error))
		vhpi_printf("\tError: %s: %s\n", g_error.str, g_error.message);
}

static void value_change_callback_on_clk_input(vhpiCbDataT *pCbData)
{
	vhpiHandleT obj = pCbData->obj;
	vhpiEnumT newVal;
 
	if (vhpi_compare_handles(obj, stdio_ta01.clk.port))
	{
		/* value-change on clk */
		stdio_ta01.clk.value = pCbData->value;
	}
	else
	{
		vhpi_printf("Incorrect object in value-change callback\n");
		vhpi_sim_control(vhpiFinish);
	}
 
	newVal = stdio_ta01.clk.value->value.enumval;
	if (newVal == STD_LOGIC_1 || newVal == STD_LOGIC_H)
	{
		evalStdio_ta01Clock();
	}
}

void stdio_ta01_elab(vhpiHandleT compInst)
{
	/* Register a callback on VHPI errors */
	vhpiHandleT  cbh;
	vhpiCbDataT *pCbData = (vhpiCbDataT *)malloc(sizeof (vhpiCbDataT));

	pCbData->cbf    = handleErrors;
	pCbData->time   = (vhpiTimeT *)malloc(sizeof (vhpiTimeT));
	pCbData->reason = vhpiCbPLIError;
	vhpi_register_cb(pCbData);
}



#ifdef SOCKET
void initStdio_ta01()
{
  FILE *fp;
  int port_no;

  if((fp=fopen("./stdio_ta01.cfg","r"))==NULL)
  {
		vhpi_printf("stdio_ta01.cfg doesn't exist!\n");
		return;
  }

  	while(fgets(buf,sizeof(buf),fp))
	{
		if(sscanf(buf,"port = %d",&port_no)==1)
			vhpi_printf("port = %d\n",port_no);
		if(sscanf(buf,"server = %s",server_name)==1)
			vhpi_printf("server = %s\n",server_name);
		if(sscanf(buf,"out = %d",&stdio_ta01_out)==1)
			vhpi_printf("out = %d\n",stdio_ta01_out);
	}
	close(fp);

	if(stdio_ta01_out==OUT_TO_MONITOR)
	{
  if((hp=gethostbyname(server_name)) == NULL) {
 		vhpi_printf("gethostbyname failed\n");
	return;
  }
  serv_len=sizeof(serv_addr);
  memset((char *)&serv_addr, '\0',serv_len);
  serv_addr.sin_family=AF_INET;
  serv_addr.sin_port = htons(port_no);
  memcpy((char *)&serv_addr.sin_addr, hp->h_addr, hp->h_length);

  if((sock1=socket(AF_INET, SOCK_STREAM, 0)) < 0) {
 	vhpi_printf("socket");
	return;
  }

  if(connect(sock1, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) <0) {
	vhpi_printf("connect1");
	return;
  }
	}
}


void sendStdio_ta01(unsigned char c)
{

  sprintf(data_buf,"%c",c); 	 
//  data_buf[1]='\0';
  iobufs[0].iov_base =(char *)&data_buf;
  iobufs[0].iov_len = 1;
//  msglen=strlen(msg);
 // serv_len=sizeof(serv_addr);
//  writev(sock1,iobufs,1);
	if(sock1>0)
	{
		while(send(sock1,data_buf,1,0)!=1);
	}

 serv_len = 0;
}

void write2stdio_ta01(char character)
{
	if(stdio_ta01_out==OUT_TO_MONITOR)
	{
		sendStdio_ta01(character);
	}
	else if(stdio_ta01_out==OUT_TO_SCSIM)
	{
		vhpi_printf("%c",character);
	}
	else if(stdio_ta01_out==OUT_TO_FILE)
	{
		fprintf(stdio_ta01.fpOut,"%c",character);
		fflush(stdio_ta01.fpOut);
	}
}
void stdio_ta01_init(vhpiHandleT compInst)
{
	vhpiHandleT ports_iter;
	vhpiCbDataT *pclkCbData;

	// Clock, Reset
	stdio_ta01.clk.port = vhpi_handle_by_index(vhpiPortDecls, compInst, 0);
	if (vhpi_get(vhpiModeP, stdio_ta01.clk.port) != vhpiIn)
	{
		vhpi_printf("Error: Port '%s' is not of mode out\n",
					vhpi_get_str(vhpiFullNameP, stdio_ta01.clk.port));
	}
	stdio_ta01.reset.port = vhpi_handle_by_index(vhpiPortDecls, compInst, 5);
	if (vhpi_get(vhpiModeP, stdio_ta01.reset.port) != vhpiIn)
	{
		vhpi_printf("Error: Port '%s' is not of mode out\n",
					vhpi_get_str(vhpiFullNameP, stdio_ta01.reset.port));
	}
	/* Allocate value-structures for the ports */
	stdio_ta01.clk.value = (vhpiValueT *)malloc(sizeof (vhpiValueT));
	stdio_ta01.clk.value->format = vhpiEnumVal;
	stdio_ta01.reset.value = (vhpiValueT *)malloc(sizeof (vhpiValueT));
	stdio_ta01.reset.value->format = vhpiEnumVal;

	/* Setup callback on i/p port1 */
	pclkCbData = (vhpiCbDataT *)malloc(sizeof (vhpiCbDataT));
	pclkCbData->reason = vhpiCbValueChange;
	pclkCbData->obj    = stdio_ta01.clk.port;
	pclkCbData->value  = stdio_ta01.clk.value;
	pclkCbData->time   = (vhpiTimeT *)malloc(sizeof (vhpiTimeT));
	pclkCbData->cbf    = value_change_callback_on_clk_input;
	vhpi_register_cb(pclkCbData);

	initStdio_ta01Ports(compInst);

	initStdio_ta01State();
//	initStdio_ta01Memory("./test_code/mem.dat");

//	initStdio_ta01Dcache("./test_code/dcache.dat");

//	genStdio_ta01IcacheMreq();
//	genStdio_ta01DcacheMreq();
	evalStdio_ta01Signals();
	initStdio_ta01();
}
#endif
