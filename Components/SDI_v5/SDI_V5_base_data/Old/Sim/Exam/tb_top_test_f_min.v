`timescale 1ns/10ps

module tb_top_test_min_f;

reg areset_pad, sys_2mfp19m_pad, sys_fp_19m_pad, sys_19mclk_pad, sys_fp_51m_pad;
reg sys_51mclk_pad, wn_lpl_tupp_pad, wn_lc1j1v1_tupp_pad, wn_rclk_19m_nond_pad;
reg en_lpl_tupp_pad, en_lc1j1v1_tupp_pad, en_rclk_19m_nond_pad, wh_lpl_tupp_pad;
reg wh_lc1j1v1_tupp_pad, wh_rclk_19m_nond_pad, eh_lpl_tupp_pad, eh_lc1j1v1_tupp_pad;
reg eh_rclk_19m_nond_pad, rfp_add_19m_pad, rclk_add_19m_pad, afp_6m_a_pad, aclk_6m_a_pad;
reg afp_6m_b_pad, aclk_6m_b_pad, afp_6m_c_pad, aclk_6m_c_pad, asic_csb_pad;
reg wdb_pad, rdb_pad;

reg [7:0] wn_rpd_tupp_pad, en_rpd_tupp_pad, wh_rpd_tupp_pad, eh_rpd_tupp_pad;
reg [7:0] rpd_add_19m_pad, au3_ad_a_pad, au3_ad_b_pad, au3_ad_c_pad;
reg [10:0] address_pad;

reg [7:0] micro_data_sig;
reg clk51m_tmp;
reg rd_control_delay;

reg wn_rclk_19m_pad, en_rclk_19m_pad, wh_rclk_19m_pad, eh_rclk_19m_pad, rclk_add_19m_nond_pad;


wire wn_fp_out_pad, wn_tclk_out_pad, en_fp_out_pad, en_tclk_out_pad;
wire wh_fp_out_pad, wh_tclk_out_pad, eh_fp_out_pad, eh_tclk_out_pad; 
wire dfp_19m_out_pad, dclk_19m_out_pad, dpd_parity_out_pad, dfp_a_6m_out_pad; 
wire dclk_a_6m_out_pad, dau3_a_parity_out_pad, dfp_b_6m_out_pad; 
wire dclk_b_6m_out_pad, dau3_b_parity_out_pad, dfp_c_6m_out_pad, dclk_c_6m_out_pad;
wire dau3_c_parity_out_pad;

wire [7:0] wn_tpd_out_pad, en_tpd_out_pad, wh_tpd_out_pad, eh_tpd_out_pad, dpd_19m_out_pad;
wire [7:0] dau3_a_6m_out_pad, dau3_b_6m_out_pad, dau3_c_6m_out_pad;
wire [7:0] micro_data_pad; 

reg rd_control;

//reg [112:1] sungmi_in_data[0:361380];
reg [112:0] sungmi_in_data[0:488888];
integer N;


`define CYCLE2 2
`define CYCLE3 3
`define CYCLE4 4
`define CYCLE5 5
`define CYCLE8 8
`define CYCLE 9
`define CYCLE10 10
`define CYCLE12 12
`define CYCLE15 15
`define CYCLE17 17
`define CYCLE18 18


initial
begin
#`CYCLE2
        forever #(`CYCLE)
          begin
              rd_control_delay = rd_control;
          end
end

initial
begin
#`CYCLE3
        forever #(`CYCLE)
          begin
              wn_rclk_19m_pad = wn_rclk_19m_nond_pad;
              en_rclk_19m_pad = en_rclk_19m_nond_pad;
              wh_rclk_19m_pad = wh_rclk_19m_nond_pad;
              eh_rclk_19m_pad = eh_rclk_19m_nond_pad;
              rclk_add_19m_pad = rclk_add_19m_nond_pad;
          end
end

assign micro_data_pad = rd_control_delay ? micro_data_sig : 8'bzzzzzzzz ;
//assign micro_data_pad = rd_control ? micro_data_sig : 8'bzzzzzzzz ;
//assign micro_data_pad = rdb_pad ? micro_data_sig : 8'bzzzzzzzz ;
//assign micro_data_pad = rd_control ? micro_data_sig : 8'bzzzzzzzz ;

