#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>

#ifdef __LITTLE_ENDIAN
#define REV_BYTES(x) ((x << 24) & 0xff000000) | ((x << 8) & 0x00ff0000) | ((x >> 8) & 0x0000ff00) | ((x >> 24) & 0x000000ff)
#else
#define REV_BYTES(x)
#endif

char *templ0 = 
	"-------------------------------------------------------------------------------\n"
	"-- Title      : Initialized On Chip Sync RAM\n"
	"-- Description: Auto Created by gen_vhdl_ram from %s\n"
	"-------------------------------------------------------------------------------\n"
	"-- File       : %s\n"
	"-- Author     : gen_vhdl_mem\n"
	"-- Company    : NikTech Inc.\n"
	"-- Created    : %s\n"
	"-------------------------------------------------------------------------------\n"
	"-- Copyright (c) 2005 \n"
	"-------------------------------------------------------------------------------\n"
	"-------------------------------------------------------------------------------\n"
	"library IEEE;\n"
	"use IEEE.STD_LOGIC_1164.ALL;\n"
	"use IEEE.STD_LOGIC_ARITH.ALL;\n"
	"use IEEE.STD_LOGIC_UNSIGNED.ALL;\n"
	
	"entity %s is\n"
	"generic (WIDTH      : integer := 32;\n"
	"         ADDR_WIDTH : integer := 32);\n"
	"port (clk   : std_logic;\n"
	"reset : std_logic;\n"          
	"-- Wishbone slave interface\n"
	"WBS_ADR_I : in  std_logic_vector (ADDR_WIDTH-1 downto 0);\n"
	"WBS_SEL_I : in  std_logic_vector (3 downto 0);\n"
	"WBS_DAT_I : in  std_logic_vector (WIDTH-1 downto 0);\n"
	"WBS_WE_I  : in  std_logic;\n"
	"WBS_STB_I : in  std_logic;\n"
	"WBS_CYC_I : in  std_logic;\n"
	"WBS_CTI_I : in  std_logic_vector (2 downto 0);\n"
	"WBS_BTE_I : in  std_logic_vector (1 downto 0);\n"
	"WBS_DAT_O : out std_logic_vector (WIDTH-1 downto 0);\n"
	"WBS_ACK_O : out std_logic;\n"
	"WBS_ERR_O : out std_logic);\n"
	"end %s;\n"
	"architecture RTL of %s is\n"
	"signal ben : std_logic_vector (3 downto 0) := \"0000\";\n"
	"signal wen : std_logic_vector (3 downto 0) := \"0000\";\n"
	"signal ack : std_logic := '0';\n"    
	"begin\n"
	"ben(0) <= WBS_STB_I and WBS_SEL_I(3);\n"
	"ben(1) <= WBS_STB_I and WBS_SEL_I(2);\n"
	"ben(2) <= WBS_STB_I and WBS_SEL_I(1);\n"
	"ben(3) <= WBS_STB_I and WBS_SEL_I(0);\n"
	"wen(0) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(3);\n"
        "wen(1) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(2);\n"
	"wen(2) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(1);\n"
	"wen(3) <= WBS_WE_I and WBS_STB_I and WBS_SEL_I(0);\n"    
	"process (clk, reset)\n"
	"begin\n"
        "if reset = '1' then\n"
	"ack <= '0';\n"
        "elsif rising_edge(clk) then\n"
	"if ack = '1' then\n"
	"ack <= '0' after 1 ns;\n"
	"else\n"
	"ack <= WBS_STB_I after 1 ns;\n"
	"end if;\n"
        "end if;\n"
	"end process;\n"
	"WBS_ACK_O <= ack;\n"
	"WBS_ERR_O <= '0';\n";

const char *tmpl1 =
	"mem_block: block\n"
	"signal raddr,waddr : std_logic_vector (%d-1 downto 0) := (others => '0');\n"
        "signal data_int    : std_logic_vector (WIDTH-1 downto 0);\n"
        "signal data_w      : std_logic_vector (WIDTH-1 downto 0);\n"
        "signal we          : std_logic := '0' ;\n";

