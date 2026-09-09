#include <stdio.h>
void main(int argc, char *argv[])
{
    FILE *in;
    FILE *out0;
    FILE *out1;
    FILE *out2;
    FILE *out3;
    char string[100];
    unsigned int i;
//    in=fopen("SDI_V5.rom","r");
    in=fopen(argv[1],"r");
  
    out1=fopen("rom0.v","w");
    out2=fopen("rom1.v","w");
    out3=fopen("rom2.v","w");
    out0=fopen("rom.v","w");
    
    if (in==NULL)
    {
        printf("file missing\n");
    }
    else
    {
        
        fprintf(out0,"//-------------------------------------------------------\n");
        fprintf(out0,"//--  SDI V5 test rom model for FPGA TEST \n");
        fprintf(out0,"//-------------------------------------------------------\n");
        fprintf(out0,"//--  verilog rom model 16bit\n");
        fprintf(out0,"//--  made by duck (-,.-;;)\n");
        fprintf(out0,"\n");
        fprintf(out0,"\n");
        
        fprintf(out0,"module rom(nRST, clk, dout, a, oe, cs);\n");
        fprintf(out0,"\n");
        fprintf(out0,"input nRST;\n");
        fprintf(out0,"input clk;\n");
        fprintf(out0,"output [15:0]  dout;\n");
        fprintf(out0,"input  [16:0]  a;\n");
        fprintf(out0,"input          oe;\n");
        fprintf(out0,"input          cs;\n");
        fprintf(out0,"\n");
        
        fprintf(out0,"wire [15:0]   dout0;\n");
        fprintf(out0,"wire [15:0]   dout1;\n");
        fprintf(out0,"wire [15:0]   dout2;\n");
        
        fprintf(out0,"assign cs0 = (a[16:14]==3'b000)? 1'b0 : 1'b1 ;\n");
        
        fprintf(out0,"assign cs1 = (a[16:14]==3'b001)? 1'b0 : 1'b1 ;\n");
        
        fprintf(out0,"assign cs2 = (a[16:14]==3'b010)? 1'b0 : 1'b1 ;\n");
        
        fprintf(out0,"assign dout = ((oe==0)&&(cs==0)&&(cs0==0))? dout0 :\n");
        fprintf(out0,"              ((oe==0)&&(cs==0)&&(cs1==0))? dout1 :\n");
        fprintf(out0,"              ((oe==0)&&(cs==0)&&(cs2==0))? dout2 :\n");
        fprintf(out0,"              ((oe==0)&&(cs==0))? 16'h0000: 16'bzzzz_zzzz_zzzz_zzzz;\n");
        

        fprintf(out0,"rom0 rom0 (\n");
        fprintf(out0,".nRST(nRST),\n");
        fprintf(out0,".clk(clk),\n");
        fprintf(out0,".dout(dout0),\n");
        fprintf(out0,".a(a[13:0]),\n");
        fprintf(out0,".oe(oe),\n");
        fprintf(out0,".cs(cs0)\n");
        fprintf(out0,");\n");

        
        fprintf(out0,"rom1 rom1 (\n");
        fprintf(out0,".nRST(nRST),\n");
        fprintf(out0,".clk(clk),\n");
        fprintf(out0,".dout(dout1),\n");
        fprintf(out0,".a(a[13:0]),\n");
        fprintf(out0,".oe(oe),\n");
        fprintf(out0,".cs(cs1)\n");
        fprintf(out0,");\n");
        
        fprintf(out0,"rom2 rom2 (\n");
        fprintf(out0,".nRST(nRST),\n");
        fprintf(out0,".clk(clk),\n");
        fprintf(out0,".dout(dout2),\n");
        fprintf(out0,".a(a[13:0]),\n");
        fprintf(out0,".oe(oe),\n");
        fprintf(out0,".cs(cs2)\n");
        fprintf(out0,");\n");

        
        fprintf(out0,"endmodule \n");
                
        
        
        
        
        
        
        
        
        fprintf(out1,"//-------------------------------------------------------\n");
        fprintf(out1,"//--  SDI V5 test rom model for FPGA TEST \n");
        fprintf(out1,"//-------------------------------------------------------\n");
        fprintf(out1,"//--  verilog rom model 16bit\n");
        fprintf(out1,"//--  made by duck (-,.-;;)\n");
        fprintf(out1,"\n");
        fprintf(out1,"\n");

        fprintf(out2,"//-------------------------------------------------------\n");
        fprintf(out2,"//--  SDI V5 test rom model for FPGA TEST \n");
        fprintf(out2,"//-------------------------------------------------------\n");
        fprintf(out2,"//--  verilog rom model 16bit\n");
        fprintf(out2,"//--  made by duck (-,.-;;)\n");
        fprintf(out2,"\n");
        fprintf(out2,"\n");
        
        fprintf(out3,"//-------------------------------------------------------\n");
        fprintf(out3,"//--  SDI V5 test rom model for FPGA TEST \n");
        fprintf(out3,"//-------------------------------------------------------\n");
        fprintf(out3,"//--  verilog rom model 16bit\n");
        fprintf(out3,"//--  made by duck (-,.-;;)\n");
        fprintf(out3,"\n");
        fprintf(out3,"\n");
        
        fprintf(out1,"module rom0(nRST, clk, dout, a, oe, cs);\n");
        fprintf(out1,"\n");
        fprintf(out1,"input nRST;\n");
        fprintf(out1,"input clk;\n");
        fprintf(out1,"output [15:0]  dout;\n");
        fprintf(out1,"input  [13:0]  a;\n");
        fprintf(out1,"input          oe;\n");
        fprintf(out1,"input          cs;\n");
        fprintf(out1,"\n");
        fprintf(out1,"reg    [15:0]  data;\n");
        
        fprintf(out2,"module rom1(nRST, clk, dout, a, oe, cs);\n");
        fprintf(out2,"\n");
        fprintf(out2,"input nRST;\n");
        fprintf(out2,"input clk;\n");
        fprintf(out2,"output [15:0]  dout;\n");
        fprintf(out2,"input  [13:0]  a;\n");
        fprintf(out2,"input          oe;\n");
        fprintf(out2,"input          cs;\n");
        fprintf(out2,"\n");
        fprintf(out2,"reg    [15:0]  data;\n");

        fprintf(out3,"module rom2(nRST, clk, dout, a, oe, cs);\n");
        fprintf(out3,"\n");
        fprintf(out3,"input nRST;\n");
        fprintf(out3,"input clk;\n");
        fprintf(out3,"output [15:0]  dout;\n");
        fprintf(out3,"input  [13:0]  a;\n");
        fprintf(out3,"input          oe;\n");
        fprintf(out3,"input          cs;\n");
        fprintf(out3,"\n");
        fprintf(out3,"reg    [15:0]  data;\n");

        fprintf(out1,"always @(posedge clk or negedge nRST) begin\n");
        fprintf(out1,"if (!nRST) \n");
        fprintf(out1,"  data=16'b0000_0000_0000_0000; \n");
    	fprintf(out1,"else begin\n");
        fprintf(out1,"case(a)  \n");
    
        fprintf(out2,"always @(posedge clk or negedge nRST) begin\n");
        fprintf(out2,"if (!nRST) \n");
        fprintf(out2,"  data=16'b0000_0000_0000_0000; \n");
    	fprintf(out2,"else begin\n");
        fprintf(out2,"case(a)  \n");
    
        fprintf(out3,"always @(posedge clk or negedge nRST) begin\n");
        fprintf(out3,"if (!nRST) \n");
        fprintf(out3,"  data=16'b0000_0000_0000_0000; \n");
    	fprintf(out3,"else begin\n");
        fprintf(out3,"case(a)  \n");
    
    
    
    
        for(i=0;i<44497;i++)
            {   
                if ((i>20) && (i<16405))
                {
                    fscanf(in,"%s",string);
                    fprintf(out1,"       14'd%d : data = 16'h%s; \n",i-21,string);
                }
                else if ((i>16404) && (i<(32789)))
                {
                    fscanf(in,"%s",string);
                    fprintf(out2,"       14'd%d : data = 16'h%s; \n",(i-(16383+22)),string);
                }
                else if (i>(32788))
                {
                    fscanf(in,"%s",string);
                    fprintf(out3,"       14'd%d : data = 16'h%s; \n",(i-32789),string);
                }
                else
                    fscanf(in,"%s",string);
                
                
            }
        fprintf(out1,"   default: data = 16'h0000;\n");
            
        fprintf(out1,"   endcase\n");
        fprintf(out1,"   end\n");
        fprintf(out1,"   end\n");
        fprintf(out1,"assign dout = data;\n");

        fprintf(out1,"endmodule\n");
                            
        fprintf(out2,"   default: data = 16'h0000;\n");
            
        fprintf(out2,"   endcase\n");
        fprintf(out2,"   end\n");
        fprintf(out2,"   end\n");
        fprintf(out2,"assign dout = data;\n");

        fprintf(out2,"endmodule\n");

        fprintf(out3,"   endcase\n");
        fprintf(out3,"   end\n");
        fprintf(out3,"   end\n");
        fprintf(out3,"assign dout = data;\n");

        fprintf(out3,"endmodule\n");
    }
    fclose(in);
    fclose(out1);
    fclose(out2);       
    fclose(out3);    
}
    
