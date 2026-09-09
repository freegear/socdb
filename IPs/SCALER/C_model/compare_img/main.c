//*********************************
//	Bi-Liner interpolation
// 	by : thlee
//*********************************
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SIZE 2048*2048

//#define __DEBUG_input

#define four
#define __START
#define __DEBUG_data

/*
#define __DEBUG_cal
#define __DEBUG_hdown
#define __DEBUG_write
#define __DEBUG_vdn
#define __DEBUG_rd
*/


//#define __DEBUG_UU
//#define mem_test
//define __DEBUG_all

//#define __DEBUG0
//#define __DEBUG_up

#define RGBR 0
#define GBRG 1
#define BRGB 2

#define UP_UP 0
#define UP_DN 1
#define DN_UP 2
#define DN_DN 3

//**** calculation state machine ****
#define IDLE2    0
#define INIT     1
#define UU_HUP   2
#define UU_VUP   3
#define DU_HDOWN 4
#define DU_VUP   5
#define VDOWN    6
#define UD_HUP   7
#define DD_HDOWN 8
#define DD_VDOWN 9
#define WAIT     10


//**** read memory state machine ****
#define IDLE1        0
#define SETTING      1
#define R_MEM        2
#define R_COLOR_CONV 3

//**** write memory state machine ****
#define IDLE3        0
#define W_COLOR_CONV 1
#define W_OUT_BUF    2
#define W_MEM        3

//********** use initailize ***************
FILE *src_file=NULL;
FILE *out_file=NULL;
FILE *out_file1=NULL;
FILE *out_file2=NULL;
FILE *out_file3=NULL;
FILE *out_file4=NULL;
FILE *out_file5=NULL;
FILE *out_file6=NULL;
FILE *out_file7=NULL;

char *out_fname = "hex_conv.dat ";
char *out_fname1= "bpp_conv.dat";
char *out_fname2= "new_mem.dat";
char *out_fname3= "test.dat";
char *out_fname4= "debug.dat";
char *out_fname5= "memory.dat";
char *out_fname6= "debug_revise_mem.dat";
char *out_fname7= "revise_mem.dat";

int src_width,src_height; 
int new_width,new_height;
unsigned int bpp;

unsigned char *rgb_img;
unsigned int memory[SIZE]={0,};
unsigned int new_mem[SIZE]={0,};
unsigned int  revise_mem[SIZE]={0,};

int mem_size;
int in_dsize;
//********** use initailize ***************

int up(unsigned int *buf,unsigned int point1,unsigned int point2,unsigned long mul);

int vdown(unsigned int div,unsigned char cmd,
          unsigned int *buf_a,unsigned int *buf_r,
          unsigned int *buf_g,unsigned int *buf_b,
          unsigned int p0 ,unsigned int p1,
          unsigned int p2 ,unsigned int p3,
          unsigned int p4 ,unsigned int p5,
          unsigned int p6 ,unsigned int p7);

int help();
int bpp_argb16();
int bpp_rgb16();
int bpp_rgb24();
int bpp32_1888();
int bpp32_8888();
int memory_blk();

int conv_integer(float rate);