const char *tmpl1_1 =
	"type ram_mem_type is array(0 to %d-1) of "; 

const char *tmpl1_11 = "std_logic_vector(%d-1 downto 0);\n"
	"attribute syn_ramstyle : string;\n";

const char *tmpl1_2 = 
	"signal ram_mem%d : ram_mem_type := (\n";
	
char *tmpl1_3 = 
	"attribute syn_ramstyle of ram_mem%d : signal is \"block_ram\";\n";

char *tmpl2 = 
	"begin\n"
        "process (clk)\n"
        "begin\n"
	"if rising_edge(clk) then\n"
	"raddr <= WBS_ADR_I(%d+1 downto 2);\n"
	"end if;\n"
        "end process;\n"
        "waddr <= WBS_ADR_I(%d+1 downto 2);\n"
        "process (clk, reset)\n"
        "begin\n"
	"if reset = '1' then\n"
	"we    <= '0';\n"
	"elsif rising_edge(clk) then\n"
	"if WBS_STB_I = '1' and WBS_WE_I = '1'  and ack = '0' then\n"
	"we <= '1';\n"
	"else\n"
	"we <= '0';\n"
	"end if;\n"
	"end if;\n"
        "end process ;\n"        
        "process (clk)\n"
        "begin\n"
	"if rising_edge(clk) then\n"
	"if we = '1' then\n";
char *tmpl2_1 =
	"ram_mem%d(conv_integer(waddr)) <= data_w((WIDTH*%d/%d)-1 downto WIDTH*%d/%d);\n";

char *tmpl2_2 =
	"end if;\n"
	"end if;\n"
        "end process ;\n"
	"data_int <= "; 
const char *tmpl2_3 = 
	"ram_mem%d(conv_integer(raddr))";
const char *tmpl2_4 =
        "data_w(WIDTH-1 downto 3*WIDTH/4) <= WBS_DAT_I(WIDTH-1 downto 3*WIDTH/4) when WBS_SEL_I(3) = '1' else\n"
	"data_int(WIDTH-1 downto 3*WIDTH/4); \n"
        "data_w((3*WIDTH/4)-1 downto 2*WIDTH/4) <= WBS_DAT_I((3*WIDTH/4)-1 downto 2*WIDTH/4) when WBS_SEL_I(2)='1' else\n"
	"data_int((3*WIDTH/4)-1 downto 2*WIDTH/4); \n"
        "data_w((2*WIDTH/4)-1 downto 1*WIDTH/4) <= WBS_DAT_I((2*WIDTH/4)-1 downto 1*WIDTH/4) when WBS_SEL_I(1)='1' else\n"
	"data_int((2*WIDTH/4)-1 downto 1*WIDTH/4); \n"
        "data_w((1*WIDTH/4)-1 downto 0*WIDTH/4) <= WBS_DAT_I((1*WIDTH/4)-1 downto 0*WIDTH/4) when WBS_SEL_I(0)='1' else\n"
	"data_int((1*WIDTH/4)-1 downto 0*WIDTH/4); \n"
        "WBS_DAT_O <= data_int;\n"
	"end block mem_block ;\n"
	"end RTL;\n";

static unsigned int npow2(int val, int *aw)
{
	unsigned int ret = 1;	

	*aw = 0;
	while (ret < val && ret != 0x80000000) {
		ret <<= 1;
		(*aw)++;
	}
	return ret;
}

static void pr_bin(unsigned int ival, int bits, FILE *outf)
{
	int i;
	for (i = 0; i < bits; i++) {
		putc (((ival & 0x80000000) ? '1' : '0'),outf);
		ival <<= 1;
	}
}

static void strtoupper(char *s)
{
	while (*s) {
		*s = toupper(*s);
		s++;
	}
}

