/* Enable Verilog HDL preprocessor */
hdlin_enable_vpp = true

/* Set log path */
LOG_PATH = "../log/"

/* Set gate-level netlist path */
GATE_PATH = "../out/"

/* Set RAMS_PATH */
RAMS_PATH = "../../../lib/"

/* Set RTL source path */
RTL_PATH = { "../../../rtl/verilog/", "../../../rtl/verilog/audio/", \
	"../../../rtl/verilog/dbg_interface/", "../../../rtl/verilog/or1200/", \
	"../../../rtl/verilog/mem_if/", "../../../rtl/verilog/ssvga/" }

/* Optimize adders */
synlib_model_map_effort = high
hlo_share_effort = medium