int main(int argc, char *argv[])
{
	int i=0,k=0;
    int cnt=0;
    int test_cnt=0;
    int mem_cnt=0;
    int mem_addr0;
	int mem_addr1;
		
    float factor_width=0;
    float factor_height=0;

// BitMap-4
    unsigned char ff;
    unsigned int  add_width;
    unsigned int  m=0,n=0,t=0;
//
    
    
    unsigned int conv_width=0;
    unsigned int conv_height=0;

    unsigned char div=0;
    unsigned long mul=0;
    unsigned long v_mul=0;
    unsigned long h_mul=0;
    unsigned long v_rate=0;
    unsigned long h_rate=0;
    unsigned long v_rate_cnt=0;
    unsigned long h_rate_cnt=0;
    unsigned long v_save_rate=0;
    unsigned long h_rate_save=0;
    unsigned long v_comp_cnt=0;
    unsigned long h_comp_cnt=0;
    
    
    
    unsigned int in_buf0[4];
    unsigned int in_buf1[4];
    unsigned int in_buf2[4];

    unsigned int out_buf[8];

    unsigned char in_buf_a[12]={0,};
    unsigned char in_buf_r[12]={0,};
    unsigned char in_buf_g[12]={0,};
    unsigned char in_buf_b[12]={0,};

    unsigned int cal_buf_a[5]={0,};
    unsigned int cal_buf_r[5]={0,};
    unsigned int cal_buf_g[5]={0,};
    unsigned int cal_buf_b[5]={0,};

    /*
    unsigned int cal_buf0=0;
    unsigned int cal_buf1=0;
    unsigned int cal_buf2=0;
    unsigned int cal_buf3=0;
    unsigned int cal_buf4=0;

    unsigned int cal_buf_a0=0;
    unsigned int cal_buf_a1=0;
    unsigned int cal_buf_a2=0;
    unsigned int cal_buf_a3=0;
    unsigned int cal_buf_a4=0;
    
    unsigned int cal_buf_r0=0;
    unsigned int cal_buf_r1=0;
    unsigned int cal_buf_r2=0;
    unsigned int cal_buf_r3=0;
    unsigned int cal_buf_r4=0;

    unsigned int cal_buf_g0=0;
    unsigned int cal_buf_g1=0;
    unsigned int cal_buf_g2=0;
    unsigned int cal_buf_g3=0;
    unsigned int cal_buf_g4=0;

    unsigned int cal_buf_b0=0;
    unsigned int cal_buf_b1=0;
    unsigned int cal_buf_b2=0;
    unsigned int cal_buf_b3=0;
    unsigned int cal_buf_b4=0;
*/
/*
    unsigned char result_a;
    unsigned char result_r;
    unsigned char result_g;
    unsigned char result_b;
*/
    unsigned int result_a;
    unsigned int result_r;
    unsigned int result_g;
    unsigned int result_b;

    unsigned char in_buf_addr0=0;
    unsigned char in_buf_addr1=0;
    unsigned char next_num=0;
    unsigned char in_buf_num=0;
    unsigned char in_buf_num0=0;
    unsigned char in_buf_num1=0;
    unsigned char cal_buf_num=0;
    unsigned char out_buf_num=0;

    unsigned int point_a0=0;
    unsigned int point_a1=0;
    unsigned int point_a2=0;
    unsigned int point_a3=0;
    unsigned int point_a4=0;
    unsigned int point_a5=0;
    unsigned int point_a6=0;
    unsigned int point_a7=0;

    unsigned int point_r0=0;
    unsigned int point_r1=0;
    unsigned int point_r2=0;
    unsigned int point_r3=0;
    unsigned int point_r4=0;
    unsigned int point_r5=0;
    unsigned int point_r6=0;
    unsigned int point_r7=0;

    unsigned int point_g0=0;
    unsigned int point_g1=0;
    unsigned int point_g2=0;
    unsigned int point_g3=0;
    unsigned int point_g4=0;
    unsigned int point_g5=0;
    unsigned int point_g6=0;
    unsigned int point_g7=0;

    unsigned int point_b0=0;
    unsigned int point_b1=0;
    unsigned int point_b2=0;
    unsigned int point_b3=0;
    unsigned int point_b4=0;
    unsigned int point_b5=0;
    unsigned int point_b6=0;
    unsigned int point_b7=0;

    unsigned char r_mem_cs=0;//read mem state machine
    unsigned char r_mem_ns=0;
    unsigned char w_mem_cs=0;//write mem state machine
    unsigned char w_mem_ns=0;
    unsigned char cal_cs=0;  //calculation state machine
    unsigned char cal_ns=0;
    
    //up_scaler
    unsigned char up_data_valid=0;

    //new_pix_counter
    unsigned int  h_new_pix_num=0;
    unsigned int  v_new_pix_num=0;
    unsigned int  v_new_pix_num_dly=0;
    unsigned int  h_new_pix_num_dly=0;
    //control signal
    unsigned char h_div=0;
    char rd_remain=0;
    char rd_remain_dly=0;
    unsigned char vdn_addr_latch=0;
    unsigned char first_row=0;
    unsigned int remain_height=0;
    unsigned int remain_width=0;
    unsigned int v_cnt=0;
    unsigned char rd_en=1;    
    unsigned char cal_buf_write=0;
    unsigned char r_vdown=0;
    unsigned char before_state=0;
    unsigned char no_hresize=0;
    unsigned char no_vresize=0;
   
    unsigned int  div_num_cnt=0;
    unsigned int  hdiv_num_cnt=0;
    unsigned char down_cmd=0;
    unsigned char rd_cmd_cnt=0;
    unsigned char last_column=0;
    unsigned char last_row=0;
    unsigned int  last_remain=0;
    unsigned char src_write=0;
    unsigned char seq_comp_val=0;
    unsigned char first=0;
    unsigned char go_wait=0;
    unsigned char go_vdown=0;
    unsigned char r_uu_hup=0;
    unsigned char r_du_hdown=0;
    unsigned char r_du_vup=0;
    unsigned char r_ud_hup=0;
    unsigned char r_dd_vdown=0;

    unsigned char start=0;
    unsigned char end=0;
    unsigned char buf_cnt_en=0;
    unsigned char rd_num=0;
    unsigned char dn_cmd=0;
    unsigned char wait=0;
    unsigned char keep=0;
    unsigned char cal_buf_en=0;
    unsigned char h_seq_cnt=0;
    unsigned char v_seq_cnt=0;  
    unsigned char l_full_buf=0;
    unsigned char h_addr0=0;
    unsigned char h_addr1=0;
    unsigned char v_addr0=0;
    unsigned char v_addr1=0;
    unsigned char refresh=0;
    unsigned char w_buf_en=0;

    unsigned int  height_cnt=0;
    unsigned int  height_cnt1=0;
    unsigned int  width_cnt =0;
    unsigned int  width_cnt1=0;

    unsigned long v_rate_base=0;
    unsigned long h_rate_base=0;
 
    unsigned int  h_new_pix_base=0;
    unsigned int  v_new_pix_base=0;
    unsigned int  h_pix_save=0;

    unsigned char up_ready=0;
    unsigned char vdown_ready=0;
    unsigned char hdown_ready=0;
    unsigned char up_enable=0;
    unsigned char vdown_enable=0;
    unsigned char hdown_enable=0;

    unsigned char v_rate_cnt_en=0;
    unsigned char h_rate_cnt_en=0;

    unsigned char src_enable=0;
    unsigned int  v_comp_val=0;
    unsigned int  h_comp_val=0;    

    unsigned char vertical_on=0;
    unsigned char horizontal_on=0;
    unsigned char in_buf_calculation=0;
    unsigned char end_calculation=0;

    unsigned long rd_addr=0;
    unsigned int  base_pix_num=0;
    unsigned int  read_pix_num=0;
    unsigned int  rd_h_pix_num=0;
    unsigned int  rd_v_pix_num=0;
    unsigned int  rd_v_pix_num_base=0;
    unsigned int  latch_read_pix_num=0;
    unsigned char rd_cmd=0;
    unsigned char read_cnt=0;
    unsigned char read_comp=0;
    unsigned long quotient=0;
    unsigned char remainder=0;
    unsigned char choice_cmd=0;
    unsigned char maintain=0;

    //write memory state machine
    unsigned char w_fsm_en=0;
    unsigned char full_buf=0;
    unsigned char end_wirte=0;

    unsigned char out_buf_flag=0;

    //calculation state machine
    unsigned char uu=0;
    unsigned char ud=0;
    unsigned char du=0;
    unsigned char dd=0;

    unsigned char cal_fsm_en=0;
    unsigned char go_idle=0;
    unsigned char go_uu=0;
    unsigned char go_ud=0;
    unsigned char go_du=0;
    unsigned char go_dd=0;
    unsigned char go_uu_hup=0;
    unsigned char go_uu_vup=0;
    unsigned char go_ud_vdown=0;
    unsigned char go_ud_hup=0;
    unsigned char go_du_hdown=0;
    unsigned char go_du_vup=0;
    unsigned char go_dd_vdown=0;
    unsigned char go_dd_hdown=0;

    //read memory state machine
    unsigned int  rd_pix=0;

    unsigned char go_setting=0;
    unsigned char r_fsm_en=0;
    unsigned char end_fill=0;
    unsigned char valid_data=0;
    unsigned char fill_buf=0;
    unsigned char full_buf0=0;
    unsigned char full_buf1=0;
    unsigned char full_buf2=0;
    
    unsigned char format=0;
    unsigned char odd=0;//use color_conv


    //number define
    unsigned int buf_num0;
    unsigned int buf_num1;
    
    int  width;
    int  height;
    
    unsigned char up_down;
    unsigned long src_pix_num=0;
    unsigned long new_pix_num=0;
////**************** use initailize *******************
	if(argc != 7)
	{
		help();
		return 0;
	}
	src_width = atoi(argv[1]);
	src_height = atoi(argv[2]);
	new_width = atoi(argv[3]);
	new_height = atoi(argv[4]);
	bpp = atoi(argv[5]);
	
    if((src_file = fopen(argv[6],"r")) == NULL)
	{	
		printf("can't open file \n");
		return 0;
	}
    memory_blk(); // memory block generation
	fclose(src_file);
    out_file2= fopen(out_fname2,"wt");
    out_file3= fopen(out_fname3,"wt");
    out_file4= fopen(out_fname4,"wt");
    out_file6= fopen(out_fname6,"wt");
    out_file7= fopen(out_fname7,"wt");
////**************** end initialize ********************

    
//******************************************************
//
//                   Bi-linear scalar 
//
//******************************************************

    if((new_width-src_width)<0)//horizontal down_sizing
    {
        factor_width = (float)src_width / (float)(new_width);
        h_rate=conv_integer(factor_width);
    } 
    else if((new_width-src_width)>=0);//horizontal up_sizing
    {
        factor_width = (float)(src_width-1) / (float)(new_width-1);
	    h_rate=conv_integer(factor_width);
    }
    if((new_height-src_height)<0)//vertical down_sizing
    {
        factor_height = (float)src_height / (float)(new_height);
	    v_rate=conv_integer(factor_height);
    }
    else if((new_height-src_height)>=0)//vertical up_sizing
    {
        factor_height = (float)(src_height-1) / (float)(new_height-1);
	    v_rate=conv_integer(factor_height);
    }
    
    width = src_width - new_width;
	height = src_height - new_height;
/*    
    h_rate_cnt=h_rate;
    h_rate_base=h_rate;
    v_rate_cnt=v_rate;
    v_rate_base=v_rate;
    h_rate_save=h_rate;
*/
    if((width>=0)&&(height>0)) dd=1; 
	else if((width<0)&&(height>=0)) ud=1; 
	else if((width>=0)&&(height<=0)) du=1; 
	else if((width<0)&&(height<0)) uu=1; 

#ifdef __START
    // rd_cmd 6번째 bit가 1이면 read continue 
    // rd_cmd 6번째 bit가 0이면 in_buf_num은 0부터 read
    // max read: 32개 까지 read ==> rd_cmd=0x3f;
    // 0x00: 1-line read , in_buf_num=0 :: 0x04: 1-line read continue   
    // 0x01: 2-line read , in_buf_num=0 :: 0x05: 2-line read continue
    // 0x02: 3-line read , in_buf_num=0 :: 0x06: 3-line read continue
    start=1;
    src_write=1;
    first_row=1;
    first=1;
    refresh=1;
    rd_num=4;
    rd_cmd=1;
    src_enable=1;
    base_pix_num=0;
    up_ready=1;
    vdown_ready=1;
    hdown_ready=1;
    seq_comp_val=2;
#endif

#ifdef mem_test
// mem_test시 사용    
    rd_v_pix_num=src_width;
    r_fsm_en=1;
//******************
#endif

#ifdef __START
    fprintf(out_file4,"width is %d\n",width);
    fprintf(out_file4,"height is %d\n",height);
    fprintf(out_file4,"src_width  :%d   new_width  :%d\n",src_width,new_width);
    fprintf(out_file4,"src_height :%d   new_height :%d\n",src_height,new_height);
    fprintf(out_file4,"factor_width is  %f\n",factor_width);
    fprintf(out_file4,"factor_heigth is %f\n",factor_height);
    fprintf(out_file4,"h_rate is %d :: %f\n",h_rate,(float)h_rate/65536);
    fprintf(out_file4,"v_rate is %d :: %f\n",v_rate,(float)v_rate/65536);
    fprintf(out_file4,"uu is %d :: ud is %d\n",uu,ud);
    fprintf(out_file4,"du is %d :: dd is %d\n",du,dd);
    fprintf(out_file4,"r_fsm_en is %d :: cal_fsm_en is %d\n",r_fsm_en,cal_fsm_en);
#endif

    
    
    
    
    
    //    while(new_pix_num!=new_width*new_height)
    //for(i=0;i<1000000;i++)
    while(go_idle==0)
    {
//******************************************************
//                   write memory
//******************************************************
        if(w_buf_en)
        {
            new_pix_num=v_new_pix_num+h_new_pix_num;
#ifdef __DEBUG_cal
            fprintf(out_file4,"\n");
            fprintf(out_file4,"WRITE NEW DATA\n");
            fprintf(out_file4,"v_new_pix_num   : %d  h_new_pix_num : %d\n",v_new_pix_num,h_new_pix_num);
            fprintf(out_file4,"new_pix_num : %d\n",new_pix_num);
            if(src_enable){
                if(no_hresize)
                {
                    fprintf(out_file4,"h_addr0 %d \n",h_addr0);
                    fprintf(out_file4,"in_buf_r[%d] : %02x in_buf_g[%d] : %02x in_buf_b[%d] : %02x \n",
                            h_addr0-1,in_buf_r[h_addr0-1],h_addr0-1,in_buf_g[h_addr0-1],h_addr0-1,in_buf_b[h_addr0-1]);
                }
                else if(no_vresize)
                {
                    fprintf(out_file4,"h_addr0 %d \n",h_addr0);
                    fprintf(out_file4,"in_buf_r[%d] : %02x in_buf_g[%d] : %02x in_buf_b[%d] : %02x \n",
                            h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
                }
                else if(ud)
                {
                    fprintf(out_file4,"cal_buf_r[0] : %02x cal_buf_g[0] : %02x cal_buf_b[0] : %02x \n",
                            cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]);
                }
                else
                {
                    fprintf(out_file4,"cal_buf_r[0] : %02x cal_buf_g[0] : %02x cal_buf_b[0] : %02x \n",
                            cal_buf_r[h_addr0-1],cal_buf_g[h_addr0-1],cal_buf_b[h_addr0-1]);
                }

            }else
                fprintf(out_file4,"result_r    : %02x result_g : %02x result_b : %02x \n",result_r,result_g,result_b);
#endif
                fprintf(out_file4,"SRC WRITE %d\n",src_write);
            
            if(uu && new_pix_num==0)
                new_mem[new_pix_num]=0xffffff & ((in_buf_r[0]<<16) | (in_buf_g[0]<<8) | (in_buf_b[0]));
            else if(du & src_enable)
            {
                if(no_hresize)
                    new_mem[new_pix_num]=0xffffff & 
                    ((in_buf_r[h_addr0-1]<<16) | (in_buf_g[h_addr0-1]<<8) | (in_buf_b[h_addr0-1]));
                else
                    new_mem[new_pix_num]=0xffffff & 
                    ((cal_buf_r[0]<<16) | (cal_buf_g[0]<<8) | (cal_buf_b[0]));
            }
            else if(ud & src_enable)
            {
                if(no_vresize)
                    new_mem[new_pix_num]=0xffffff & 
                    ((in_buf_r[h_addr0]<<16) | (in_buf_g[h_addr0]<<8) | (in_buf_b[h_addr0]));
                else
                    new_mem[new_pix_num]=0xffffff & 
                    ((cal_buf_r[0]<<16) | (cal_buf_g[0]<<8) | (cal_buf_b[0]));
            }
            else if(dd & no_hresize)
            {
                if(remain_width<4 & h_new_pix_num!=0)
                    k=remain_width;
                else k=4;
                for(i=0;i<k;i++)
                {
                    new_mem[new_pix_num+i]=0xffffff & ((cal_buf_r[i]<<16) | (cal_buf_g[i]<<8) | (cal_buf_b[i]));
fprintf(out_file4,"new_pix_num %d \n",new_pix_num+i);
fprintf(out_file4,"cal_buf_r[%d] : %02x cal_buf_g[%d] : %02x cal_buf_b[%d] : %02x \n",
        i,cal_buf_r[i],i,cal_buf_g[i],i,cal_buf_b[i]);
                }
            }
            else if(du & no_vresize)
            {
                for(i=0;i<3;i++)
                {
                    new_mem[new_pix_num+(new_width*i)]=0xffffff & ((cal_buf_r[i]<<16) | (cal_buf_g[i]<<8) | (cal_buf_b[i]));
fprintf(out_file4,"new_pix_num %d \n",new_pix_num+(new_width*i));
fprintf(out_file4,"cal_buf_r[%d] : %02x cal_buf_g[%d] : %02x cal_buf_b[%d] : %02x \n",
        i,cal_buf_r[i],i,cal_buf_g[i],i,cal_buf_b[i]);
                }
            }
            else
                new_mem[new_pix_num]=0xffffff & ((result_r<<16) | (result_g<<8) | (result_b));

            fprintf(out_file3,"%8d : %08x\n ",new_pix_num,new_mem[new_pix_num]&0xffffffff);
        }

//****************** end write_mem *********************


//******************************************************
//                   calculation 
//******************************************************
#ifdef __DEBUG_all
        printf("CALCULATION\n");
        printf("width_cnt is  : %d\n",width_cnt);
        printf("height_cnt is : %d\n",height_cnt);
        printf("new_pix_num   : %d\n",new_pix_num);
        printf("read_pix_num  : %d\n",read_pix_num);

#endif
        go_uu = cal_fsm_en & uu;
        go_ud = cal_fsm_en & ud & ~go_ud_hup & ~go_dd_hdown;
        go_du = cal_fsm_en & du;
        go_dd = cal_fsm_en & dd & ~go_ud_hup & ~go_dd_hdown;


        cal_cs=cal_ns;
#ifdef __DEBUG_cal
        switch(cal_cs)
        {   
            case 0:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : IDLE2\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 1:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : INIT\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 2:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : UU_HUP\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 3:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : UU_VUP\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 4:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : DU_HDOWN\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 5:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : DU_VUP\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 6:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : VDOWN\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 7:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : UD_HUP\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 8:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : DD_HDOWN\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 9:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : DD_VDOWN\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
            case 10:
                fprintf(out_file4,"---------------------------------\n");
                fprintf(out_file4,"calculation current state : WAIT\n");
                fprintf(out_file4,"---------------------------------\n");
                break;
        }
        fprintf(out_file4,"start is    : %d\n",start);
        
#endif
        if(h_seq_cnt==0)
        {
            l_full_buf=full_buf;
        }
/*        
        if(refresh)
        { 
            if(full_buf==0x03)
            {   
                if(uu | du){
                    h_addr0=0;
                    h_addr1=1;
                }else h_addr0=4;
            }
            else if(full_buf==0x06)
            {
                if(uu | du){
                    h_addr0=4;
                    h_addr1=5;
                }else h_addr0=8;
            }
            else if(full_buf==0x05)
            {
                if(uu | du){
                    h_addr0=8;
                    h_addr1=9;
                }else h_addr0=0;
            }
        }
*/
        if(refresh)
        { 
            if(full_buf==0x03)
            {   
                if(vdn_addr_latch==0){
                    h_addr0=0;
                    h_addr1=1;
                }else h_addr0=4;
            }
            else if(full_buf==0x06)
            {
                if(vdn_addr_latch==0){
                    h_addr0=4;
                    h_addr1=5;
                }else h_addr0=8;
            }
            else if(full_buf==0x05)
            {
                if(vdn_addr_latch==0){
                    h_addr0=8;
                    h_addr1=9;
                }else h_addr0=0;
            }
        }
#ifdef __DEBUG_cal
        fprintf(out_file4,"full_buf is : %d\n",full_buf);
        fprintf(out_file4,"++++++++++++++++++\n");
        fprintf(out_file4,"refresh is  : %d\n",refresh);    
        fprintf(out_file4,"h_addr0 is  : %d\n",h_addr0);    
        fprintf(out_file4,"h_addr1 is  : %d\n",h_addr1);    
        fprintf(out_file4,"++++++++++++++++++\n");
#endif
        if(uu){
            if(((h_rate_cnt>>16)>=(src_width-1)) && ((v_rate_cnt>>16)>=(src_height-1))) go_idle=1;
            else go_idle=0;
        }
#ifdef __DEBUG_UU
        if(go_idle) printf("go_idle is %d\n\n",go_idle);
#endif
        if(uu){
            if(height_cnt==(src_height-3) && h_rate_cnt!=h_comp_val)//마지막 height 하나전에
                last_remain=(src_width-1)-(rd_h_pix_num+3);            
            if(last_remain==1 || last_remain==2 || last_remain==3 || last_remain==4)
                last_column=1;
            else last_column=0;
        }
        else if(du)
        {
            last_remain=(src_width)%4;
            if(((src_width-1)-(rd_h_pix_num))<4)
                last_column=1;
            else last_column=0;
        }


#ifdef __DEBUG_write
        fprintf(out_file4,"last_remain is %d :: last_column is %d\n",last_remain,last_column);
#endif

        if(cal_cs==IDLE2)
        {
            point_a0=0;
            point_a1=0;
            point_a2=0;
            point_a3=0;
            point_a4=0;
            point_a5=0;
            point_a6=0;
            point_a7=0;

            point_r0=0;
            point_r1=0;
            point_r2=0;
            point_r3=0;
            point_r4=0;
            point_r5=0;
            point_r6=0;
            point_r7=0;

            point_g0=0;
            point_g1=0;
            point_g2=0;
            point_g3=0;
            point_g4=0;
            point_g5=0;
            point_g6=0;
            point_g7=0;

            point_b0=0;
            point_b1=0;
            point_b2=0;
            point_b3=0;
            point_b4=0;
            point_b5=0;
            point_b6=0;
            point_b7=0;
        }// end IDLE2
        else if(cal_cs==INIT)
        {
            if(end_fill) cal_fsm_en=1;

            start=0;
            read_pix_num=0;
            //1clk cycle만 r_fsm_en=1
            if(first) r_fsm_en=1;
            else r_fsm_en=0;
            first=0;
            //////////////////////////
            if(uu)
            {
                rd_cmd=0x01;
                rd_num=4;
                h_rate_cnt=h_rate;
                h_rate_base=h_rate;
                v_rate_cnt=v_rate;
                v_rate_base=v_rate;
                h_rate_save=h_rate;
            }
            else if(du)
            {
                go_du_vup=0;
                go_du_hdown=0;
                seq_comp_val=4;
                src_enable=0;
//                rd_cmd=0x01;
                rd_num=4;
                if((h_rate>>16)==1 && (h_rate&0xffff)==0) //horizontal=1 next_state:DU_VUP
                {
                    rd_cmd=0x01; //2-line read
                    if(cal_fsm_en==1) go_du_vup=1;
                    no_hresize=1;
                }else{ // next_state:DU_HDOWN
                    rd_cmd=0x02; //3-line read
                    if(cal_fsm_en==1) go_du_hdown=1;
                    no_hresize=0;

                    if((v_rate>>16)==1 && (v_rate&0xffff)==0) 
                        no_vresize=1;                
                }
                v_rate_cnt=v_rate;
                v_rate_base=v_rate;
                h_rate_cnt=h_rate;
                h_rate_base=0;
                div=((v_rate+32768)>>16);//v_rate+0.5
            }
            else if(ud)
            {
                go_ud_hup=0;
                go_vdown=0;
                go_dd_hdown=0;
                v_rate_cnt=v_rate;
                h_rate_cnt=h_rate;
                h_rate_base=h_rate;
                v_rate_base=0;
                if((v_rate>>16)==1 && (v_rate&0xffff)==0)//vertical =1 next-state:UD_HUP 
                {
                    src_enable=0;///// test할것
                    rd_cmd=0x01;
                    rd_num=4;
                    no_vresize=1;
                    if(cal_fsm_en==1) {
                        go_ud_hup=1;
                    }

                }
                else
                {
                    no_vresize=0;
                    rd_cmd=0x02;
                    rd_num=4;
                    if(cal_fsm_en==1)
                        go_vdown=1;
                }
            }
            else if(dd)
            {
                src_enable=0;
                v_rate_cnt=v_rate;
                h_rate_cnt=h_rate;
                h_rate_base=0;
                v_rate_base=0;
                remain_width=src_width;
                vdn_addr_latch=1;
                no_vresize=0;
                no_hresize=0;
                rd_cmd=0x02; //3-line read
                rd_num=4;
                if((h_rate>>16)==1 && (h_rate&0xffff)==0) //horizontal=1 next_state:VDOWN            
                {
                    vdn_addr_latch=1;
                    rd_cmd=0x02;
                    rd_num=4;
                    no_hresize=1;
                    if(cal_fsm_en==1)
                        go_vdown=1;
                }
                else
                {
                    if(cal_fsm_en)
                       go_dd_vdown=1;
                }
            }

#ifdef __DEBUG_vdn
            fprintf(out_file4,"div is %d\n",div);
#endif
       }
        else if(cal_cs==UU_HUP) ////// UP_UP_HUP //////
        {
            cal_buf_en=0;
            w_buf_en=0;
            keep=0;
            rd_cmd=0x20; // 1-line read continue
            fill_buf=0;
            h_rate_cnt_en=0;
            up_enable=0;
            go_wait=0;
            if(up_ready) 
            {
                refresh=0;
#ifdef __DEBUG_UU
                fprintf(out_file4,"h_rate_cnt>>16: %d  h_comp_val :%d \n",h_rate_cnt>>16,h_comp_val);
                fprintf(out_file4,"v_rate_cnt>>16: %d  v_comp_val :%d \n",v_rate_cnt>>16,v_comp_val);
                fprintf(out_file4,"h_seq_cnt: %d  seq_comp_val :%d \n",h_seq_cnt,seq_comp_val);
                fprintf(out_file4,"src_enable :%d \n",src_enable);
#endif
                if(src_write)
                {
                    w_buf_en=1;
                    src_write=0;
#ifdef __DEBUG_UU
                fprintf(out_file4,"SOURCE PIXEL WRITE \n");
                fprintf(out_file4,"SOURCE PIXEL WRITE \n");
                fprintf(out_file4,"SOURCE PIXEL WRITE \n");
#endif
                }
                else
                {
                    if((h_rate_cnt>>16)==h_comp_val)
                    {
                        h_rate_cnt_en=1;
                        go_uu_vup=0;
                        mul=h_rate_cnt;
                        up_enable=1;
                        if(src_enable)
                        {
                            point_a0=in_buf_a[h_addr0];
                            point_a1=in_buf_a[h_addr1];
                            point_r0=in_buf_r[h_addr0];
                            point_r1=in_buf_r[h_addr1];
                            point_g0=in_buf_g[h_addr0];
                            point_g1=in_buf_g[h_addr1];
                            point_b0=in_buf_b[h_addr0];
                            point_b1=in_buf_b[h_addr1];
#ifdef __DEBUG_UU
        fprintf(out_file4,"in_buf_r[%d]=%d :: in_buf_g[%d]=%d :: in_buf_b[%d]=%d \n",
                h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
        fprintf(out_file4,"in_buf_r[%d]=%d :: in_buf_g[%d]=%d :: in_buf_b[%d]=%d \n",
                h_addr1,in_buf_r[h_addr1],h_addr1,in_buf_g[h_addr1],h_addr1,in_buf_b[h_addr1]);
#endif
                        }
                        else 
                        {
                            point_a0=cal_buf_a[0];
                            point_a1=cal_buf_a[1];
                            point_r0=cal_buf_r[0];
                            point_r1=cal_buf_r[1];
                            point_g0=cal_buf_g[0];
                            point_g1=cal_buf_g[1];
                            point_b0=cal_buf_b[0];
                            point_b1=cal_buf_b[1];
                        }
                        w_buf_en=1;
                    }
                    else 
                    {
                        if((v_rate_cnt>>16)==v_comp_val)
                        {
                            go_uu_vup=1;
                            h_rate_cnt=h_rate_base;
                            h_new_pix_num=h_new_pix_base;
                        }
                        else
                        {
                            if(h_seq_cnt==seq_comp_val)/////////
                            {
                                if(r_mem_cs==IDLE1 || r_mem_ns==IDLE1) go_wait=0;
                                else go_wait=1;
                                if(last_column & seq_comp_val==0)
                                {
                                    if(height_cnt!=(src_height-2))//read buffer fill
                                    {
                                        if(height_cnt==0)
                                            rd_v_pix_num=src_width + src_width;
                                        else
                                            rd_v_pix_num=rd_v_pix_num + src_width;
                                        go_wait=1;
                                        fill_buf=1;
                                        rd_cmd=0x20; //1-line_read continue
                                    }
                                }
                                refresh=1;
                                h_seq_cnt=0;
                                v_comp_val=v_rate_cnt>>16;
                                v_rate_base=v_rate_cnt;
                                v_new_pix_base=v_new_pix_num+new_width;//-*-*-*
                                h_comp_val=h_rate_save>>16;
                                
                                if(height_cnt==(src_height-2)) // last height?
                                {
                                    height_cnt=0;
                                    h_rate_save=h_rate_cnt;
                                    h_rate_base=h_rate_cnt;
                                    h_comp_val=h_rate_cnt>>16;
                                    h_pix_save=h_new_pix_num;//-*-*-*
                                    h_new_pix_base=h_new_pix_num;//-*-*-*

                                    v_rate_cnt=v_rate; //first column
                                    v_rate_base=v_rate;
                                    v_comp_val=0;
                                    v_new_pix_num=0;//-*-*-*
                                    v_new_pix_base=0;

                                    rd_v_pix_num=0;

                                    //rd_buffer fill
                                    if(last_remain==1){
                                        seq_comp_val=0;
                                        rd_num=2;
                                    }else if(last_remain==2){
                                        seq_comp_val=1;
                                        rd_num=3;
                                    }else if(last_remain){
                                        seq_comp_val=2;
                                        rd_num=4;
                                    }
                                    go_wait=1;
                                    fill_buf=1;
                                    rd_cmd=0x01;//2-line_read 0 reset

                                    rd_h_pix_num=rd_h_pix_num+3;
                                }
                                else
                                {
                                    height_cnt=height_cnt+1;
                                    h_rate_cnt=h_rate_save;
                                    h_rate_base=h_rate_save;
                                    h_new_pix_num=h_pix_save;//*-*-*-
                                    h_new_pix_base=h_pix_save;//-*-*-*
                                }
                                if(v_rate_cnt==v_rate)
                                {
                                    src_enable=1;
                                    go_uu_vup=0;
                                }
                                else 
                                {
                                    src_enable=0;
                                    go_uu_vup=1;
                                }
                            }
                            else // seq_cnt !=2
                            {
                                if(v_rate_base==v_rate)
                                {
                                    go_uu_vup=0;//operation HUP
                                    src_enable=1;
                                    fprintf(out_file4,"KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK\n");
                                }
                                else
                                {
                                    src_enable=0;
                                    if(v_comp_val==0) go_uu_vup=0;
                                    else
                                    {
                                        keep=1;
                                        go_uu_vup=1;
                                    }
                                }
                                //fill_buf=0;
                                if(((v_rate_cnt>>16) != v_comp_val) && h_seq_cnt==0)
                                {
                                    if(height_cnt!=(src_height-2))//read buffer fill
                                    {
                                        if(height_cnt==0)
                                            rd_v_pix_num=src_width + src_width;
                                        else
                                            rd_v_pix_num=rd_v_pix_num + src_width;
                                       fill_buf=1;
                                        rd_cmd=0x20;//1-line read continue
                                    }
                                    //else fill_buf=0;
                                }
                                h_comp_val=h_rate_cnt>>16;
                                refresh=0;
                                v_rate_cnt=v_rate_base;
                                v_new_pix_num=v_new_pix_base;//*-*-*
                                h_rate_base=h_rate_cnt;
                                h_new_pix_base=h_new_pix_num;//*-*-*-
                                h_seq_cnt=h_seq_cnt+1;
                                h_addr0=h_addr0+1;
                                h_addr1=h_addr1+1;
                            }//seq_cnt!=2
                        }//if((v_rate_cnt>>16)==v_comp_val)
                    }//if((h_rate_cnt>>16)==h_comp_val)
                }//if(src_write) else
            }//if(ready)
            //h_rate counter
            if(h_rate_cnt_en)
            {
                h_rate_cnt=h_rate_cnt+h_rate;
                h_new_pix_num=h_new_pix_num+1;
            }
        }// end UU_HUP
        else if(cal_cs==UU_VUP) ////// UP_UP_VUP //////
        {
            src_enable=0;
            cal_buf_en=1;
            w_buf_en=0;
            if(up_ready) 
            {
                if((v_rate_cnt>>16)==v_comp_val)
                {
                    if(v_seq_cnt==1)
                    {
                        v_rate_cnt_en=1;
                        v_seq_cnt=0;
                        go_uu_hup=1;
                        if(h_addr0>7)
                        {
                            v_addr0=h_addr1;
                            v_addr1=h_addr1-8;
                        }
                        else
                        {
                            v_addr0=h_addr1;
                            v_addr1=h_addr1+4;
                        }
                    }
                    else
                    {
                        if(keep==0) v_new_pix_num=v_new_pix_num+new_width;
                        else v_new_pix_num=v_new_pix_num;
                        if((h_rate_cnt>>16)==0) w_buf_en=1;
  
                        v_rate_cnt_en=0;
                        v_seq_cnt=1;
                        go_uu_hup=0;
                        if(h_addr0>7)
                        {
                            v_addr0=h_addr0;
                            v_addr1=h_addr0-8;
                        }
                        else
                        {
                            v_addr0=h_addr0;
                            v_addr1=h_addr0+4;
                        }
                    }
                    up_enable=1;
                    mul=v_rate_cnt;
                    point_a0=in_buf_a[v_addr0];
                    point_a1=in_buf_a[v_addr1];
                    point_r0=in_buf_r[v_addr0];
                    point_r1=in_buf_r[v_addr1];
                    point_g0=in_buf_g[v_addr0];
                    point_g1=in_buf_g[v_addr1];
                    point_b0=in_buf_b[v_addr0];
                    point_b1=in_buf_b[v_addr1];
                }
                else 
                {
                    v_rate_cnt_en=0;
                    up_enable=0;
                    v_rate_cnt=v_rate_base;
                }
            }//end if(up_ready)
#ifdef __DEBUG_UU
            fprintf(out_file4,"\n");
            fprintf(out_file4,"v_addr0 is       : %d\n",v_addr0);    
            fprintf(out_file4,"v_addr1 is       : %d\n",v_addr1);    
            fprintf(out_file4,"\n");
#endif

            if(v_rate_cnt_en)
            {
                v_rate_cnt=v_rate_cnt+v_rate;
            }
            
        }// end UU_VUP
        else if(cal_cs==DU_HDOWN) ////// DOWN_UP_HDOWN //////
        {
            go_idle=0;
            down_cmd=0;
            last_row=0;
            hdown_enable=1;
            go_du_vup=0;
            go_du_hdown=0;
            before_state=DU_HDOWN;
            w_buf_en=0;
            if(hdown_ready==1)
            {
                if(h_seq_cnt==seq_comp_val || width_cnt==new_width) //buffer empty
                {
                    go_wait=1;
                    h_seq_cnt=0;
                    hdown_enable=0;
                    fill_buf=1;
                    rd_num=4;
                    if(width_cnt==new_width)
                    {
                        h_rate_base=0;
                        rd_h_pix_num=0;
                        h_rate_cnt=h_rate;
                        v_cnt=v_cnt+2;
                        remain_height=src_height-v_cnt;
                        width_cnt=0;
                        if(no_vresize)//06.26 added
                        {
                            if(v_cnt>new_height) go_idle=1;
                            else go_idle=0;
                            v_new_pix_num=v_new_pix_num+new_width*3;
                            h_new_pix_num_dly=0;
                            rd_v_pix_num=rd_v_pix_num+(src_width*3);// vertical=1
                        }
                        else
                        {
                            rd_v_pix_num=rd_v_pix_num+(src_width*2);//vertical 중복
                        }
                    }
                    else rd_h_pix_num=rd_h_pix_num+4;

                    if(remain_height<=2)
                    {
                        last_row=1;
                        if(remain_height==1)
                            rd_cmd=0x01; //1-line_read;
                        else if(remain_height==2)
                            rd_cmd=0x02; //2-line_read;
//                        else if(remain_height==3)
//                            rd_cmd=0x02; //3-line_read;
                    }
                    else
                    {
                        rd_cmd=0x02; //3-line_read;
                    }
                }
                else
                {
                    go_wait=0;
                    if(div_num_cnt==0)
                    {   
                        hdown_enable=0;
    //                    if(remain_cnt==4) remain_cnt=0;
                        //point calculation
#ifdef __DEBUG_cal
fprintf(out_file4,"//////// HDOWN CAL BUF INIT////////\n");
fprintf(out_file4," 1 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
        h_seq_cnt,in_buf_r[h_seq_cnt],h_seq_cnt,in_buf_g[h_seq_cnt],h_seq_cnt,in_buf_b[h_seq_cnt]);
fprintf(out_file4," 2 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
        h_seq_cnt+4,in_buf_r[h_seq_cnt+4],h_seq_cnt+4,in_buf_g[h_seq_cnt+4],h_seq_cnt+4,in_buf_b[h_seq_cnt+4]);
fprintf(out_file4," 3 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
        h_seq_cnt+8,in_buf_r[h_seq_cnt+8],h_seq_cnt+8,in_buf_g[h_seq_cnt+8],h_seq_cnt+8,in_buf_b[h_seq_cnt+8]);
#endif
                        cal_buf_a[0]=in_buf_a[h_seq_cnt];
                        cal_buf_r[0]=in_buf_r[h_seq_cnt];
                        cal_buf_g[0]=in_buf_g[h_seq_cnt];
                        cal_buf_b[0]=in_buf_b[h_seq_cnt];

                        cal_buf_a[1]=in_buf_a[h_seq_cnt+4];
                        cal_buf_r[1]=in_buf_r[h_seq_cnt+4];
                        cal_buf_g[1]=in_buf_g[h_seq_cnt+4];
                        cal_buf_b[1]=in_buf_b[h_seq_cnt+4];

                        cal_buf_a[2]=in_buf_a[h_seq_cnt+8];
                        cal_buf_r[2]=in_buf_r[h_seq_cnt+8];
                        cal_buf_g[2]=in_buf_g[h_seq_cnt+8];
                        cal_buf_b[2]=in_buf_b[h_seq_cnt+8];
                        if(width_cnt==(new_width-1) && 
                           last_remain==1 && 
                           h_seq_cnt==h_comp_val) /////확인 요망
                        {
                            width_cnt=width_cnt+1;
                            go_du_vup=1;
                            down_cmd=0x01;// cal_buf/div
                            div_num_cnt=0;
                            h_rate_base=h_rate_cnt;
                            h_rate_cnt=h_rate_cnt+h_rate;
                            //h_seq_cnt=h_seq_cnt+1;
                            fprintf(out_file4,"width_cnt %d\n",width_cnt);
                        }
                        else
                        {
                            if((h_rate>>16)<2)
                            {
                                h_comp_val=1;
                                div=2;
                            }else
                            { 
                                if((new_width-1)==width_cnt) //last
                                    div=src_width-(h_rate_base>>16); 
                                else div=((h_rate_cnt)>>16)-(h_rate_base>>16);
                                    h_comp_val=div-1;
                            }
                            div_num_cnt=div_num_cnt+1;
                        }
                        h_seq_cnt=h_seq_cnt+1;
                    }
                    else  
                    {
                        //point calculation
                        fprintf(out_file4,"//////// HDOWN POINT CALCULATION ////////\n");
                        point_a0=cal_buf_a[0];
                        point_r0=cal_buf_r[0];
                        point_g0=cal_buf_g[0];
                        point_b0=cal_buf_b[0];

                        point_a1=in_buf_a[h_seq_cnt];
                        point_r1=in_buf_r[h_seq_cnt];
                        point_g1=in_buf_g[h_seq_cnt];
                        point_b1=in_buf_b[h_seq_cnt];
                        
                        point_a2=cal_buf_a[1];
                        point_r2=cal_buf_r[1];
                        point_g2=cal_buf_g[1];
                        point_b2=cal_buf_b[1];

                        point_a3=in_buf_a[h_seq_cnt+4];
                        point_r3=in_buf_r[h_seq_cnt+4];
                        point_g3=in_buf_g[h_seq_cnt+4];
                        point_b3=in_buf_b[h_seq_cnt+4];

                        point_a4=cal_buf_a[2];
                        point_r4=cal_buf_r[2];
                        point_g4=cal_buf_g[2];
                        point_b4=cal_buf_b[2];

                        point_a5=in_buf_a[h_seq_cnt+8];
                        point_r5=in_buf_r[h_seq_cnt+8];
                        point_g5=in_buf_g[h_seq_cnt+8];
                        point_b5=in_buf_b[h_seq_cnt+8];

#ifdef __DEBUG_cal
fprintf(out_file4," 1 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
        h_seq_cnt,in_buf_r[h_seq_cnt],h_seq_cnt,in_buf_g[h_seq_cnt],h_seq_cnt,in_buf_b[h_seq_cnt]);
fprintf(out_file4," 2 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
     h_seq_cnt+4,in_buf_r[h_seq_cnt+4],h_seq_cnt+4,in_buf_g[h_seq_cnt+4],h_seq_cnt+4,in_buf_b[h_seq_cnt+4]);
fprintf(out_file4," 3 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
     h_seq_cnt+8,in_buf_r[h_seq_cnt+8],h_seq_cnt+8,in_buf_g[h_seq_cnt+8],h_seq_cnt+8,in_buf_b[h_seq_cnt+8]);
fprintf(out_file4,"\n");
#endif
                        if(div_num_cnt==h_comp_val) //go DU_VUP
                        {
                            if(no_vresize)
                            {
                                w_buf_en=1;
                                h_new_pix_num=h_new_pix_num_dly;
                                h_new_pix_num_dly=h_new_pix_num_dly+1;
                            }
                            else
                                go_du_vup=1;
                            width_cnt=width_cnt+1;
                            down_cmd=0x01;// cal_buf/div
                            div_num_cnt=0;
                            h_rate_base=h_rate_cnt;
                            h_rate_cnt=h_rate_cnt+h_rate;
                            if((h_rate>>16)<2)
                            {
                                //overlap
                                if( ((h_rate_cnt>>16)-(h_rate_base>>16))==1 || 
                                    (width_cnt==new_width-1) )
                                    h_seq_cnt=h_seq_cnt;
                                else 
                                {
                                    h_seq_cnt=h_seq_cnt+1;
                                    fprintf(out_file4,"test_cnt %d\n",test_cnt++);
                                }
                            }
                            else h_seq_cnt=h_seq_cnt+1;

                            fprintf(out_file4,"width_cnt %d\n",width_cnt);
                        }
                        else// continue HDOWN
                        {
                            h_seq_cnt=h_seq_cnt+1;
                            div_num_cnt=div_num_cnt+1;
                        }
                    }//div_num_cnt==0) else
                }
            }            
        }// end DU_HDOWN
        else if(cal_cs==DU_VUP) ////// DOWN_UP_VUP //////
        {
            cnt++;//test
            fprintf(out_file4,"********  cnt %d *********\n",cnt);
            hdown_enable=0;
            src_enable=0;
            up_enable=0;
            w_buf_en=0;
            cal_buf_write=0;
            go_du_vup=0;
            before_state=DU_VUP;
            refresh=0;
            go_idle=0;
            if((height_cnt==new_height-1)&&(h_new_pix_num==new_width-1))
            {
                printf("go idle \n");
                go_idle=1;
            }
            if(no_hresize)//vertical=up,horizontal=1
            {
                if(h_seq_cnt==4)//last in_buf
                {
                    //refresh=1;
                    if(r_mem_cs==IDLE1 || r_mem_ns==IDLE1) go_wait=0;
                    else go_wait=1;
                                                
                    h_seq_cnt=0;
                    if(height_cnt!=new_height-1)//
                    {
                        if(v_new_pix_num!=0) v_rate_cnt=v_rate_cnt+v_rate;
                        v_rate_base=v_rate_cnt;
fprintf(out_file4,"v_comp_val %d :: v_rate_cnt %d\n",v_comp_val,v_rate_cnt);
                        if((v_rate_cnt>>16)!=v_comp_val | v_new_pix_num==0)
                        {
                            refresh=1;
                            rd_en=1;
                        }
                        height_cnt++;//test용
                        v_comp_val=v_rate_cnt>>16;
                        h_addr0=h_addr0-4;
                        h_new_pix_num=h_new_pix_base;
                        v_new_pix_num=v_new_pix_num+new_width;
                    }
                    else//last_height
                    {
                        height_cnt=0;
                        refresh=1;
                        fprintf(out_file4,"LAST HEIGHT\n\n");
                        h_new_pix_base=h_new_pix_num+1;
                        h_new_pix_num=h_new_pix_num+1;
                        v_new_pix_base=0;
                        v_new_pix_num=0;
                        v_rate_cnt=v_rate;
                        v_comp_val=0;
                        v_rate_base=v_rate;
                        /// read memory
                        fill_buf=1;
                        rd_cmd=0x01;//2-line_read 
                        rd_num=4;
                        go_wait=1;
                        rd_v_pix_num=0;
                        rd_h_pix_num=rd_h_pix_num+4;
                    }
                }
                else
                {
                    if(v_new_pix_num!=0)
                    {
                        if(h_seq_cnt==0 & (height_cnt!=new_height-1) & rd_en)//read memory fsm enable
                        {
                        fprintf(out_file4,"READ MEMORY FIRST\n\n");
                            rd_en=0;
                            fill_buf=1;
                            rd_cmd=0x20;//1-line_read continue
                            rd_num=4;
                            if(v_rate_cnt==v_rate) rd_v_pix_num=src_width*2;
                            else rd_v_pix_num=rd_v_pix_num+src_width;
                        }
                        if(h_seq_cnt!=0)
                            h_new_pix_num=h_new_pix_num+1;
                        mul=v_rate_cnt;
                        point_a0=in_buf_a[h_addr0];
                        point_r0=in_buf_r[h_addr0];
                        point_g0=in_buf_g[h_addr0];
                        point_b0=in_buf_b[h_addr0];
                        if(h_addr0>7)
                        {
                            point_a1=in_buf_a[h_addr0-8];
                            point_r1=in_buf_r[h_addr0-8];
                            point_g1=in_buf_g[h_addr0-8];
                            point_b1=in_buf_b[h_addr0-8];
                        }
                        else 
                        {
                            point_a1=in_buf_a[h_addr0+4];
                            point_r1=in_buf_r[h_addr0+4];
                            point_g1=in_buf_g[h_addr0+4];
                            point_b1=in_buf_b[h_addr0+4];
                        }
                        up_enable=1;
                    }
                    else// 첫번째 라인
                    {
                        if(h_seq_cnt!=0) h_new_pix_num=h_new_pix_num+1;
                        src_enable=1;
                    }
                    w_buf_en=1;
                    h_seq_cnt=h_seq_cnt+1;
                    fprintf(out_file4,"h_addr0 is %d\n\n\n",h_addr0);                           
                    h_addr0=h_addr0+1;
                }
            }
            else//vertical=up,horizontal=down
            {
fprintf(out_file4,"----------DOWN UP----------\n");  
        
                if(v_seq_cnt==2) // refill cal_buf
                {
                    go_du_hdown=1;
                    v_seq_cnt=0;
//                    v_new_pix_num=v_new_pix_base;
                    if(new_width==width_cnt)
                    {
                        v_rate_base=v_rate_cnt; 
                        v_comp_val=v_rate_cnt>>16;
                        v_new_pix_base=v_new_pix_num_dly;
                        h_new_pix_num=0;
                        if(v_rate_cnt>>16>=src_height)//last_height
                        {
                            go_idle=1;
                        }
                    }
                    else{
                        if(v_rate_base==v_rate) 
                            first_row=1;
                        v_rate_cnt=v_rate_base;
                        v_comp_val=v_rate_base>>16;
//                        v_new_pix_num=v_new_pix_base;
                        v_new_pix_num=0;                        
                        v_new_pix_num_dly=v_new_pix_base;
                        h_new_pix_num=h_new_pix_num+1;
                    }

                }
                else // continue pixel generate
                {
                    if(first_row)
                    {
                        src_enable=1;
                        w_buf_en=1;
                        first_row=0;
                        v_new_pix_num_dly=v_new_pix_num_dly+new_width;
fprintf(out_file4,"first row is %d \n",mem_cnt++);
                    }
                    else
                    {
fprintf(out_file4,"v_rate_cnt %f :: v_comp_val %d\n",(float)v_rate_cnt/65536,v_comp_val);
                        if(v_rate_cnt>>16==v_comp_val)
                        {
fprintf(out_file4,"HHHHHHHHHHHHHHHHHHHHHHH\n");
                            mul=v_rate_cnt;
                            point_a0=cal_buf_a[v_seq_cnt];
                            point_a1=cal_buf_a[v_seq_cnt+1];
                            point_r0=cal_buf_r[v_seq_cnt];
                            point_r1=cal_buf_r[v_seq_cnt+1];
                            point_g0=cal_buf_g[v_seq_cnt];
                            point_g1=cal_buf_g[v_seq_cnt+1];
                            point_b0=cal_buf_b[v_seq_cnt];
                            point_b1=cal_buf_b[v_seq_cnt+1];
//                            v_new_pix_num=v_new_pix_num+new_width;
                            v_new_pix_num=v_new_pix_num_dly;
                            v_new_pix_num_dly=v_new_pix_num_dly+new_width;
                            up_enable=1;
                            w_buf_en=1;
                            v_rate_cnt=v_rate_cnt+v_rate;
                        }
                        else 
                        {
fprintf(out_file4,"++++++++++++FUCK++++++++++++++\n");
                            v_seq_cnt=v_seq_cnt+1;
                            v_comp_val=v_rate_cnt>>16;
                        }
                    }
                }
            }
        }// end DU_VUP
        else if(cal_cs==VDOWN) ////// VDOWN //////
        {
            before_state=VDOWN;
            fill_buf=0;
            down_cmd=0;
            go_wait=0;
            vdown_enable=0;
            last_row=0;
            last_column=0;
            go_ud_hup=0;
            w_buf_en=0;
            src_enable=0;
#ifdef __DEBUG_vdn
            fprintf(out_file4,"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
            fprintf(out_file4,"full_buf is %d :: h_addr0 is %d \n",full_buf,h_addr0);
            fprintf(out_file4,"vdown_ready is : %d\n",vdown_ready);
            fprintf(out_file4,"v_comp_val is  : %d\n",v_comp_val);
            fprintf(out_file4,"v_rate is      : %d : %f\n",v_rate,(float)v_rate/65536);
            fprintf(out_file4,"v_rate_cnt is  : %d : %f\n",v_rate_cnt,(float)v_rate_cnt/65536);
            fprintf(out_file4,"v_rate_base is : %d : %f\n",v_rate_base,(float)v_rate_base/65536);
            fprintf(out_file4,"div : %d  ::: div_num_cnt :%d\n",div,div_num_cnt);
            fprintf(out_file4,"--------------------------------------\n");
#endif
            if(vdown_ready && (v_rate>>16)<=32)
            {
                if(v_seq_cnt==3 || height_cnt==new_height)//seq_comp_val)// buffer refill
                {
                    fprintf(out_file4,"REFILL BUFFER\n\n");
                    go_wait=1;
                    v_seq_cnt=0;
                    vdown_enable=0;
                    fill_buf=1;
                    rd_num=4;
                    go_idle=0;
                    if(height_cnt==new_height)
                    {
                        v_rate_base=0;
                        v_rate_cnt=v_rate;
                        height_cnt=0;
                        rd_v_pix_num=0;
                        if(no_hresize) 
                        {
                            if(remain_width<=4 && h_new_pix_num!=0)//last pixel 
                            {
                                go_idle=1;
                            }
                            rd_h_pix_num=rd_h_pix_num+4;//horizontal==1
                            h_new_pix_num=h_new_pix_num+4;
                        }
                        else
                        {
                            rd_h_pix_num=rd_h_pix_num+3;
                        }
                        remain_width=new_width-h_new_pix_num;
                    }
                    else
                    {
                        rd_v_pix_num=rd_v_pix_num+src_width*3;
                    }
                }
                else
                {
#ifdef __DEBUG_vdn
                    fprintf(out_file4,"VERTICAL DOWN CACULATION\n\n");
#endif
                    go_wait=0;
                    if(v_seq_cnt==0) h_addr0=0;
                    else if(v_seq_cnt==1) h_addr0=4;
                    else if(v_seq_cnt==2) h_addr0=8;
                    if(div_num_cnt==0)
                    {
#ifdef __DEBUG_cal
    fprintf(out_file4,"//////// HDOWN CAL BUF INIT////////\n");
    fprintf(out_file4," 0 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
    fprintf(out_file4," 1 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+1,in_buf_r[h_addr0+1],h_addr0+1,in_buf_g[h_addr0+1],h_addr0+1,in_buf_b[h_addr0+1]);
    fprintf(out_file4," 2 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+2,in_buf_r[h_addr0+2],h_addr0+2,in_buf_g[h_addr0+2],h_addr0+2,in_buf_b[h_addr0+2]);
    fprintf(out_file4," 3 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+3,in_buf_r[h_addr0+3],h_addr0+3,in_buf_g[h_addr0+3],h_addr0+3,in_buf_b[h_addr0+3]);
#endif
                        vdown_enable=0;
                        cal_buf_a[0]=in_buf_a[h_addr0];
                        cal_buf_a[1]=in_buf_a[h_addr0+1];
                        cal_buf_a[2]=in_buf_a[h_addr0+2];
                        cal_buf_a[3]=in_buf_a[h_addr0+3];

                        cal_buf_r[0]=in_buf_r[h_addr0];
                        cal_buf_r[1]=in_buf_r[h_addr0+1];
                        cal_buf_r[2]=in_buf_r[h_addr0+2];
                        cal_buf_r[3]=in_buf_r[h_addr0+3];

                        cal_buf_g[0]=in_buf_g[h_addr0];
                        cal_buf_g[1]=in_buf_g[h_addr0+1];
                        cal_buf_g[2]=in_buf_g[h_addr0+2];
                        cal_buf_g[3]=in_buf_g[h_addr0+3];

                        cal_buf_b[0]=in_buf_b[h_addr0];
                        cal_buf_b[1]=in_buf_b[h_addr0+1];
                        cal_buf_b[2]=in_buf_b[h_addr0+2];
                        cal_buf_b[3]=in_buf_b[h_addr0+3];

                        if((v_rate>>16)<2)
                        {
                            v_comp_val=1;
                            div=2;
                        }
                        else
                        {
                            if((new_height-1)==height_cnt)
                                div=src_height-(v_rate_base>>16);
                            else div=((v_rate_cnt)>>16)-(v_rate_base>>16);
                            
                            v_comp_val=div-1;
                        }
                        div_num_cnt=div_num_cnt+1;
                        v_seq_cnt=v_seq_cnt+1;

                    }
                    else  
                    {
                        vdown_enable=1;
                        point_a0=cal_buf_a[0];                       
                        point_a1=cal_buf_a[1];                       
                        point_a2=cal_buf_a[2];                       
                        point_a3=cal_buf_a[3];                       

                        point_a4=in_buf_a[h_addr0];                       
                        point_a5=in_buf_a[h_addr0+1];                       
                        point_a6=in_buf_a[h_addr0+2];                       
                        point_a7=in_buf_a[h_addr0+3];                       

                        point_r0=cal_buf_r[0];                       
                        point_r1=cal_buf_r[1];                       
                        point_r2=cal_buf_r[2];                       
                        point_r3=cal_buf_r[3];                       

                        point_r4=in_buf_r[h_addr0];                       
                        point_r5=in_buf_r[h_addr0+1];                       
                        point_r6=in_buf_r[h_addr0+2];                       
                        point_r7=in_buf_r[h_addr0+3];                       

                        point_g0=cal_buf_g[0];                       
                        point_g1=cal_buf_g[1];                       
                        point_g2=cal_buf_g[2];                       
                        point_g3=cal_buf_g[3];                       

                        point_g4=in_buf_g[h_addr0];                       
                        point_g5=in_buf_g[h_addr0+1];                       
                        point_g6=in_buf_g[h_addr0+2];                       
                        point_g7=in_buf_g[h_addr0+3];                       

                        point_b0=cal_buf_b[0];                       
                        point_b1=cal_buf_b[1];                       
                        point_b2=cal_buf_b[2];                       
                        point_b3=cal_buf_b[3];                       

                        point_b4=in_buf_b[h_addr0]; 
                        point_b5=in_buf_b[h_addr0+1];                       
                        point_b6=in_buf_b[h_addr0+2];                       
                        point_b7=in_buf_b[h_addr0+3]; 
#ifdef __DEBUG_cal
    fprintf(out_file4,"//////// HDOWN POINT CALCULATION////////\n");
    fprintf(out_file4," 0 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
            h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
    fprintf(out_file4," 1 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+1,in_buf_r[h_addr0+1],h_addr0+1,in_buf_g[h_addr0+1],h_addr0+1,in_buf_b[h_addr0+1]);
    fprintf(out_file4," 2 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+2,in_buf_r[h_addr0+2],h_addr0+2,in_buf_g[h_addr0+2],h_addr0+2,in_buf_b[h_addr0+2]);
    fprintf(out_file4," 3 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+3,in_buf_r[h_addr0+3],h_addr0+3,in_buf_g[h_addr0+3],h_addr0+3,in_buf_b[h_addr0+3]);
    fprintf(out_file4,"\n");
#endif
                        if(div_num_cnt==v_comp_val)
                        {
                            height_cnt=height_cnt+1;
                            down_cmd=0x01;// cal_buf/div
                            div_num_cnt=0;
                            v_rate_base=v_rate_cnt;
                            v_rate_cnt=v_rate_cnt+v_rate;
                            if(no_hresize)
                            {
                                w_buf_en=1;
                                v_new_pix_num=v_new_pix_num_dly;
                                if(height_cnt==new_height)
                                {
//                                    v_new_pix_num=0;
                                    v_new_pix_num_dly=0;
                                }
                                else
                                    v_new_pix_num_dly=v_new_pix_num_dly+new_width;
                            }
                            else
                            {
                                if(ud) go_ud_hup=1;
                            }
                        }
                        else
                        {
                            div_num_cnt=div_num_cnt+1;
                        }
                        if((v_rate_cnt>>16)-(v_rate_base>>16)==1) v_seq_cnt=v_seq_cnt;//overlap
                        else v_seq_cnt=v_seq_cnt+1;
                    }//div_num_cnt==0) else
                }
            }//if(vdown_ready && (v_rate>>16)<=32) 

        }// end DD_VDOWN
        else if(cal_cs==UD_HUP) ////// UP_DOWN_HUP //////
        {
            ///test용 vdown다하고 지워라//
//            go_vdown=1;
            /////////////
            vdown_enable=0;
            go_vdown=0;
            up_enable=0;
            w_buf_en=0;
            go_ud_hup=0;
            src_enable=0;
            go_idle=0;
            if(height_cnt1==new_height && h_new_pix_num==new_width-1 &&
                    no_vresize==0 )
            {
                go_idle=1;
            }
            else if(height_cnt1==new_height && h_new_pix_num==new_width-1 &&
                    no_vresize==1 )
            {
                go_idle=1;
            }
            else
            {
                if((h_rate_cnt>>16)==h_comp_val)
                {
                    if(no_vresize)//vertical=1,horizontal=up
                    {
                        w_buf_en=1;
fprintf(out_file4,"** h_new_pix_num_dly %d **\n",h_new_pix_num_dly);                        
                        if(h_new_pix_num_dly==0)// first column wirte
                        {
                            src_enable=1;
                        }
                        else
                        {
fprintf(out_file4,"** FUCK YOU **\n");                        
                            if(h_rate_cnt==h_rate_base && height_cnt1!=new_height-1) 
                            {
                                rd_cmd=0x20; // 1-line read continue
                                rd_num=4;
                                fill_buf=1;
                                if(v_new_pix_num==0) rd_v_pix_num=rd_v_pix_num+src_width*2;
                                else rd_v_pix_num=rd_v_pix_num+src_width;
                            }
                            up_enable=1;
                            mul=h_rate_cnt;
                            point_a0=in_buf_a[h_addr0];
                            point_a1=in_buf_a[h_addr0+1];
                            point_r0=in_buf_r[h_addr0];
                            point_r1=in_buf_r[h_addr0+1];
                            point_g0=in_buf_g[h_addr0];
                            point_g1=in_buf_g[h_addr0+1];
                            point_b0=in_buf_b[h_addr0];
                            point_b1=in_buf_b[h_addr0+1];
                            h_rate_cnt=h_rate_cnt+h_rate;
                        }
                        h_new_pix_num=h_new_pix_num_dly;
                        h_new_pix_num_dly=h_new_pix_num_dly+1;

                    }
                    else//  ****** vertical=down,horizontal=up ******
                    {
                        w_buf_en=1;
                        if(h_new_pix_num_dly==0)// first column wirte
                        {
                            src_enable=1;
                        }
                        else
                        {
                            up_enable=1;
                            mul=h_rate_cnt;
                            point_a0=cal_buf_a[h_seq_cnt];
                            point_a1=cal_buf_a[h_seq_cnt+1];
                            point_r0=cal_buf_r[h_seq_cnt];
                            point_r1=cal_buf_r[h_seq_cnt+1];
                            point_g0=cal_buf_g[h_seq_cnt];
                            point_g1=cal_buf_g[h_seq_cnt+1];
                            point_b0=cal_buf_b[h_seq_cnt];
                            point_b1=cal_buf_b[h_seq_cnt+1];
                            h_rate_cnt=h_rate_cnt+h_rate;
                        }
                        h_new_pix_num=h_new_pix_num_dly;
                        h_new_pix_num_dly=h_new_pix_num_dly+1;
                    }
                }
                else//if((h_rate_cnt>>16)!=h_comp_val) 
                {
                    if(no_vresize)
                    {
                        if(h_new_pix_num==new_width-1)
                        {
                            refresh=1;
                            h_seq_cnt=0;
                            h_rate_cnt=h_rate_base;
                            h_comp_val=h_rate_base>>16;
                            h_new_pix_num_dly=h_new_pix_base;
                            height_cnt1=height_cnt1+1;
                            v_new_pix_num=v_new_pix_num+new_width;
                            if(r_mem_cs==IDLE1 || r_mem_ns==IDLE1 || (height_cnt1==new_height-1))
                                go_wait=0;
                            else go_wait=1;
                        } 
                        else
                        {
                            if(h_seq_cnt==2)
                            {
                                refresh=1;
                                if(r_mem_cs==IDLE1 || r_mem_ns==IDLE1) go_wait=0;
                                else go_wait=1;

                                if(no_vresize) go_vdown=0;
                                else go_vdown=1;
                                h_seq_cnt=0;
                                if(height_cnt1==new_height-1)//last height
                                {
                                    height_cnt1=0;
                                    h_rate_base=h_rate_cnt;
                                    h_new_pix_base=h_new_pix_num_dly;
                                    v_new_pix_num=0;
                                    fill_buf=1;
                                    rd_cmd=0x01;//2-line read 
                                    rd_num=4;
                                    go_wait=1;
                                    rd_v_pix_num=0;
                                    rd_h_pix_num=rd_h_pix_num+3;
                                    h_comp_val=h_rate_cnt>>16;
                                }
                                else
                                {
                                    h_rate_cnt=h_rate_base;
                                    h_comp_val=h_rate_base>>16;
                                    h_new_pix_num_dly=h_new_pix_base;
                                    height_cnt1=height_cnt1+1;
                                    v_new_pix_num=v_new_pix_num+new_width;
                                }
                            }
                            else
                            {
                                refresh=0;
                                h_addr0=h_addr0+1;
                                h_seq_cnt=h_seq_cnt+1;
                                h_comp_val=h_rate_cnt>>16;
                            }
                        }
                    }
                    else //vertical=down,horizontal=up
                    {
                        if(h_new_pix_num==new_width-1)
                        {
                            h_seq_cnt=0;
                            h_rate_cnt=h_rate_base;
                            h_comp_val=h_rate_base>>16;
                            h_new_pix_num_dly=h_new_pix_base;
                            height_cnt1=height_cnt1+1;
                            v_new_pix_num=v_new_pix_num+new_width;
                            go_vdown=1;
                        }
                        else
                        {
                            if(h_seq_cnt==2)
                            {
                                h_seq_cnt=0;
                                go_vdown=1;
                                if(height_cnt1==new_height-1)//last height
                                {
                                    height_cnt1=0;
                                    h_rate_base=h_rate_cnt;
                                    h_new_pix_base=h_new_pix_num_dly;
                                    v_new_pix_num=0;
                                    h_comp_val=h_rate_cnt>>16;
                                }
                                else
                                {
                                    h_rate_cnt=h_rate_base;
                                    h_comp_val=h_rate_base>>16;
                                    h_new_pix_num_dly=h_new_pix_base;
                                    height_cnt1=height_cnt1+1;
                                    v_new_pix_num=v_new_pix_num+new_width;
                                }
                            }
                            else
                            {
                                h_seq_cnt=h_seq_cnt+1;
                                h_comp_val=h_rate_cnt>>16;
                            }
                        }
                    }
                }//if((h_rate_cnt>>16)==h_comp_val)
            }
        }// end UD_HUP
        else if(cal_cs==DD_VDOWN)
        {
            before_state=DD_VDOWN;
            fill_buf=0;
            down_cmd=0;
            go_wait=0;
            vdown_enable=0;
            hdown_enable=0;
            last_row=0;
            last_column=0;
            w_buf_en=0;
            go_dd_hdown=0;
#ifdef __DEBUG_vdn
            fprintf(out_file4,"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
            fprintf(out_file4,"full_buf is %d :: h_addr0 is %d \n",full_buf,h_addr0);
            fprintf(out_file4,"vdown_ready is : %d\n",vdown_ready);
            fprintf(out_file4,"v_comp_val is  : %d\n",v_comp_val);
            fprintf(out_file4,"v_rate is      : %d : %f\n",v_rate,(float)v_rate/65536);
            fprintf(out_file4,"v_rate_cnt is  : %d : %f\n",v_rate_cnt,(float)v_rate_cnt/65536);
            fprintf(out_file4,"v_rate_base is : %d : %f\n",v_rate_base,(float)v_rate_base/65536);
            fprintf(out_file4,"div : %d  ::: div_num_cnt :%d\n",div,div_num_cnt);
            fprintf(out_file4,"--------------------------------------\n");
#endif
            if(vdown_ready && (v_rate>>16)<=32)
            {
                if(v_seq_cnt==3 || height_cnt==new_height)//seq_comp_val)// buffer refill
                {
                    go_wait=1;
                    v_seq_cnt=0;
                    vdown_enable=0;
                    fill_buf=1;
                    rd_num=4;
                    rd_remain_dly=rd_remain;
                    if(rd_remain>=3 | rd_remain<=0) rd_cmd=0x02;//3-line read
                    else if(div==1) rd_cmd=0x00;//1-line read 
                    else if(div==2) rd_cmd=0x01;//2-line read 
                    else if(div==3) rd_cmd=0x02;//3-line read 
                    else if(rd_remain==1) rd_cmd=0x20;//1-line read continue
                    else if(rd_remain==2) rd_cmd=0x21;//2-line read continue
                    rd_remain=rd_remain-3;
                    if(rd_remain>0)// rd_remain>3
                    {
                        rd_v_pix_num=rd_v_pix_num+src_width*3;
                    }
                    else
                    {
                        if(remain_width<=4)/////// last column ?
                        {
                            rd_cmd=0x02;//3-line_read
                            v_rate_base=v_rate_cnt;
                            v_rate_cnt=v_rate_cnt+v_rate;
                            rd_h_pix_num=0;
                            if((v_rate>>16)<2)
                            {
                                fprintf(out_file4,"OVERLAP\n");
                                //overlap
                                if( ((v_rate_cnt>>16)-(v_rate_base>>16))==1 )  
                                {
                                    rd_v_pix_num=rd_v_pix_num+src_width;
                                }
                                else
                                    rd_v_pix_num=rd_v_pix_num+src_width*2;
                                rd_v_pix_num_base=rd_v_pix_num;
                            }
                            else
                            {
                                if(rd_remain_dly==1) rd_v_pix_num=rd_v_pix_num+src_width;
                                else if(rd_remain_dly==2) rd_v_pix_num=rd_v_pix_num+src_width*2;
                                else if(rd_remain_dly==3) rd_v_pix_num=rd_v_pix_num+src_width*3;
                                rd_v_pix_num_base=rd_v_pix_num;
                            }
                        }
                        else
                        {
                            rd_v_pix_num=rd_v_pix_num_base;
                            rd_h_pix_num=rd_h_pix_num+4;
                        }
                    }
                    remain_width=src_width-rd_h_pix_num;
                    fprintf(out_file4,"rd_remain %d :: rd_remain_dly %d \n",rd_remain,rd_remain_dly);
                    fprintf(out_file4,"REFILL BUFFER\n\n");
                }
                else
                {
#ifdef __DEBUG_vdn
                    fprintf(out_file4,"VERTICAL DOWN CACULATION\n\n");
#endif
                    if(v_seq_cnt==0) h_addr0=0;
                    else if(v_seq_cnt==1) h_addr0=4;
                    else if(v_seq_cnt==2) h_addr0=8;
                    if(div_num_cnt==0)
                    {
#ifdef __DEBUG_cal
    fprintf(out_file4,"//////// VDOWN CAL BUF INIT////////\n");
    fprintf(out_file4," 0 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
    fprintf(out_file4," 1 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+1,in_buf_r[h_addr0+1],h_addr0+1,in_buf_g[h_addr0+1],h_addr0+1,in_buf_b[h_addr0+1]);
    fprintf(out_file4," 2 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+2,in_buf_r[h_addr0+2],h_addr0+2,in_buf_g[h_addr0+2],h_addr0+2,in_buf_b[h_addr0+2]);
    fprintf(out_file4," 3 : in_buf_r[%d]:%02x,in_buf_g[%d]:%02x,in_buf_b[%d]:%02x\n",
            h_addr0+3,in_buf_r[h_addr0+3],h_addr0+3,in_buf_g[h_addr0+3],h_addr0+3,in_buf_b[h_addr0+3]);
#endif
                        vdown_enable=0;
                        cal_buf_a[0]=in_buf_a[h_addr0];
                        cal_buf_a[1]=in_buf_a[h_addr0+1];
                        cal_buf_a[2]=in_buf_a[h_addr0+2];
                        cal_buf_a[3]=in_buf_a[h_addr0+3];

                        cal_buf_r[0]=in_buf_r[h_addr0];
                        cal_buf_r[1]=in_buf_r[h_addr0+1];
                        cal_buf_r[2]=in_buf_r[h_addr0+2];
                        cal_buf_r[3]=in_buf_r[h_addr0+3];

                        cal_buf_g[0]=in_buf_g[h_addr0];
                        cal_buf_g[1]=in_buf_g[h_addr0+1];
                        cal_buf_g[2]=in_buf_g[h_addr0+2];
                        cal_buf_g[3]=in_buf_g[h_addr0+3];

                        cal_buf_b[0]=in_buf_b[h_addr0];
                        cal_buf_b[1]=in_buf_b[h_addr0+1];
                        cal_buf_b[2]=in_buf_b[h_addr0+2];
                        cal_buf_b[3]=in_buf_b[h_addr0+3];

                        if((v_rate>>16)<2)
                        {
                            v_comp_val=1;
                            div=2;
                        }
                        else
                        {
                            if((new_height-1)==height_cnt)
                                div=src_height-(v_rate_base>>16);
                            else div=((v_rate_cnt)>>16)-(v_rate_base>>16);
                            v_comp_val=div-1;
                        }

                        rd_remain=div;
                        div_num_cnt=div_num_cnt+1;
                        v_seq_cnt=v_seq_cnt+1;
                    }
                    else  
                    {
                        vdown_enable=1;
                        point_a0=cal_buf_a[0];                       
                        point_a1=cal_buf_a[1];                       
                        point_a2=cal_buf_a[2];                       
                        point_a3=cal_buf_a[3];                       

                        point_a4=in_buf_a[h_addr0];                       
                        point_a5=in_buf_a[h_addr0+1];                       
                        point_a6=in_buf_a[h_addr0+2];                       
                        point_a7=in_buf_a[h_addr0+3];                       

                        point_r0=cal_buf_r[0];                       
                        point_r1=cal_buf_r[1];                       
                        point_r2=cal_buf_r[2];                       
                        point_r3=cal_buf_r[3];                       

                        point_r4=in_buf_r[h_addr0];                       
                        point_r5=in_buf_r[h_addr0+1];                       
                        point_r6=in_buf_r[h_addr0+2];                       
                        point_r7=in_buf_r[h_addr0+3];                       

                        point_g0=cal_buf_g[0];                       
                        point_g1=cal_buf_g[1];                       
                        point_g2=cal_buf_g[2];                       
                        point_g3=cal_buf_g[3];                       

                        point_g4=in_buf_g[h_addr0];                       
                        point_g5=in_buf_g[h_addr0+1];                       
                        point_g6=in_buf_g[h_addr0+2];                       
                        point_g7=in_buf_g[h_addr0+3];                       

                        point_b0=cal_buf_b[0];                       
                        point_b1=cal_buf_b[1];                       
                        point_b2=cal_buf_b[2];                       
                        point_b3=cal_buf_b[3];                       

                        point_b4=in_buf_b[h_addr0]; 
                        point_b5=in_buf_b[h_addr0+1];                       
                        point_b6=in_buf_b[h_addr0+2];                       
                        point_b7=in_buf_b[h_addr0+3]; 
#ifdef __DEBUG_cal
    fprintf(out_file4,"//////// VDOWN POINT CALCULATION////////\n");
    fprintf(out_file4," 0 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
            h_addr0,in_buf_r[h_addr0],h_addr0,in_buf_g[h_addr0],h_addr0,in_buf_b[h_addr0]);
    fprintf(out_file4," 1 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+1,in_buf_r[h_addr0+1],h_addr0+1,in_buf_g[h_addr0+1],h_addr0+1,in_buf_b[h_addr0+1]);
    fprintf(out_file4," 2 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+2,in_buf_r[h_addr0+2],h_addr0+2,in_buf_g[h_addr0+2],h_addr0+2,in_buf_b[h_addr0+2]);
    fprintf(out_file4," 3 : point_r[%d]:%02x,point_g[%d]:%02x,point_b[%d]:%02x\n",
         h_addr0+3,in_buf_r[h_addr0+3],h_addr0+3,in_buf_g[h_addr0+3],h_addr0+3,in_buf_b[h_addr0+3]);
    fprintf(out_file4,"\n");
#endif
                        if(div_num_cnt==v_comp_val)
                        {
                            down_cmd=0x01;// cal_buf/div
                            div_num_cnt=0;
                            go_dd_hdown=1;
                            v_seq_cnt=3;
                            
                        }
                        else
                        {
                            div_num_cnt=div_num_cnt+1;
                            v_seq_cnt=v_seq_cnt+1;
                        }
                    }//div_num_cnt==0) else
                }
            }//if(vdown_ready && (v_rate>>16)<=32) 
        }
        else if(cal_cs==DD_HDOWN) ////// DN_DN_HDOWN //////
        {
            //// test ////
//            go_dd_vdown=1;
            //////////////            
            go_dd_hdown=0;
            go_idle=0;
            down_cmd=0;
            hdown_enable=0;
            vdown_enable=0;
            w_buf_en=0;
            go_dd_vdown=0;
            if(hdown_ready)
            {
                if(h_seq_cnt==4 || width_cnt1==new_width) // cal_buffer empty
                {
                    h_seq_cnt=0;
                    hdown_enable=0;
                    go_dd_vdown=1;
                    if(width_cnt1==new_width)
                    {
                        if(height_cnt1==new_height) go_idle=1;
                        else go_idle=0;
                        h_rate_base=0;
                        h_rate_cnt=h_rate;
                        width_cnt1=0;
                        height_cnt1=height_cnt1+1;
                        h_new_pix_num_dly=0;
                        v_new_pix_num=v_new_pix_num+new_width;
                    }
                }
                else
                {
                    if(hdiv_num_cnt==0)
                    {
                        //point calculation
                        cal_buf_a[4]=cal_buf_a[h_seq_cnt];
                        cal_buf_r[4]=cal_buf_r[h_seq_cnt];
                        cal_buf_g[4]=cal_buf_g[h_seq_cnt];
                        cal_buf_b[4]=cal_buf_b[h_seq_cnt];
#ifdef __DEBUG_cal
fprintf(out_file4,"//////// HDOWN CAL BUF INIT////////\n");
fprintf(out_file4," 1 : cal_buf_r4:%02x,cal_buf_g4:%02x,cal_buf_b4:%02x\n",
        cal_buf_r[h_seq_cnt],cal_buf_g[h_seq_cnt],cal_buf_b[h_seq_cnt]);
#endif

                        if((h_rate>>16)<2)
                        {
                            h_comp_val=1;
                            h_div=2;
                        }else
                        { 
                            if((new_width-1)==width_cnt1)//last
                                h_div=src_width-(h_rate_base>>16);
                            else h_div=((h_rate_cnt)>>16)-(h_rate_base>>16);
                            h_comp_val=h_div-1;
                        }
                        hdiv_num_cnt=hdiv_num_cnt+1;
                        h_seq_cnt=h_seq_cnt+1;
                    }
                    else  
                    {
                        //horizontal=down,vertical=down
                            //point calculation
/*                        if(point_init)
                        {
                            point_a0=cal_buf_a[h_seq_cnt-1];
                            point_r0=cal_buf_r[h_seq_cnt-1];
                            point_g0=cal_buf_g[h_seq_cnt-1];
                            point_b0=cal_buf_b[h_seq_cnt-1];
                        }
                        else
                        {
                            point_a0=cal_buf_a[4];
                            point_r0=cal_buf_r[4];
                            point_g0=cal_buf_g[4];
                            point_b0=cal_buf_b[4];
                        }
*/
                        hdown_enable=1;
                        point_a0=cal_buf_a[4];
                        point_r0=cal_buf_r[4];
                        point_g0=cal_buf_g[4];
                        point_b0=cal_buf_b[4];
                        
                        point_a1=cal_buf_a[h_seq_cnt];
                        point_r1=cal_buf_r[h_seq_cnt];
                        point_g1=cal_buf_g[h_seq_cnt];
                        point_b1=cal_buf_b[h_seq_cnt];
#ifdef __DEBUG_cal
fprintf(out_file4," 0 : point_r0:%02x,point_g0:%02x,point_b0:%02x\n",
        cal_buf_r[4],cal_buf_g[4],cal_buf_b[4]);
fprintf(out_file4," 1 : point_r1:%02x,point_g1:%02x,point_b1:%02x\n",
        cal_buf_r[h_seq_cnt],cal_buf_g[h_seq_cnt],cal_buf_b[h_seq_cnt]);
fprintf(out_file4,"\n");
#endif

                        if(hdiv_num_cnt==h_comp_val)
                        {
                            w_buf_en=1;
                            width_cnt1=width_cnt1+1;
                            down_cmd=0x01;// cal_buf/div
                            hdiv_num_cnt=0;
                            h_rate_base=h_rate_cnt;
                            h_rate_cnt=h_rate_cnt+h_rate;
                            h_new_pix_num=h_new_pix_num_dly;
                            h_new_pix_num_dly=h_new_pix_num_dly+1;
                            if((h_rate>>16)<2)
                            {
                                //overlap
                                if( ((h_rate_cnt>>16)-(h_rate_base>>16))==1 || 
                                    (width_cnt1==new_width-1) )
                                    h_seq_cnt=h_seq_cnt;
                                else 
                                {
                                    h_seq_cnt=h_seq_cnt+1;
                                }
                            }
                            else h_seq_cnt=h_seq_cnt+1;
                        }
                        else 
                        {
                            hdiv_num_cnt=hdiv_num_cnt+1;
                            h_seq_cnt=h_seq_cnt+1;
                        }

                    }//hdiv_num_cnt==0) else
                }//if(h_seq_cnt==seq_comp_val || width_cnt1==new_width)
            }//if(hdown_ready)
        }// end DD_HDOWN
        else if(cal_cs==WAIT)
        {
            go_wait=0;
            r_uu_hup = end_fill & uu;
            r_du_hdown = end_fill & (before_state==DU_HDOWN);
            r_du_vup = end_fill & (before_state==DU_VUP);
            r_ud_hup = end_fill & ud;
            r_dd_vdown = end_fill & dd;
            r_vdown = end_fill & (before_state==VDOWN);
        }// end WAIT
        
        if(up_enable) //****** up scale *******
        {
            up(&result_a,point_a0,point_a1,mul);
            up(&result_r,point_r0,point_r1,mul);
            up(&result_g,point_g0,point_g1,mul);
            up(&result_b,point_b0,point_b1,mul);
            up_ready=1;
            up_data_valid=1;
            if(cal_buf_en)
            {
                if(v_seq_cnt)
                {
                    cal_buf_a[0]=result_a;
                    cal_buf_r[0]=result_r;
                    cal_buf_g[0]=result_g;
                    cal_buf_b[0]=result_b;
                }
                else
                {
                    cal_buf_a[1]=result_a;
                    cal_buf_r[1]=result_r;
                    cal_buf_g[1]=result_g;
                    cal_buf_b[1]=result_b;
                }
            }
#ifdef __DEBUG_cal
            fprintf(out_file4,"mul : %10f | r0: %02x | r1: %02x | result_r: %02x\n",
                    (float)mul/65536,point_r0,point_r1,result_r);
            fprintf(out_file4,"mul : %10f | g0: %02x | g1: %02x | result_r: %02x\n",
                    (float)mul/65536,point_g0,point_g1,result_g);
            fprintf(out_file4,"mul : %10f | b0: %02x | b1: %02x | result_r: %02x\n",
                    (float)mul/65536,point_b0,point_b1,result_b);
            fprintf(out_file4,"\n");
            if(cal_cs==UU_VUP){
                if(v_seq_cnt)
                    fprintf(out_file4,"cal_buf_r : %02x  cal_buf_g : %02x  cal_buf_g : %02x\n",
                            cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]);
                else
                    fprintf(out_file4,"cal_buf_r : %02x  cal_buf_g : %02x  cal_buf_g : %02x\n",
                            cal_buf_r[1],cal_buf_g[1],cal_buf_b[1]);
            }
#endif
        }//end up scale
        else if(vdown_enable) //***** vdown scale *****
        {
            fprintf(out_file4," ///////// VDOWN START //////////\n");
            vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                point_a0,point_a4,point_r0,point_r4,point_g0,point_g4,point_b0,point_b4);
            cal_buf_a[0]=result_a;
            cal_buf_r[0]=result_r;
            cal_buf_g[0]=result_g;
            cal_buf_b[0]=result_b;

            vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                point_a1,point_a5,point_r1,point_r5,point_g1,point_g5,point_b1,point_b5);
            cal_buf_a[1]=result_a;
            cal_buf_r[1]=result_r;
            cal_buf_g[1]=result_g;
            cal_buf_b[1]=result_b;
            
            vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                point_a2,point_a6,point_r2,point_r6,point_g2,point_g6,point_b2,point_b6);
            cal_buf_a[2]=result_a;
            cal_buf_r[2]=result_r;
            cal_buf_g[2]=result_g;
            cal_buf_b[2]=result_b;

            vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                point_a3,point_a7,point_r3,point_r7,point_g3,point_g7,point_b3,point_b7);
            cal_buf_a[3]=result_a;
            cal_buf_r[3]=result_r;
            cal_buf_g[3]=result_g;
            cal_buf_b[3]=result_b;
        }//end vdown scale
        else if(hdown_enable) //***** hdown scale *****
        {
            if(dd)
            {
                vdown(h_div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                    point_a0,point_a1,point_r0,point_r1,point_g0,point_g1,point_b0,point_b1);
                cal_buf_a[4]=result_a;
                cal_buf_r[4]=result_r;
                cal_buf_g[4]=result_g;
                cal_buf_b[4]=result_b;
            }
            else
            {
                vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                    point_a0,point_a1,point_r0,point_r1,point_g0,point_g1,point_b0,point_b1);
                cal_buf_a[0]=result_a;
                cal_buf_r[0]=result_r;
                cal_buf_g[0]=result_g;
                cal_buf_b[0]=result_b;
                
                vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                    point_a2,point_a3,point_r2,point_r3,point_g2,point_g3,point_b2,point_b3);
                cal_buf_a[1]=result_a;
                cal_buf_r[1]=result_r;
                cal_buf_g[1]=result_g;
                cal_buf_b[1]=result_b;

                vdown(div,down_cmd,&result_a,&result_r,&result_g,&result_b,
                    point_a4,point_a5,point_r4,point_r5,point_g4,point_g5,point_b4,point_b5);
                cal_buf_a[2]=result_a;
                cal_buf_r[2]=result_r;
                cal_buf_g[2]=result_g;
                cal_buf_b[2]=result_b;
            }

#ifdef __DEBUG_cal
fprintf(out_file4,"HDOWN ENABLE\n");
fprintf(out_file4," 1 : cal_buf_r[0]:%04x,cal_buf_g[0]:%04x,cal_buf_b[0]:%04x\n",
        cal_buf_r[0],cal_buf_g[0],cal_buf_b[0]);
fprintf(out_file4," 2 : cal_buf_r[1]:%04x,cal_buf_g[1]:%04x,cal_buf_b[1]:%04x\n",
        cal_buf_r[1],cal_buf_g[1],cal_buf_b[1]);
fprintf(out_file4," 3 : cal_buf_r[2]:%04x,cal_buf_g[2]:%04x,cal_buf_b[2]:%04x\n",
        cal_buf_r[2],cal_buf_g[2],cal_buf_b[2]);
#endif
        }//
 
        read_pix_num=rd_v_pix_num+rd_h_pix_num;

        //next state
        switch(cal_cs)
        {
            case IDLE2://0
                if(start) cal_ns=INIT;
                else cal_ns=IDLE2;
                break;
            case INIT://1
                if(go_uu) cal_ns=UU_HUP;
                else if(go_dd_vdown) cal_ns=DD_VDOWN;
                else if(go_ud_hup) cal_ns=UD_HUP;
                else if(go_vdown){
                    cal_ns=VDOWN;
                    printf("NNNNNNNNNN\n");
                }
                else if(go_du_vup) cal_ns=DU_VUP;
                else if(go_du_hdown) cal_ns=DU_HDOWN;
                else cal_ns=INIT;
                break;
            case UU_HUP://2
                if(go_idle) cal_ns=IDLE2;
                else if(go_wait) cal_ns=WAIT;
                else if(go_uu_vup) cal_ns=UU_VUP;
                else cal_ns=UU_HUP;
                break;
            case UU_VUP://3
                if(go_uu_hup) cal_ns=UU_HUP;
                else cal_ns=UU_VUP;
                break;
            case DU_HDOWN://4
                if(go_idle) cal_ns=IDLE2;
                else if(go_wait) cal_ns=WAIT;
                else if(go_du_vup) cal_ns=DU_VUP;
                else cal_ns=DU_HDOWN;
                break;
            case DU_VUP://5
                if(go_idle) cal_ns=IDLE2;
                else if(go_du_hdown) cal_ns=DU_HDOWN;
                else if(go_wait) cal_ns=WAIT;
                else cal_ns=DU_VUP;
                break;
            case VDOWN://6
                if(go_idle) cal_ns=IDLE2;
                else if(go_ud_hup) cal_ns=UD_HUP;
                else if(go_wait) cal_ns=WAIT;
                else cal_ns=VDOWN;
                break;
            case UD_HUP://7
                if(go_vdown) cal_ns=VDOWN;
                else if(go_wait) cal_ns=WAIT;
                else if(go_idle) cal_ns=IDLE2;
                else cal_ns=UD_HUP;
                break;
            case DD_HDOWN://8
                if(go_idle) cal_ns=IDLE2;
                else if(go_dd_vdown) cal_ns=DD_VDOWN;
                else cal_ns=DD_HDOWN;
                break;
            case DD_VDOWN://9
                if(go_idle) cal_ns=IDLE2;
                else if(go_wait) cal_ns=WAIT;
                else if(go_dd_hdown) cal_ns=DD_HDOWN;
                else cal_ns=DD_VDOWN;
                break;
            case WAIT://10
                if(r_uu_hup) cal_ns=UU_HUP;
                else if(r_vdown) cal_ns=VDOWN;
                else if(r_du_hdown) cal_ns=DU_HDOWN;
                else if(r_du_vup) cal_ns=DU_VUP;
                else if(r_ud_hup) cal_ns=UD_HUP;
                else if(r_dd_vdown) cal_ns=DD_VDOWN;
                else cal_ns=WAIT;
                break;
            default: break;
        }// end switch(cal_cs)

#ifdef __DEBUG_cal
        fprintf(out_file4,"\n");
        fprintf(out_file4,"up_enable %d : vdown_enable %d : hdown_enable %d\n",
                up_enable,vdown_enable,hdown_enable);
        fprintf(out_file4,"last_column %d :: last_row %d :: first_row %d\n",last_column,last_row,first_row);
        fprintf(out_file4,"v_cnt  %d\n",v_cnt);
        fprintf(out_file4,"remain_height  %d\n",remain_height);
        fprintf(out_file4,"remain_width  %d\n",remain_width);
        fprintf(out_file4,"height_cnt =%d :: height_cnt1 =%d \n",height_cnt,height_cnt1);
        fprintf(out_file4,"width_cnt  =%d :: width_cnt1  =%d \n",width_cnt,width_cnt1);
        fprintf(out_file4,"v_rate         : %d ,%f\n",v_rate,(float)v_rate/65536); 
        fprintf(out_file4,"v_rate_cnt     : %d ,%f\n",v_rate_cnt,(float)v_rate_cnt/65536);
        fprintf(out_file4,"h_rate         : %d ,%f\n",h_rate,(float)h_rate/65536); 
        fprintf(out_file4,"h_rate_cnt is  : %f\n",(float)h_rate_cnt/65536);
        fprintf(out_file4,"h_rate_save is : %d,%f\n",h_rate_save,(float)h_rate_save/65536);
        fprintf(out_file4,"h_rate_base is : %d,%f\n",h_rate_base,(float)h_rate_base/65536);
        fprintf(out_file4,"v_rate_base is : %d,%f\n",v_rate_base,(float)v_rate_base/65536);
        fprintf(out_file4,"v_comp_val is  : %d :: h_comp_val : %d\n",v_comp_val,h_comp_val);    
        fprintf(out_file4,"w_buf_en  is   : %d\n",w_buf_en);    
        fprintf(out_file4,"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
        fprintf(out_file4,"div  is %d ::  h_div is %d\n",div,h_div);    
        fprintf(out_file4,"down_cmd  is   : %d\n",down_cmd);    
        fprintf(out_file4,"seq_comp_val is : %d :: h_seq_cnt is : %d \n",seq_comp_val,h_seq_cnt);    
        fprintf(out_file4,"v_seq_cnt is   : %d\n",v_seq_cnt); 
        fprintf(out_file4,"div_num_cnt : %d  ::  hdiv_num_cnt : %d\n",div_num_cnt,hdiv_num_cnt); 
        fprintf(out_file4,"no_hresize : %d :: no_vresize : %d",no_hresize,no_vresize);
        fprintf(out_file4,"\n");
        fprintf(out_file4,"go_idle is %d \n",go_idle);
        fprintf(out_file4,"go_uu is %d :: go_du is %d :: go_ud is %d :: go_dd is %d\n",go_uu,go_du,go_ud,go_dd);
        fprintf(out_file4,"go_vdown is %d    :: go_wait is     %d\n",go_vdown,go_wait);
        fprintf(out_file4,"go_dd_hdown is %d :: go_dd_vdown is %d\n",go_dd_hdown,go_vdown);
        fprintf(out_file4,"go_vdown is %d    :: go_ud_hup is   %d\n",go_vdown,go_ud_hup);
        fprintf(out_file4,"go_du_vup is %d   :: go_du_hdown is %d\n",go_du_vup,go_du_hdown);
        fprintf(out_file4,"go_uu_hup is %d   :: go_uu_vup is   %d\n",go_uu_hup,go_uu_vup);
        fprintf(out_file4,"h_new_pix_num is %d :: h_new_pix_base is %d \n",h_new_pix_num,h_new_pix_base);
        fprintf(out_file4,"v_new_pix_num is %d :: v_new_pix_base is %d \n",v_new_pix_num,v_new_pix_base);
        fprintf(out_file4,"v_new_pix_num_dly %d :: h_new_pix_num_dly %d \n",v_new_pix_num_dly,h_new_pix_num_dly);
        fprintf(out_file4,"rd_h_pix_num is %d \n",rd_h_pix_num);
        fprintf(out_file4,"rd_v_pix_num is %d :: rd_v_pix_num_base %d \n",rd_v_pix_num,rd_v_pix_num_base);
        fprintf(out_file4,"read_pix_num is %d \n",read_pix_num);
        fprintf(out_file4,"src_width is %d last_remain %d : %d \n",src_width,src_width-rd_h_pix_num,last_remain);
        fprintf(out_file4,"cal_fsm_en is %d \n",cal_fsm_en);        
        fprintf(out_file4,"end_fill is %d \n",end_fill);        
        fprintf(out_file4,"src_enable is : %d\n",src_enable);
        fprintf(out_file4,"fill_buf is %d\n",fill_buf);
        fprintf(out_file4,"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");
        fprintf(out_file4,"\n");
        switch(cal_ns)
        {   
            case 0:
                fprintf(out_file4,"next state : IDLE2\n");
                break;
            case 1:
                fprintf(out_file4,"next state : INIT\n");
                break;
            case 2:
                fprintf(out_file4,"next state : UU_HUP\n");
                break;
            case 3:
                fprintf(out_file4,"next state : UU_VUP\n");
                break;
            case 4:
                fprintf(out_file4,"next state : DU_HDOWN\n");
                break;
            case 5:
                fprintf(out_file4,"next state : DU_VUP\n");
                break;
            case 6:
                fprintf(out_file4,"next state : VDOWN\n");
                break;
            case 7:
                fprintf(out_file4,"next state : UD_HUP\n");
                break;
            case 8:
                fprintf(out_file4,"next state : DD_HDOWN\n");
                break;
            case 9:
                fprintf(out_file4,"next state : DD_VDOWN\n");
                break;
            case 10:
                fprintf(out_file4,"next state : WAIT\n");
                break;
        }
#endif
//****************** end calculation *******************

//******************************************************
//                   read memory 
//******************************************************
#ifdef __DEBUG_write
        fprintf(out_file4,"\n");
        fprintf(out_file4,"****** READ  MEMORY *****\n");
        fprintf(out_file4,"read_pix_num %d\n",read_pix_num);
#endif
        r_mem_cs=r_mem_ns;
#ifdef __DEBUG_rd
        fprintf(out_file4,"\n");
        fprintf(out_file4,"MEMORY READ\n");

        switch(r_mem_cs)
        {   
            case 0:
                fprintf(out_file4,"/////////////////////////////\n");
                fprintf(out_file4,"read_mem current state : IDLE\n");
                fprintf(out_file4,"/////////////////////////////\n");
                break;
            case 1:
                fprintf(out_file4,"/////////////////////////////\n");
                fprintf(out_file4,"read_mem current state : SETTING\n");
                fprintf(out_file4,"/////////////////////////////\n");
                break;
            case 2:
                fprintf(out_file4,"/////////////////////////////\n");
                fprintf(out_file4,"read_mem current state : R_MEM\n");
                fprintf(out_file4,"////////////////////////////\n");
                break;
            case 3:
                fprintf(out_file4,"/////////////////////////////\n");
                fprintf(out_file4,"read_mem current state : COLOR_CONV\n");
                fprintf(out_file4,"/////////////////////////////\n");
                break;
            default: 
                fprintf(out_file4,"/////////////////////////////\n");
                fprintf(out_file4,"read_mem current state : IDLE\n");
                fprintf(out_file4,"/////////////////////////////\n");
                break;
        }
        fprintf(out_file4,"rd_cmd_cnt is  : %d\n",rd_cmd_cnt);
        fprintf(out_file4,"read_cnt is   : %d\n",read_cnt);
        fprintf(out_file4,"read_comp is   : %d\n",read_comp);
        fprintf(out_file4,"rd_cmd is      : %x\n",rd_cmd);
        fprintf(out_file4,"rd_num is      : %d\n",rd_num);
        fprintf(out_file4,"fill_buf is    : %d\n",fill_buf);
        fprintf(out_file4,"r_fsm_en is    : %d\n",r_fsm_en);
        fprintf(out_file4,"end_fill is    : %d\n",end_fill);
        fprintf(out_file4,"base_pix_num :%d :: latch_read_pix_num :%d\n",base_pix_num,latch_read_pix_num);
//        fprintf(out_file4,"read_comp is     : %d\n",read_comp);
        fprintf(out_file4,"in_buf_num is    : %d\n",in_buf_num);
//        fprintf(out_file4,"choice_cmd is    : %d\n",choice_cmd);
//        fprintf(out_file4,"odd is           : %d\n",odd);
//        fprintf(out_file4,"end is           : %d\n",end);
#endif

        if(valid_data)
        {
            next_num=in_buf_num+1;

            switch(bpp)
            {
                case 1://16bpp1555
                    if(choice_cmd==0)// even number
                    {
                        in_buf_a[in_buf_num]=(unsigned char) ((rd_pix >> 31)&0x01);
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 23)&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 18)&0xf8);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix >> 13)&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"-----------upper----------\n");
                        fprintf(out_file4,"in_buf_a[%d] is %x \n",in_buf_num,in_buf_a[in_buf_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    else if(choice_cmd==1) // odd number
                    {
                        in_buf_a[in_buf_num]=(unsigned char) ((rd_pix >> 15)&0x01);
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 7 )&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 2 )&0xf8);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix << 3 )&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"-----------lower----------\n");
                        fprintf(out_file4,"in_buf_a[%d] is %x \n",in_buf_num,in_buf_a[in_buf_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    else if(choice_cmd==2)
                    {
                        in_buf_a[in_buf_num]=(unsigned char) ((rd_pix >> 31)&0x01);
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 23)&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 18)&0xf8);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix >> 13)&0xf8);
                        in_buf_a[next_num]=(unsigned char) ((rd_pix >> 15)&0x01);
                        in_buf_r[next_num]=(unsigned char) ((rd_pix >> 7 )&0xf8);
                        in_buf_g[next_num]=(unsigned char) ((rd_pix >> 2 )&0xf8);
                        in_buf_b[next_num]=(unsigned char) ((rd_pix << 3 )&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"in_buf_a[%d] is %x \n",in_buf_num,in_buf_a[in_buf_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"in_buf_a[%d] is %x \n",next_num,in_buf_a[next_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",next_num,in_buf_r[next_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",next_num,in_buf_g[next_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",next_num,in_buf_b[next_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    break;
                case 2://16bpp565
                    if(choice_cmd==0) //even number
                    {
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 24)&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 19)&0xfc);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix >> 13)&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"-----------upper----------\n");
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    if(choice_cmd==1) //odd number
                    {
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 8 )&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 3 )&0xfc);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix << 3 )&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"-----------lower----------\n");
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    else if(choice_cmd==2)
                    {
                        in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 24)&0xf8);
                        in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 19)&0xfc);
                        in_buf_b[in_buf_num]=(unsigned char) ((rd_pix >> 13)&0xf8);
                        in_buf_r[next_num]=(unsigned char) ((rd_pix >> 8 )&0xf8);
                        in_buf_g[next_num]=(unsigned char) ((rd_pix >> 3 )&0xfc);
                        in_buf_b[next_num]=(unsigned char) ((rd_pix << 3 )&0xf8);