int main(int argc, char *argv[]) 
{	
	FILE *ipf, *opf;
	int i, awidth = 0, dwidth, ditems, bpr;
	off_t fsize;
	int j, argn = 1;
	time_t t = time(NULL);
	struct stat s;
	int nrams = 1;
	char *vend = "XILINX";
	
	if (argc < 4) {
		printf("usage %s input_binary_file output_vhdl_filename vhdl_entity_name <vendor (XILINX,ALTERA,..)>\n");
		exit(-1);
	}
	
	/* parse arguments will come here */
	if (argc >= 5) {
		vend = strdup(argv[4]);
		strtoupper(vend);
	}
	if (!(ipf = fopen(argv[argn],"rb"))) {
		printf("cannot open input_binary_file %s\n",argv[argn]);
		exit (-1);
	}
	if (!(opf = fopen(argv[argn+1],"w"))) {
		printf("cannot open output_vhdl_file %s\n",argv[argn+1]);
		exit (-1);
	}
	
	fprintf(opf,templ0,
		argv[argn],    /* input binary file name */
		argv[argn+1],  /* output vhdl file name */
		ctime(&t),     /* creation timestamp */
		argv[argn+2],  /* vhdl entity name */
		argv[argn+2],  /* vhdl entity name */
		argv[argn+2]); /* vhdl entity name */

	stat(argv[argn],&s);
	fsize = npow2(s.st_size, &awidth);
	printf("File fize = %d ",fsize);
	printf("size = %d ",s.st_size);
	printf("awidth = %d\n",awidth);

	awidth -= 2;
	if (strncmp(vend,"XIL",3) == 0) {
		/* for Xilinx the initialization must be
		   broken down to Block Ram size */
		if (awidth <= 9) nrams = 1;
		else if (awidth <= 10) nrams = 2;
		else if (awidth <= 11) nrams = 4;
		else if (awidth <= 12) nrams = 8;
		else if (awidth <= 13) nrams = 16;
		else if (awidth <= 14) nrams = 32;
		else {
			printf("file to large to fit into internal memory\n");
			exit(-1);
		}
	} 

	dwidth = 32/nrams; /* bits per ram */
	ditems = 1<<awidth;
	fprintf(opf,tmpl1,awidth);
	fprintf(opf,tmpl1_1,ditems);
	fprintf(opf,tmpl1_11,dwidth);
	
	for (i = 0 ; i < nrams; i++) {
		unsigned int ib;
		j = 0;
		fprintf(opf,tmpl1_2,i);
		while (!feof(ipf)) {
			if (fread(&ib,sizeof(int),1,ipf) != 1) break;
			fprintf(opf,"\"");
			ib = REV_BYTES(ib);
			pr_bin( ib << (i*dwidth), dwidth, opf);			
			if (j < ditems) fprintf(opf,"\",");
			else fprintf(opf,"\"");
			fprintf(opf," -- 0x%08x",ib);
			fprintf(opf," 0x%x",j*4);
			fprintf(opf,"\n");
			j++;
		}
		for (; j < ditems; j++) {
			fprintf(opf,"\"");
			pr_bin( 0, dwidth, opf);
			if (j < (ditems - 1)) fprintf(opf,"\",");
			else fprintf(opf,"\"");
			fprintf(opf," -- 0x%x",j*4);
			fprintf(opf,"\n");
		}
		fprintf(opf,");\n");
		fprintf(opf,tmpl1_3,i);
		rewind(ipf);
	}

	fprintf(opf,tmpl2,awidth,awidth);
	for (i = 0 ; i < nrams; i++ ) {
		fprintf(opf,tmpl2_1,i,nrams-i,nrams,nrams-i-1,nrams);
	}
	fprintf(opf,tmpl2_2);
	for (i = 0 ; i < nrams; i++) {
		fprintf(opf,tmpl2_3,i);
		if (i < (nrams - 1)) fprintf(opf," & ");
		else fprintf(opf,";\n");
	}
	fprintf(opf,tmpl2_4);
	fclose(opf);
}
