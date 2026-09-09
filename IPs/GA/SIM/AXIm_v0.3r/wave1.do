onerror {resume}
quietly WaveActivateNextPane {} 0
quietly virtual function -install /Atb_ga_axi -env /Atb_ga_axi { &{/Atb_ga_axi/graddr[13], /Atb_ga_axi/graddr[12], /Atb_ga_axi/graddr[11], /Atb_ga_axi/graddr[10], /Atb_ga_axi/graddr[9], /Atb_ga_axi/graddr[8], /Atb_ga_axi/graddr[7], /Atb_ga_axi/graddr[6], /Atb_ga_axi/graddr[5], /Atb_ga_axi/graddr[4], /Atb_ga_axi/graddr[3] }} ram_addr
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/rstb
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/gwr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/gwaddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/gwsize
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/gwbe
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/gwdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/gwready
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/gwbusy
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/grd
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/graddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ram_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/grsize
add wave -noupdate -format Literal -radix binary /Atb_ga_axi/grbe
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/grdata
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/grvalid
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/grbusy
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/wdata
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/waddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/wsize
add wave -noupdate -divider {AXI read}
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/rstb
add wave -noupdate -color Thistle -format Logic -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/grd
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/graddr
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/grsize
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix binary /Atb_ga_axi/ga_axim/ga_axir/grbe
add wave -noupdate -color Thistle -format Literal -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/grdata
add wave -noupdate -color Thistle -format Logic -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/grvalid
add wave -noupdate -color Thistle -format Logic -itemcolor Thistle -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/grbusy
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARBURST
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARLOCK
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARCACHE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARPROT
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/RREADY
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_idle
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_calc_len
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_rd_cmd
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_rd_data
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/rest_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/rest_lenm1
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/need_wd
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/send_byte
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/addr_dly
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/now_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/burst_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/cmp_4k
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/burst_4k
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/cmp_len_4k
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/acs
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ans
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/dcs
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/ns
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/cs
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_await
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_aidle
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/rest_addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/now_byte
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/next_byte
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/rd_size
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/pre_be
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/part_be
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_ddata
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axir/sm_didle
add wave -noupdate -divider {AXI write}
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/clk
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/rstb
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwr
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwaddr
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwsize
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix binary /Atb_ga_axi/ga_axim/ga_axiw/gwbe
add wave -noupdate -color Orange -format Literal -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwdata
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwready
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/gwbusy
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWBURST
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWLOCK
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWCACHE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWPROT
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WDATA
add wave -noupdate -format Literal -radix binary /Atb_ga_axi/ga_axim/ga_axiw/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/BID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/BRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/BVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/BREADY
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_idle
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_calc_len
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_wr_cmd
add wave -noupdate -color Violet -format Logic -itemcolor Violet -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_wr_resp
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/be_dly
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/data_dly
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/WREADY_dly
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/rest_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/rest_lenm1
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/addr_dly
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/burst_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/cmp_4k
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/cmp_byte
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/burst_4k
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/cmp_len_4k
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/small_wd
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/less_wd
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/send_byte
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/now_len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/ns
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/cs
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/acs
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/ans
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_await
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_aidle
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_didle
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_dpre
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_dprd
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_dsend
add wave -noupdate -color Orange -format Logic -itemcolor Orange -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/sm_dpost
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/send_wd
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/post_t
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/pwvalid
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/dcs_pre_send
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/dcs
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ga_axim/ga_axiw/dns
add wave -noupdate -divider AXI
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWBURST
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWLOCK
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWCACHE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/AWPROT
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/WID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/WLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/WVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/WREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/BID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/BRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/BVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/BREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARBURST
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARLOCK
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARCACHE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/ARPROT
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/RID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/RDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/RRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/RLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/RVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/RREADY
add wave -noupdate -divider {To SSRAM}
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/MEMADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/MEMRDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/MEMWDATA
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/MEMCEn
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/MEMWEn
add wave -noupdate -divider {SRAM_AXI }
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/ACLK
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARESETn
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWBURST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/AWREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/WID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/WDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/WSTRB
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/WLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/WVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/WREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/BID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/BRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/BVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/BREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARADDR
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARLEN
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARSIZE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARBURST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/ARREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/RID
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/RDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/RRESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/RLAST
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/RVALID
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/RREADY
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MEMADDR
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/MEMCEn
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MEMWEn
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MEMRDATA
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MEMWDATA
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/nReadOrWrite
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/nReadOrWrite_P
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Addr_P
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Len_P
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Size_P
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Burst_P
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/ID_P
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/VALID_P
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/StartNewRequest
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MuxedAddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MuxedLen
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MuxedSize
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MuxedBurst
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/MuxedId
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/RealnReadOrWrite
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/CanAcceptMoreRequest
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/StateIsIDLE
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/State
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/NextState
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/StateIsREAD
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/StateIsWRITE
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/StateIsWAIT_RESP
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/SuccessiveRead
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/NextFirstREADCycle
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Id
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Addr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Len
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/BurstLen
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Size
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/IncrSize
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/IncreasedAddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/Burst
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/FirstREADCycle
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/SuccessiveReadCondition
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/DecreaseLen
add wave -noupdate -format Logic -radix hexadecimal /Atb_ga_axi/IntSRAMController/NextAddrCalcEn
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/PrevAddr
add wave -noupdate -format Literal -radix hexadecimal /Atb_ga_axi/IntSRAMController/WrapMask
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1530882 ps} 0}
configure wave -namecolwidth 192
configure wave -valuecolwidth 108
configure wave -justifyvalue left
configure wave -signalnamewidth 2
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
update
WaveRestoreZoom {1418908 ps} {1710102 ps}