top_test_pad U0(
        .areset_pad(areset_pad),
        .sys_2mfp19m_pad(sys_2mfp19m_pad),
        .sys_fp_19m_pad(sys_fp_19m_pad),
        .sys_19mclk_pad(sys_19mclk_pad),
        .sys_fp_51m_pad(sys_fp_51m_pad),
        .sys_51mclk_pad(sys_51mclk_pad),
        .wn_lpl_tupp_pad(wn_lpl_tupp_pad),
        .wn_lc1j1v1_tupp_pad(wn_lc1j1v1_tupp_pad),
        .wn_rpd_tupp_pad(wn_rpd_tupp_pad),
        .wn_rclk_19m_pad(wn_rclk_19m_pad),
        .en_lpl_tupp_pad(en_lpl_tupp_pad),
        .en_lc1j1v1_tupp_pad(en_lc1j1v1_tupp_pad),
        .en_rpd_tupp_pad(en_rpd_tupp_pad),
        .en_rclk_19m_pad(en_rclk_19m_pad),
        .wh_lpl_tupp_pad(wh_lpl_tupp_pad),
        .wh_lc1j1v1_tupp_pad(wh_lc1j1v1_tupp_pad),
        .wh_rpd_tupp_pad(wh_rpd_tupp_pad),
        .wh_rclk_19m_pad(wh_rclk_19m_pad),
        .eh_lpl_tupp_pad(eh_lpl_tupp_pad),
        .eh_lc1j1v1_tupp_pad(eh_lc1j1v1_tupp_pad),
        .eh_rpd_tupp_pad(eh_rpd_tupp_pad),
        .eh_rclk_19m_pad(eh_rclk_19m_pad),
        .rfp_add_19m_pad(rfp_add_19m_pad),
        .rpd_add_19m_pad(rpd_add_19m_pad),
        .rclk_add_19m_pad(rclk_add_19m_pad),
        .afp_6m_a_pad(afp_6m_a_pad),
        .au3_ad_a_pad(au3_ad_a_pad),
        .aclk_6m_a_pad(aclk_6m_a_pad),
        .afp_6m_b_pad(afp_6m_b_pad),
        .au3_ad_b_pad(au3_ad_b_pad),
        .aclk_6m_b_pad(aclk_6m_b_pad),
        .afp_6m_c_pad(afp_6m_c_pad),
        .au3_ad_c_pad(au3_ad_c_pad),
        .aclk_6m_c_pad(aclk_6m_c_pad),
        .asic_csb_pad(asic_csb_pad),
        .address_pad(address_pad),
        .wdb_pad(wdb_pad),
        .rdb_pad(rdb_pad),
        .wn_fp_out_pad(wn_fp_out_pad),
        .wn_tpd_out_pad(wn_tpd_out_pad),
        .wn_tclk_out_pad(wn_tclk_out_pad),
        .en_fp_out_pad(en_fp_out_pad),
        .en_tpd_out_pad(en_tpd_out_pad),
        .en_tclk_out_pad(en_tclk_out_pad),
        .wh_fp_out_pad(wh_fp_out_pad),
        .wh_tpd_out_pad(wh_tpd_out_pad),
        .wh_tclk_out_pad(wh_tclk_out_pad),
        .eh_fp_out_pad(eh_fp_out_pad),
        .eh_tpd_out_pad(eh_tpd_out_pad),
        .eh_tclk_out_pad(eh_tclk_out_pad),
        .dfp_19m_out_pad(dfp_19m_out_pad),
        .dpd_19m_out_pad(dpd_19m_out_pad),
        .dclk_19m_out_pad(dclk_19m_out_pad),
        .dpd_parity_out_pad(dpd_parity_out_pad),
        .dfp_a_6m_out_pad(dfp_a_6m_out_pad),
        .dau3_a_6m_out_pad(dau3_a_6m_out_pad),
        .dclk_a_6m_out_pad(dclk_a_6m_out_pad),
        .dau3_a_parity_out_pad(dau3_a_parity_out_pad),
        .dfp_b_6m_out_pad(dfp_b_6m_out_pad),
        .dau3_b_6m_out_pad(dau3_b_6m_out_pad),
        .dclk_b_6m_out_pad(dclk_b_6m_out_pad),
        .dau3_b_parity_out_pad(dau3_b_parity_out_pad),
        .dfp_c_6m_out_pad(dfp_c_6m_out_pad),
        .dau3_c_6m_out_pad(dau3_c_6m_out_pad),
        .dclk_c_6m_out_pad(dclk_c_6m_out_pad),
        .dau3_c_parity_out_pad(dau3_c_parity_out_pad),
        .micro_data_pad(micro_data_pad)
);