#ifdef __DEBUG_write
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",next_num,in_buf_r[next_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",next_num,in_buf_g[next_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",next_num,in_buf_b[next_num]);
                        fprintf(out_file4,"\n");
#endif
                    }
                    break;
                case 3://24bpp888
#ifdef __DEBUG_write
                    fprintf(out_file4,"\n");
                    fprintf(out_file4,"format is %d \n",format);
                    fprintf(out_file4,"choice_cmd is %d \n",choice_cmd);
#endif
                    if(format==RGBR)
                    {
                        if(choice_cmd==0)
                        {
                            in_buf_r[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
                            in_buf_g[in_buf_num]  =(unsigned char) ((rd_pix >> 16)&0xff);
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 8 )&0xff);
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                        else if(choice_cmd==1)
                        {
                            in_buf_r[in_buf_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                        else if(choice_cmd==2)
                        {
                            in_buf_r[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
                            in_buf_g[in_buf_num]  =(unsigned char) ((rd_pix >> 16)&0xff);
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 8 )&0xff);
                            in_buf_r[next_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",next_num,in_buf_r[next_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                    }
                    else if(format==GBRG)
                    {
                        if(choice_cmd==0)
                        {
                            in_buf_g[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 16)&0xff);
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                        else if(choice_cmd==1)
                        {
                            in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 8 )&0xff);
                            in_buf_g[in_buf_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
#endif
                        }
                        else if(choice_cmd==2)
                        {
                            in_buf_g[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 16)&0xff);
                            in_buf_r[next_num]=(unsigned char) ((rd_pix >> 8 )&0xff);
                            in_buf_g[next_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",next_num,in_buf_r[next_num]);
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",next_num,in_buf_g[next_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                    }
                    else if(format==BRGB)
                    {
                        if(choice_cmd==0)
                        {
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
#endif
                        }
                        else if(choice_cmd==1)
                        {
                            in_buf_r[in_buf_num]=(unsigned char) ((rd_pix >> 16)&0xff);
                            in_buf_g[in_buf_num]=(unsigned char) ((rd_pix >> 8 )&0xff);
                            in_buf_b[in_buf_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                            fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                            fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                            fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                            fprintf(out_file4,"\n");
#endif
                        }
                        else if(choice_cmd==2)
                        {
                            in_buf_b[in_buf_num]  =(unsigned char) ((rd_pix >> 24)&0xff);
                            in_buf_r[next_num]=(unsigned char) ((rd_pix >> 16)&0xff);
                            in_buf_g[next_num]=(unsigned char) ((rd_pix >> 8 )&0xff);
                            in_buf_b[next_num]=(unsigned char) rd_pix & 0xff;
#ifdef __DEBUG_write
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                        fprintf(out_file4,"in_buf_r[%d] is %x \n",next_num,in_buf_r[next_num]);
                        fprintf(out_file4,"in_buf_g[%d] is %x \n",next_num,in_buf_g[next_num]);
                        fprintf(out_file4,"in_buf_b[%d] is %x \n",next_num,in_buf_b[next_num]);
                        fprintf(out_file4,"\n");
#endif
                        }
                    }
                    break;
                case 4://32bpp1888
                case 5://32bpp8888
                    in_buf_a[in_buf_num]=(unsigned char) (rd_pix>>24)&0xff;
                    in_buf_r[in_buf_num]=(unsigned char) (rd_pix>>16)&0xff;
                    in_buf_g[in_buf_num]=(unsigned char) (rd_pix>>8 )&0xff;
                    in_buf_b[in_buf_num]=(unsigned char) rd_pix&0xff;
#ifdef __DEBUG_write
                    fprintf(out_file4,"in_buf_a[%d] is %x \n",in_buf_num,in_buf_a[in_buf_num]);
                    fprintf(out_file4,"in_buf_r[%d] is %x \n",in_buf_num,in_buf_r[in_buf_num]);
                    fprintf(out_file4,"in_buf_g[%d] is %x \n",in_buf_num,in_buf_g[in_buf_num]);
                    fprintf(out_file4,"in_buf_b[%d] is %x \n",in_buf_num,in_buf_b[in_buf_num]);
                    fprintf(out_file4,"\n");
#endif
                default:break;
            }// end switch
            buf_cnt_en=1;
        }//end COLOR_CONV
        if(end_fill || (r_mem_ns==SETTING & fill_buf==0))
        {
#ifdef __DEBUG_rd
            fprintf(out_file4,"NUMBER INITIALIZE\n");
#endif
            if(rd_num==2)
            {
                if(in_buf_num<=3) in_buf_num=4;
                else if(4<=in_buf_num && in_buf_num<=7) in_buf_num=8;
                else if(8<=in_buf_num && in_buf_num<=11) in_buf_num=0;
            }
            else if(rd_num==3)
            {
                if(in_buf_num==2 || in_buf_num==3) in_buf_num=4;
                else if(in_buf_num==6 || in_buf_num==7) in_buf_num=8;
                else if(in_buf_num==10 || in_buf_num==11) in_buf_num=0;
            }
        }
        if((r_fsm_en || fill_buf))
        {
            if((rd_cmd>>5)==0) in_buf_num=0; //rd_cmd 5번째 bit==0이면  in_buf_num=0 initialize
            else if(in_buf_num>=11) in_buf_num=0;
            else in_buf_num=in_buf_num;
        }
        if(r_mem_ns==R_MEM & buf_cnt_en & valid_data)
        {

#ifdef __DEBUG_rd
            fprintf(out_file4,"NUMBER CALCULATION\n");
#endif
            if(bpp==3)
            {
                if(in_buf_num==11) in_buf_num=0;
                else
                {
                    if(choice_cmd==0)
                    {
                        in_buf_num=in_buf_num+1;
                    }
                    else if(choice_cmd==1)
                    {
                        if(format==BRGB) in_buf_num=in_buf_num+1;
                        else in_buf_num=in_buf_num;
                    }
                    else
                    {
                        if(format==BRGB) in_buf_num=in_buf_num+2;
                        else in_buf_num=in_buf_num+1;
                    }
                }
            }
            else
            {
                if(choice_cmd==2)
                {
                    if(in_buf_num==10) in_buf_num=0;
                    else in_buf_num=in_buf_num+2;
                }
                else 
                {
                    if(in_buf_num==11) in_buf_num=0;
                    else in_buf_num=in_buf_num+1;
                }
            }
        }
#ifdef __DEBUG_rd
        fprintf(out_file4,"in_buf_num is : %d\n",in_buf_num);
#endif

        if(r_mem_cs==R_MEM)
        {
            go_setting=0;
            if(bpp==1 || bpp==2)
            {
                if(odd)
                {
                    if(read_cnt==0) choice_cmd=1;
                    else if(read_cnt==1)
                    {
                        if(rd_num==2) choice_cmd=0;
                        else choice_cmd=2;
                    }
                    else choice_cmd=0;
                }
                else 
                {
                    if(read_cnt==0) choice_cmd=2;
                    else if(read_cnt==1)
                    {
                        if(rd_num==3) choice_cmd=0;
                        else if(rd_num==4) choice_cmd=2;
                    }
                }
            }
            else if(bpp==3)
            {
                if(remainder==0)
                {
                    if(read_cnt==0) choice_cmd=2;
                    else if(read_cnt==1) 
                    {
                        if(rd_num==2) choice_cmd=0;
                        else choice_cmd=2;
                    }
                    else if(read_cnt==2)
                    {
                        if(rd_num==4) choice_cmd=2;
                        else choice_cmd=0;
                    }
                }
                else if(remainder==1)
                {
                    if(read_cnt==0) choice_cmd=1;
                    else if(read_cnt==1) choice_cmd=2;
                    else if(read_cnt==2)
                    {
                        if(rd_num==2) choice_cmd=0;
                        else choice_cmd=2;
                    }
                    else if(read_cnt==3) choice_cmd=0;
                }
                else if(remainder==2)
                {
                    if(read_cnt==0) choice_cmd=1;
                    else if(read_cnt==1) choice_cmd=2;
                    else if(read_cnt==2)
                    {
                        if(rd_num==3) choice_cmd=0;
                        else if(rd_num==4) choice_cmd=2;
                    }
                    else if(read_cnt==3) choice_cmd=0;
                }
                else if(remainder==3)
                {
                    if(read_cnt==0) choice_cmd=1;
                    else if(read_cnt==1)
                    {
                        if(rd_num==2) choice_cmd=0;
                        else choice_cmd=2;
                    }
                    else if(read_cnt==2)
                    {
                        if(rd_num==4) choice_cmd=2;
                        else choice_cmd=0;
                    }
                    else if(read_cnt==3) choice_cmd=0;
                }
            }
            valid_data=0;
            rd_pix=memory[rd_addr];
#ifdef __DEBUG_rd
            fprintf(out_file4,"\n");
            fprintf(out_file4,"***********************\n");
            fprintf(out_file4,"memory[%d] : %x \n",rd_addr,memory[rd_addr]);
            fprintf(out_file4,"***********************\n");
#endif
            format=rd_addr%3;
            if(read_cnt==read_comp)//read할 갯수와 같으면
            {
                read_cnt=0;
                rd_cmd_cnt=rd_cmd_cnt+1;//hdl coding caution
////////****************************************************/////////
                if((rd_cmd&0x1f)==0)//1-line read
                {
                    end_fill=1;
                    go_setting=0;
                }
                else if(rd_cmd_cnt==((rd_cmd&0x1f)+1)){//hdl coding caution
                    end_fill=1;
                    rd_cmd_cnt=0;
                }
                else
                {
                    end_fill=0;
                    go_setting=1;
                }
                
                /*if((rd_cmd&0x03)==0){//1-line read
                    end_fill=1;
                    go_setting=0;
                }else if((rd_cmd&0x03)==1){ //2-line read
                    if(rd_cmd_cnt==2){//hdl coding caution
                        end_fill=1;
                        rd_cmd_cnt=0;
                    }else{
                        end_fill=0;
                        go_setting=1;
                    }
                }
                else if((rd_cmd&0x03)==2)//3-line read
                {
                    if(rd_cmd_cnt==3){//hdl coding caution
                        end_fill=1;
                        rd_cmd_cnt=0;
                    }else{
                        end_fill=0;
                        go_setting=1;
                    }
                }*/
            }
            else 
            {
                read_cnt=read_cnt+1;
                rd_addr=rd_addr+1;
                valid_data=1;
            }
        }//end R_MEM
        else if(r_mem_cs==SETTING)
        {
            latch_read_pix_num=read_pix_num;//latch            
            //test
#ifdef __START
            r_fsm_en=0;
            fill_buf=0;
#endif
            if(go_setting) base_pix_num=base_pix_num+src_width;
            else base_pix_num=read_pix_num;
            go_setting=0;
            
            if(bpp==1 || bpp==2)
            {
                rd_addr=base_pix_num>>1;
                odd = base_pix_num % 2;
                if(odd)//odd pixel
                {
                    if(rd_num==2)  read_comp=2; 
                    else if(rd_num==3) read_comp=2;
                    else if(rd_num==4) read_comp=3;
                }
                else// even pixel
                {
                    if(rd_num==2) read_comp=1; 
                    else if(rd_num==3) read_comp=2;
                    else if(rd_num==4) read_comp=2;
                }
            }
            else if(bpp==3)
            {
                quotient=base_pix_num / 4;
                remainder=base_pix_num % 4;
                if(remainder==0)
                {
                    rd_addr=quotient*3;
                    if(rd_num==2) read_comp=2; 
                    else if(rd_num==3) read_comp=3;
                    else if(rd_num==4) read_comp=3;
                }
                else if(remainder==1)
                {
                    rd_addr=quotient*3;
                    if(rd_num==2) read_comp=3; 
                    else if(rd_num==3) read_comp=3;
                    else if(rd_num==4) read_comp=4;
                }
                else if(remainder==2)
                {
                    rd_addr=(quotient*3)+1;
                    if(rd_num==2) read_comp=2; 
                    else if(rd_num==3) read_comp=3;
                    else if(rd_num==4) read_comp=4;
                }
                else if(remainder==3)
                {
                    rd_addr=(quotient*3)+2;
                    if(rd_num==2) read_comp=2; 
                    else if(rd_num==3) read_comp=3;
                    else if(rd_num==4) read_comp=4;
                }
                
            }
            else if(bpp==4 || bpp==5)
            {
                if(rd_num==2) read_comp=2;
                else if(rd_num==3) read_comp=3;
                else if(rd_num==4) read_comp=4;
                rd_addr=base_pix_num;
            }
#ifdef __DEBUG_rd
                fprintf(out_file4,"base_pix_num  : %d\n",base_pix_num);
                fprintf(out_file4,"read_comp     : %d\n",read_comp);
                fprintf(out_file4,"rd_addr is    : %d\n",rd_addr);
                fprintf(out_file4,"quotient is   : %d\n",quotient);
                fprintf(out_file4,"remainder is  : %d\n",remainder);
                fprintf(out_file4,"odd is        : %d\n",odd);
#endif
        }//end SETTING
        else if(r_mem_cs==IDLE1)
        {
            valid_data=0;
            end_fill=0;
            read_cnt=0;
            rd_cmd_cnt=0;
        }  

        if(in_buf_num==3 || in_buf_num==4) full_buf=0x05;//2,0 full
        else if(in_buf_num==6 || in_buf_num==7 || in_buf_num==8) full_buf=0x03;//0,1 full
        else if(in_buf_num==11 || in_buf_num==12 || in_buf_num==0) full_buf=0x06;//1,2 full


#ifdef __DEBUG_rd
        fprintf(out_file4,"full_buf is %d\n",full_buf);        
#endif

        //next_state
        switch(r_mem_cs)
        {
            case IDLE1://idle
                if(r_fsm_en || fill_buf) r_mem_ns=SETTING;
                else r_mem_ns=IDLE1;
                break;
            case SETTING:
                r_mem_ns=R_MEM;
            case R_MEM://r_mem
                if(go_setting) r_mem_ns=SETTING;
                else if(end_fill) r_mem_ns=IDLE1;
                else r_mem_ns=R_MEM;
                break;
            default: break;
        }

#ifdef __DEBUG_rd
        switch(r_mem_ns)
        {   
            case 0:
                fprintf(out_file4,"next state : IDLE\n");
                break;
            case 1:
                fprintf(out_file4,"next state : SETTING\n");
                break;
            case 2:
                fprintf(out_file4,"next state : R_MEM\n");
                break;
        }
        fprintf(out_file4,"\n");
        fprintf(out_file4,"READ MOMEORY END\n");
        fprintf(out_file4,"\n");
#endif
#ifdef __DEBUG_input
        char input=0;
        input=getchar();
        if(input=='0')
        {
            fill_buf=1;
            rd_cmd=31;
            rd_num=4;
            read_pix_num=320;
        }
        if(input=='1') 
        {
            fill_buf=1;
            rd_cmd=4;
            rd_num=4;
            read_pix_num=320;
        }
        if(input=='2')
        {
            fill_buf=1;
            rd_cmd=1;
            rd_num=3;
            read_pix_num=2;
        }
        if(input=='3')
        {
            fill_buf=1;
            rd_cmd=1;
            rd_num=3;
            read_pix_num=3;
        }

#endif
#ifdef __DEBUG_write
        fprintf(out_file4,"*****READ MEMORY END*****\n");
        fprintf(out_file4,"\n");
#endif

//****************** end mem_read **********************




    }// end while(new_pix_num!=new_width*new_height)

#ifdef four //4의 배수로 정렬
    add_width=new_width;
    ff=new_width%4;
    fprintf(out_file6,"ff is %d :: add_width is%d \n",ff,add_width);
    fprintf(out_file6,"new_width is %d :: new_height is%d \n",new_width,new_height);
    if(ff==1) // dummy 0xffffff 0xffffff 0xffffff
    {
        for(i=0;i<((new_width)*new_height);i++){
            if(i==(add_width)){
                t++;
                add_width=add_width+new_width;
                for(n=0;n<3;n++){
                    revise_mem[i+n+m]=0xffffff;
                    fprintf(out_file6,"m is %d :: i+n+m is %d\n",m,i+n+m);
                }
                m=m+3;
                fprintf(out_file6,"t=%d add_width is %d :: m :%d\n",t,add_width,m);
            }
            revise_mem[i+m]=new_mem[i];
            fprintf(out_file6,"number %d :::: revise[i+m]:%d\n",i,i+m);

        }
        if(i==(new_width*new_height)){
            for(n=0;n<3;n++)
            {
                revise_mem[i+n+m]=0xffffff;
                fprintf(out_file6,"end_revise[i+n+m]:%d\n",i+n+m);
            }
        }
        for(i=0;i<(new_width+3)*new_height;i++)
            fprintf(out_file7,"%02x %02x %02x\n",(revise_mem[i]>>16)&0xff,(revise_mem[i]>>8)&0xff,(revise_mem[i])&0xff);

    }
    else if(ff==2)// dummy 0xffffff 0xffffff
    {
        for(i=0;i<((new_width)*new_height);i++){
            if(i==(add_width)){
                t++;
                add_width=add_width+new_width;
                for(n=0;n<2;n++){
                    revise_mem[i+n+m]=0xffffff;
                    fprintf(out_file6,"m is %d :: i+n+m is %d\n",m,i+n+m);
                }
                m=m+2;
                fprintf(out_file6,"t=%d add_width is %d :: m :%d\n",t,add_width,m);
            }
            revise_mem[i+m]=new_mem[i];
            fprintf(out_file6,"number %d :::: revise[i+m]:%d\n",i,i+m);

        }
        if(i==(new_width*new_height)){
            for(n=0;n<2;n++)
            {
                revise_mem[i+n+m]=0xffffff;
                fprintf(out_file6,"end_revise[i+n+m]:%d\n",i+n+m);
            }
        }
        for(i=0;i<(new_width+2)*new_height;i++)
            fprintf(out_file7,"%02x %02x %02x\n",(revise_mem[i]>>16)&0xff,(revise_mem[i]>>8)&0xff,(revise_mem[i])&0xff);
    }
    else if(ff==3)// dummy 0xffffff 
    {
        for(i=0;i<((new_width)*new_height);i++){
            if(i==(add_width)){
                t++;
                add_width=add_width+new_width;
                for(n=0;n<1;n++){
                    revise_mem[i+n+m]=0xffffff;
                    fprintf(out_file6,"m is %d :: i+n+m is %d\n",m,i+n+m);
                }
                m=m+1;
                fprintf(out_file6,"t=%d add_width is %d :: m :%d\n",t,add_width,m);
            }
            revise_mem[i+m]=new_mem[i];
            fprintf(out_file6,"number %d :::: revise[i+m]:%d\n",i,i+m);

        }
        if(i==(new_width*new_height)){
            for(n=0;n<1;n++)
            {
                revise_mem[i+n+m]=0xffffff;
                fprintf(out_file6,"end_revise[i+n+m]:%d\n",i+n+m);
            }
        }
        for(i=0;i<(new_width+1)*new_height;i++)
            fprintf(out_file7,"%02x %02x %02x\n",(revise_mem[i]>>16)&0xff,(revise_mem[i]>>8)&0xff,(revise_mem[i])&0xff);
    }
    else
    {
        for(i=0;i<new_width*new_height;i++)
        {
            fprintf(out_file7,"%02x %02x %02x\n",(new_mem[i]>>16)&0xff,(new_mem[i]>>8)&0xff,(new_mem[i])&0xff);
		}
    }
#endif

    for(i=0;i<new_width*new_height;i++)
	{
	    fprintf(out_file2,"%02x %02x %02x\n",(new_mem[i]>>16)&0xff,(new_mem[i]>>8)&0xff,(new_mem[i])&0xff);
		//fputc(new_mem[i],out_file2); 
		//fputc(new_mem[i]>>8,out_file2); 
		//fputc(new_mem[i]>>16,out_file2); 
	}
    printf("go_idle %d\n",go_idle);
    printf("\n");
    printf("v_rate_cnt     : %d ,%f\n",v_rate_cnt,(float)v_rate_cnt/65536);
    printf("h_rate_cnt is  : %f\n",(float)h_rate_cnt/65536);
    printf("h_rate_save is : %d,%f\n",h_rate_save,(float)h_rate_save/65536);
    printf("h_rate_base is : %d,%f\n",h_rate_base,(float)h_rate_base/65536);
    printf("v_rate_base is : %d,%f\n",v_rate_base,(float)v_rate_base/65536);
    printf("last_column %d :: last_row %d :: first_row %d\n",last_column,last_row,first_row);
    printf("height_cnt =%d :: height_cnt1 =%d \n",height_cnt,height_cnt1);
    printf("width_cnt  =%d :: width_cnt1  =%d \n",width_cnt,width_cnt1);
    printf("go_idle is %d \n",go_idle);
    printf("go_uu is %d :: go_du is %d :: go_ud is %d :: go_dd is %d\n",go_uu,go_du,go_ud,go_dd);
    printf("go_vdown is %d    :: go_wait is     %d\n",go_vdown,go_wait);
    printf("go_dd_hdown is %d :: go_dd_vdown is %d\n",go_dd_hdown,go_vdown);
    printf("go_vdown is %d    :: go_ud_hup is   %d\n",go_vdown,go_ud_hup);
    printf("go_du_vup is %d   :: go_du_hdown is %d\n",go_du_vup,go_du_hdown);
    printf("go_uu_hup is %d   :: go_uu_vup is   %d\n",go_uu_hup,go_uu_vup);
    printf("h_new_pix_num is %d :: h_new_pix_base is %d \n",h_new_pix_num,h_new_pix_base);
    printf("v_new_pix_num is %d :: v_new_pix_base is %d \n",v_new_pix_num,v_new_pix_base);
    printf("v_new_pix_num_dly %d :: h_new_pix_num_dly %d \n",v_new_pix_num_dly,h_new_pix_num_dly);
    printf("rd_h_pix_num is %d \n",rd_h_pix_num);
    printf("rd_v_pix_num is %d :: rd_v_pix_num_base %d \n",rd_v_pix_num,rd_v_pix_num_base);
    printf("read_pix_num is %d \n",read_pix_num);
    printf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$\n");

}// end main

int up(unsigned int *buf,unsigned int point1,unsigned int point2,unsigned long mul)
{
    int slope;
    unsigned long val;
    int cal;

    slope=point2-point1;
    cal=((int)(slope*(mul&0xffff))+16384)>>16;
    val=point1+cal;
    *buf=val; //32768 ==> 0.5  :: 16384 ==> 0.25
    return 1;
#ifdef __DEBUG_up
    printf("cal is %d\n",cal);
    printf("point1 is  :%d , point2 is %d\n",*point1,*point2);
    printf("slope is   :%d \n",slope);
    printf("mul is     :%d \n",mul);
    printf("buf is :%d\n",*buf);
    printf("\n");
#endif
}
/*
int hdown(unsigned int div,unsigned char cmd,unsigned int *result,
           unsigned char p0,unsigned char p1,unsigned char p2,unsigned char p3)
{
    if(cmd==0x00)
        *result=(p0 + p1 + p2 + p3);
    else if(cmd==0x01)
        *result=(p0 + p1 + p2 + p3)/div;
    return 1;
}
*/
int vdown(unsigned int div,unsigned char cmd,
          unsigned int *buf_a,unsigned int *buf_r,
          unsigned int *buf_g,unsigned int *buf_b,
          unsigned int p0 ,unsigned int p1,
          unsigned int p2 ,unsigned int p3,
          unsigned int p4 ,unsigned int p5,
          unsigned int p6 ,unsigned int p7)
{
    if(cmd==0x00){
        *buf_a=(p0 + p1);
        *buf_r=(p2 + p3);
        *buf_g=(p4 + p5);
        *buf_b=(p6 + p7);
    }
    else if(cmd==0x01){
        *buf_a=(p0 + p1)/div;
        *buf_r=(p2 + p3)/div;
        *buf_g=(p4 + p5)/div;
        *buf_b=(p6 + p7)/div;
    }
#ifdef __DEBUG_hdown
fprintf(out_file4,"DOWN CALCULATION\n");
fprintf(out_file4,"cmd is %d :: div is %d\n",cmd,div);
fprintf(out_file4,"point0 :%06x + point1:%06x = buf_a %d,%x\n",p0,p1,*buf_a,*buf_a);
fprintf(out_file4,"point2 :%06x + point3:%06x = buf_r %d,%x\n",p2,p3,*buf_r,*buf_r);
fprintf(out_file4,"point4 :%06x + point5:%06x = buf_g %d,%x\n",p4,p5,*buf_g,*buf_g);
fprintf(out_file4,"point6 :%06x + point7:%06x = buf_b %d,%x\n",p6,p7,*buf_b,*buf_b);
#endif
    return 1;
}

//********************************************************
//
//********************************************************

int help()
{
	printf(" Resizing image\n");
	printf(" usage => \n");
	printf(" $ scaler.exe source_width source_height new_width new_height bpp input.dat \n");
	printf(" max width  : 2048 \n");
	printf(" max height : 2048 \n");
	printf(" bpp :  Color Data Type \n");
	printf("  1  : 16bpp ARGB 1555 color \n");
	printf("  2  : 16bpp RGB  565  color \n");
	printf("  3  : 24bpp RGB  888  color \n");
	printf("  4  : 32bpp ARGB 1888 color \n");
	printf("  5  : 32bpp ARGB 8888 color \n");
}

int memory_blk()
{
    int i=0;
    int j,k=0;
    long length;
    unsigned int ch;
    unsigned char cnt=0x0;

    fseek(src_file,0L,SEEK_END);	
	length = ftell(src_file);
    rgb_img = malloc(length);
    fseek(src_file,0L,SEEK_SET);

    out_file = fopen(out_fname,"wt");
    out_file1= fopen(out_fname1,"wt");
    out_file5= fopen(out_fname5,"wt");
    while((ch = getc(src_file)) != EOF)	
	{
        //        if(ch != '\n' && ch != '\r')
        if( (ch >= '0' && ch <= '9') || 
            (ch >= 'a' && ch <= 'f') || 
		    (ch >= 'A' && ch <= 'F')
          ) 
        {
            if(cnt==0x00) j=1; 
            else j=0;  
            cnt = ~cnt;
            if(ch>='0' && ch<='9')
            { 
                rgb_img[i] |= ((ch - '0')&0x0f) << (4*j);
            }
            else if(ch>='a' && ch<='f' )
            {
                rgb_img[i] |= (((ch - 'a')+10)&0x0f) << (4*j);
            }
            else if(ch>='A' && ch<='F')
            {
                rgb_img[i] |= (((ch - 'A')+10)&0x0f) << (4*j);
            }
            if(j==0){
                i++;
            }
        }
    }
    in_dsize = i;

#ifdef __DEBUG0
    printf("file size %ld \n",length);
    printf("%x\n",rgb_img[0]);
    printf("total num : %d\n ",i);
#endif

#ifdef __DEBUG_data
    for(k=0;k<i;k++)
        fprintf(out_file,"%02x\n",rgb_img[k]&0xff);
    printf("k value : %d \n",k);
#endif
    
    switch(bpp)
    {
        case 1: bpp_argb16();
                break;
        case 2: bpp_rgb16();
                break;
        case 3: bpp_rgb24();
                break;
        case 4: bpp32_1888();
                break;
        case 5: bpp32_8888();
                break;
        default: break;
    }
    free(rgb_img);	

#ifdef __DEBUG0
    printf("memory[0] is %x\n",memory[0]);
    printf("memory size is %d \n",mem_size );
#endif
#ifdef __DEBUG_data
    int mod;
    k=0;
    for(k=0;k<mem_size;k++)
        fprintf(out_file5,"%08x\n",memory[k]&0xffffffff);

    if(bpp==1)
    {
        for(k=0;k<mem_size;k++)
        {
            fprintf(out_file1,"%02x %02x %02x\n",(memory[k]>>23)&0xf8,
                    (memory[k]>>18)&0xf8,(memory[k]>>13)&0xf8);
            fprintf(out_file1,"%02x %02x %02x\n",(memory[k]>>7)&0xf8,
                    (memory[k]>>2)&0xf8,(memory[k]<<3)&0xf8);
        }
    }
    else if(bpp==2)
    {
        for(k=0;k<mem_size;k++)
        {
            fprintf(out_file1,"%02x %02x %02x\n",(memory[k]>>24)&0xf8,
                    (memory[k]>>19)&0xfc,(memory[k]>>13)&0xf8);
            fprintf(out_file1,"%02x %02x %02x\n",(memory[k]>>8)&0xf8,
                    (memory[k]>>3)&0xfc,(memory[k]<<3)&0xf8);
        }
    }
    else if(bpp==3)
    {
        for(k=0;k<mem_size;k++)
        {
            mod=(k+3)%3;
            if(mod==0)
                fprintf(out_file1,"%02x %02x %02x\n%02x",(memory[k]>>24)&0xff,
                        (memory[k]>>16)&0xff,(memory[k]>>8)&0xff,(memory[k])&0xff);
            else if(mod==1)
                fprintf(out_file1," %02x %02x\n%02x %02x",(memory[k]>>24)&0xff,
                        (memory[k]>>16)&0xff,(memory[k]>>8)&0xff,(memory[k])&0xff);
            else if(mod==2)
                fprintf(out_file1," %02x \n%02x %02x %02x\n",(memory[k]>>24)&0xff,
                        (memory[k]>>16)&0xff,(memory[k]>>8)&0xff,(memory[k])&0xff);
        }
    }
    else
    {
        for(k=0;k<mem_size;k++)
            fprintf(out_file1,"%02x %02x %02x\n",(memory[k]>>16)&0xff,
                    (memory[k]>>8)&0xff,(memory[k])&0xff);
    }
#endif
    return 1;
}



int bpp_argb16()
{
    int i=0;
    int j;
    int pos=0;
    
    while(pos <= in_dsize)
    {
        for(j=5;j>=0;j--)
        {
            switch(j)
            {
                case 0:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) >> 3;
                    break;
                case 1:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 2;
                    break;
                case 2:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 7;
                    break;
                case 3:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 13;
                    break;
                case 4:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 18;
                    break;
                case 5:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 23;
                    break;
                default: break;
            }
        }
        i++;
    }
    mem_size = i;
    return 1;
}

int bpp_rgb16()
{
    int i=0;
    int j;
    int pos=0;
    
    while(pos <= in_dsize)
    {
        for(j=5;j>=0;j--)
        {
            switch(j)
            {
                case 0:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) >> 3;
                    break;
                case 1:
                    memory[i] |= (*(rgb_img + pos++) & 0xfc) << 3;
                    break;
                case 2:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 8;
                    break;
                case 3:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 13;
                    break;
                case 4:
                    memory[i] |= (*(rgb_img + pos++) & 0xfc) << 19;
                    break;
                case 5:
                    memory[i] |= (*(rgb_img + pos++) & 0xf8) << 24;
                    break;
                default: break;
            }
        }
        i++;
    }
 
    mem_size = i;
    return 1;
}

