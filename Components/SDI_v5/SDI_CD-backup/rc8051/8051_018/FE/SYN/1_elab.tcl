sh rm -r  syn_lib
sh mkdir  syn_lib

define_design_lib syn_lib -path "./syn_lib"


 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/BIST/BIST_LOGIC/SPSRAM256X8_rb.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/BIST/BIST_LOGIC/SPSRAM256X8_wrapper.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/BIST/BIST_LOGIC/SPSRAM256X8_top.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/UDIV8x8.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/acc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/adc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/alu_flag_d_m.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/b.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/da.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/dimod.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/div.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/dptr.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/ex_int_smpl.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/gpio0.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/gpio1.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/gpio2.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/gpio3.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/ie.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/ip.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/mul.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/mux16t1_8.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/mux2t1_1.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/one_shot.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/page_addr.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/parity_gen.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/pc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/priority.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/psw.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/rc8051RtlTop.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/rl.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/rlc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/rr.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/rrc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/sel_al.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/sel_arth.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/sign.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/sp.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/swap.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/tcon.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/tmod.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_alu.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/DW_mult_pipe.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_con.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_cpu.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_datapath.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_int.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_sfr.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_tc.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/u_uart.v
 analyze -format verilog -lib syn_lib /user/cklee/PRJ/8051_018/FE/SRC/xchd.v

#read_db /user/cklee/PRJ/8051_018/FE/SYN//ELAB_DB/DW_mult_pipe_a_width8_b_width8_num_stages5.db
elaborate -work syn_lib rc8051RtlTop

current_design rc8051RtlTop
link

current_design rc8051RtlTop
#sh rm -r ELAB_DB
#sh mkdir ./ELAB_DB
write -f db -hierarchy -o ./ELAB_DB/rc8051_elab.db
sh rm -rf syn_lib
exit