initial
begin
areset_pad = 0;
sys_2mfp19m_pad = 0;
sys_fp_19m_pad = 0;
sys_19mclk_pad = 0;
sys_fp_51m_pad = 0;
sys_51mclk_pad = 0;
wn_lpl_tupp_pad = 0;
wn_lc1j1v1_tupp_pad = 0;
wn_rpd_tupp_pad = 'b00000000;
wn_rclk_19m_nond_pad = 0;
en_lpl_tupp_pad = 0;
en_lc1j1v1_tupp_pad = 0;
en_rpd_tupp_pad = 'b00000000;
en_rclk_19m_nond_pad = 0;
wh_lpl_tupp_pad = 0;
wh_lc1j1v1_tupp_pad = 0;
wh_rpd_tupp_pad = 'b00000000;
wh_rclk_19m_nond_pad = 0;
eh_lpl_tupp_pad = 0;
eh_lc1j1v1_tupp_pad = 0;
eh_rpd_tupp_pad = 'b00000000;
eh_rclk_19m_nond_pad = 0;
rfp_add_19m_pad = 0;
rpd_add_19m_pad = 'b00000000;
rclk_add_19m_nond_pad = 0;
afp_6m_a_pad = 0;
au3_ad_a_pad = 'b00000000;
aclk_6m_a_pad = 0;
afp_6m_b_pad = 0;
au3_ad_b_pad = 'b00000000;
aclk_6m_b_pad = 0;
afp_6m_c_pad = 0;
au3_ad_c_pad = 'b00000000;
aclk_6m_c_pad = 0;
asic_csb_pad = 1;
address_pad = 'b00000000000;
micro_data_sig = 'b00000000;
wdb_pad = 1;
rdb_pad = 1;

clk51m_tmp = 0;

end




initial
begin
        #(`CYCLE*488888)
        $finish;
end

always
begin
//        #(`CYCLE/2) clk51m_tmp=~clk51m_tmp;

        #(`CYCLE4)  clk51m_tmp=~clk51m_tmp;
        #(`CYCLE5)  clk51m_tmp=~clk51m_tmp;
end

initial
begin
//       $readmemb("top_test1_input.lst", sungmi_in_data);
//       $readmemb("./fff3", sungmi_in_data);
//       for (N=0 ; N<=361380 ; N=N+1)
       $readmemb("./vhdlinput_mic", sungmi_in_data);
       for (N=0 ; N<=488888 ; N=N+1)
  	 @(negedge clk51m_tmp)
         {areset_pad, sys_2mfp19m_pad, sys_fp_19m_pad, sys_19mclk_pad, sys_fp_51m_pad,
	  sys_51mclk_pad, wn_lpl_tupp_pad, wn_lc1j1v1_tupp_pad, wn_rpd_tupp_pad, 
	  wn_rclk_19m_nond_pad, en_lpl_tupp_pad, en_lc1j1v1_tupp_pad, en_rpd_tupp_pad, 
	  en_rclk_19m_nond_pad, wh_lpl_tupp_pad, wh_lc1j1v1_tupp_pad, wh_rpd_tupp_pad, 
	  wh_rclk_19m_nond_pad, eh_lpl_tupp_pad, eh_lc1j1v1_tupp_pad, eh_rpd_tupp_pad,
	  eh_rclk_19m_nond_pad, rfp_add_19m_pad, rpd_add_19m_pad, rclk_add_19m_nond_pad, 
	  afp_6m_a_pad, au3_ad_a_pad, aclk_6m_a_pad, afp_6m_b_pad, au3_ad_b_pad,
	  aclk_6m_b_pad, afp_6m_c_pad, au3_ad_c_pad, aclk_6m_c_pad, asic_csb_pad, 
	  address_pad,
	  micro_data_sig, 
	  wdb_pad, rdb_pad, rd_control
	 } = sungmi_in_data[N];
       $stop;
end

initial
begin
//	$sdf_annotate("./top_test_pad.sdf","U0");
	$sdf_annotate("/incarray/sungmi/FLC/post_sim/top_test_pad_bst.SDF","U0");

	$shm_open("./top_test_min_fin.shm");
//	$shm_probe("AS");
	$shm_probe(U0,"A");
	$shm_probe(U0.u_core.u80,"AS");
end

integer test_out;
initial
begin
        test_out = $fopen("top_test_min_f.out");
end
initial begin
#`CYCLE17
        forever #(`CYCLE18)
                begin