int bpp_rgb24()
{
    int i=0;
    int j;
    int pos=0;

    while(pos <= in_dsize)
    {
        for(j=3;j>=0;j--)
        {
            memory[i] |= *(rgb_img + pos++) << (8*j);
        }
        i++;
    }

    mem_size = i;
    return 1;
}

int bpp32_1888()
{
    int i=0;
    int j;
    int pos=0;

    while(pos <= in_dsize)
    {
        for(j=3;j>=0;j--)
        {
            if(j==3)
                memory[i] |= 0x80 << (8*j);
            else
                memory[i] |= *(rgb_img + pos++) << (8*j);
        }
        i++;
    }
    mem_size = i;
    return 1;
}

int bpp32_8888()
{
    int i=0;
    int j;
    int pos=0;

    while(pos <= in_dsize)
    {
        for(j=3;j>=0;j--)
        {
            if(j==3)
                memory[i] |= 0xff << (8*j);
            else
                memory[i] |= *(rgb_img + pos++) << (8*j);
        }
        i++;
    }
    mem_size = i;
    return 1;
}

int conv_integer(float rate)
{
    int val=0;
    int i=0;

    float l_rate;
    unsigned int k=0;
    unsigned int j=0;
    unsigned int l=0;
    unsigned int factor=0;
    l_rate=rate;
    k=rate;
    l=rate;

#ifdef __START
    printf("rate is %f\n",rate);
    printf("k is %d\n",k);
#endif
    if(k==0)// 
    {
        for(i=15;i>0;i--)
        {  
            rate=rate*2.0;
            val=rate;
            val=val % 2;
            factor |= val<<i;
        }
    }
    else // 
    {
        for(i=16;i<32;i++)
        {
            j=k%2;
            k=k/2;
            factor |= j<<i;
        }
        l_rate=l_rate-l;
        for(i=15;i>0;i--)
        {  
            l_rate=l_rate*2.0;
            val=l_rate;
            val=val % 2;
            factor |= val<<i;
        }
    
    }

#ifdef __START
    printf("factor is %u :: %f\n",factor,(float)factor/65536);
#endif
    
    return factor;
}