//                $fstrobe(test_out,"%10.1f %b %b %b", $realtime, areset_pad, sys_fp_19m_pad, wn_rpd_tupp_pad);
                $fstrobe(test_out,"%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b",
			 areset_pad, sys_2mfp19m_pad, sys_fp_19m_pad,
			 sys_19mclk_pad, sys_fp_51m_pad, sys_51mclk_pad, wn_lpl_tupp_pad,
			 wn_lc1j1v1_tupp_pad, wn_rpd_tupp_pad, wn_rclk_19m_pad, en_lpl_tupp_pad,
			 en_lc1j1v1_tupp_pad, en_rpd_tupp_pad, en_rclk_19m_pad, wh_lpl_tupp_pad,
			 wh_lc1j1v1_tupp_pad, wh_rpd_tupp_pad, wh_rclk_19m_pad, eh_lpl_tupp_pad,
			 eh_lc1j1v1_tupp_pad, eh_rpd_tupp_pad, eh_rclk_19m_pad, rfp_add_19m_pad,
			 rpd_add_19m_pad, rclk_add_19m_pad, afp_6m_a_pad, au3_ad_a_pad,
			 aclk_6m_a_pad, afp_6m_b_pad, au3_ad_b_pad, aclk_6m_b_pad, afp_6m_c_pad,
			 au3_ad_c_pad, aclk_6m_c_pad, asic_csb_pad, address_pad, wdb_pad, rdb_pad,

			 wn_fp_out_pad, wn_tpd_out_pad, wn_tclk_out_pad, en_fp_out_pad,
			 en_tpd_out_pad, en_tclk_out_pad, wh_fp_out_pad, wh_tpd_out_pad,
			 wh_tclk_out_pad, eh_fp_out_pad, eh_tpd_out_pad, eh_tclk_out_pad,
			 dfp_19m_out_pad, dpd_19m_out_pad, dclk_19m_out_pad, dpd_parity_out_pad,
			 dfp_a_6m_out_pad, dau3_a_6m_out_pad, dclk_a_6m_out_pad, dau3_a_parity_out_pad,
			 dfp_b_6m_out_pad, dau3_b_6m_out_pad, dclk_b_6m_out_pad, dau3_b_parity_out_pad,
			 dfp_c_6m_out_pad, dau3_c_6m_out_pad, dclk_c_6m_out_pad, dau3_c_parity_out_pad,
			 U0.u_core.rd_dout, U0.u_core.rd_control);
                end
end

integer test_out_input;
initial
begin 
        test_out_input = $fopen("top_test_min_f_input.out");
end
initial begin
//        #(`CYCLE/2)
#`CYCLE3
        forever #(`CYCLE)
                begin
//                $fstrobe(test_out,"%10.1f %b %b %b", $realtime, areset_pad, sys_fp_19m_pad, wn_rpd_tupp_pad);
                $fstrobe(test_out_input,"%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b",
                         areset_pad, sys_2mfp19m_pad, sys_fp_19m_pad,
                         sys_19mclk_pad, sys_fp_51m_pad, sys_51mclk_pad, wn_lpl_tupp_pad,
                         wn_lc1j1v1_tupp_pad, wn_rpd_tupp_pad, wn_rclk_19m_pad, en_lpl_tupp_pad,
                         en_lc1j1v1_tupp_pad, en_rpd_tupp_pad, en_rclk_19m_pad, wh_lpl_tupp_pad,
                         wh_lc1j1v1_tupp_pad, wh_rpd_tupp_pad, wh_rclk_19m_pad, eh_lpl_tupp_pad,
                         eh_lc1j1v1_tupp_pad, eh_rpd_tupp_pad, eh_rclk_19m_pad, rfp_add_19m_pad, 
                         rpd_add_19m_pad, rclk_add_19m_pad, afp_6m_a_pad, au3_ad_a_pad,
                         aclk_6m_a_pad, afp_6m_b_pad, au3_ad_b_pad, aclk_6m_b_pad, afp_6m_c_pad,
                         au3_ad_c_pad, aclk_6m_c_pad, asic_csb_pad, address_pad, wdb_pad, rdb_pad );
                end
end

integer test_out_output;
initial
begin
        test_out_output = $fopen("top_test_min_f_output.out");
end
initial begin
//        #(`CYCLE/2)
#`CYCLE17
        forever #(`CYCLE18)
                begin
//                $fstrobe(test_out,"%10.1f %b %b %b", $realtime, areset_pad, sys_fp_19m_pad, wn_rpd_tupp_pad);
//                $fstrobe(test_out_output,"%10.1f %b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b",
                $fstrobe(test_out_output,"%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b%b",

//                         $realtime, wn_fp_out_pad, wn_tpd_out_pad, wn_tclk_out_pad, en_fp_out_pad,
                         wn_fp_out_pad, wn_tpd_out_pad, wn_tclk_out_pad, en_fp_out_pad,
                         en_tpd_out_pad, en_tclk_out_pad, wh_fp_out_pad, wh_tpd_out_pad,
                         wh_tclk_out_pad, eh_fp_out_pad, eh_tpd_out_pad, eh_tclk_out_pad,
                         dfp_19m_out_pad, dpd_19m_out_pad, dclk_19m_out_pad, dpd_parity_out_pad,
                         dfp_a_6m_out_pad, dau3_a_6m_out_pad, dclk_a_6m_out_pad, dau3_a_parity_out_pad,
                         dfp_b_6m_out_pad, dau3_b_6m_out_pad, dclk_b_6m_out_pad, dau3_b_parity_out_pad,
                         dfp_c_6m_out_pad, dau3_c_6m_out_pad, dclk_c_6m_out_pad, dau3_c_parity_out_pad,
                         micro_data_pad);
//                         U0.u_core.rd_dout); // U0.u_core.rd_control);   //, U0.u_core.micro_din);
                end
end

endmodule
