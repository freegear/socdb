# SimVision Command Script (Thu Apr 06 15:59:05 KST 2006)

#
# databases
#
if {[database find -match exact -name "tb_sdc"] == {}} {
    database open /home/sdiv5/test/mbus/Sim/tb_sdc.shm/tb_sdc.trn -name "tb_sdc"
}

#
# mmaps
#
mmap new -reuse -name "Example Map" -contents {
{%b=11???? -bgcolor orange -label REG:%x -linecolor yellow -shape bus}
{%x=1F -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=2C -bgcolor red -label ERROR -linecolor white -shape EVENT}
{%x=* -label %x -linecolor gray -shape bus}
}

#
# Design Browser windows
#
if {[window find -match exact -name "Design Browser 1"] == {}} {
    window new DesignBrowser -name "Design Browser 1" -geometry 888x649+55+50
} else {
    window geometry "Design Browser 1" 888x649+55+50
}
window target "Design Browser 1" on
browser using "Design Browser 1"
browser set \
    -scope {tb_sdc::tb_sdc.sdramif}
browser yview see {tb_sdc::tb_sdc.sdramif}

#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 1203x639+9+0
} else {
    window geometry "Waveform 1" 1203x639+9+0
}
window target "Waveform 1" on
waveform using "Waveform 1"
waveform sidebar visibility partial
waveform set \
    -primarycursor "TimeA" \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
cursor set -using "TimeA" -time 524816.143505ns
waveform baseline set -time 525356.365618ns

set id [waveform add -signals {tb_sdc::tb_sdc.sdramif.b0blk.cbs_idle}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdramif.b0blk.cbs_rasing}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdramif.b0blk.cbs_rowopen}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdramif.b0blk.cbs_casing}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdramif.b0blk.cbs_pcing}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.b0blk.i_bf_reqcmd[5:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.b0blk.BF_CMD[5:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.b0blk.trcd_cnt[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.b0blk.ECMD[6:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.stable_cnt[15:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdramif.b0blk.ERCMD[5:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Status[7:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.clk}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.Busreq}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.Buswr}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.Busrd}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Busadr[21:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Status[0]}}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Busdat[15:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Busdqm[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.Busrdy}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.LatchData1[15:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.Busdato[15:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Cke}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Clk}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Ba[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Addr[10]}}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Addr[11:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Bank[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Row[11:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Col[7:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Cs_n}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Ras_n}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Cas_n}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Dqm[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{tb_sdc::tb_sdc.sdram16bit.Dq[15:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Prech_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Aref_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Mode_reg_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Active_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Write_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {tb_sdc::tb_sdc.sdram16bit.Read_enable}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}

waveform xview limits 524816.143505ns 525356.365618ns

#
# preferences
#
preferences set ams-show-flow {1}
preferences set ams-show-potential {1}
preferences set analog-height {5}
preferences set color-verilog-by-value {1}
preferences set create-cursor-for-new-window {0}
preferences set cv-num-lines {25}
preferences set cv-show-only {1}
preferences set db-scope-gen-compnames {0}
preferences set db-scope-gen-icons {1}
preferences set db-scope-gen-sort {name}
preferences set db-scope-gen-tracksb {0}
preferences set db-scope-systemc-processes {1}
preferences set db-scope-verilog-cells {1}
preferences set db-scope-verilog-functions {1}
preferences set db-scope-verilog-namedbegins {1}
preferences set db-scope-verilog-namedforks {1}
preferences set db-scope-verilog-tasks {1}
preferences set db-scope-vhdl-assertions {1}
preferences set db-scope-vhdl-assignments {1}
preferences set db-scope-vhdl-blocks {1}
preferences set db-scope-vhdl-breakstatements {1}
preferences set db-scope-vhdl-calls {1}
preferences set db-scope-vhdl-generates {1}
preferences set db-scope-vhdl-processstatements {1}
preferences set db-scope-vhdl-unnamedprocesses {1}
preferences set db-show-editbuf {0}
preferences set db-show-modnames {0}
preferences set db-show-values {simulator}
preferences set db-signal-filter-constants {1}
preferences set db-signal-filter-generics {1}
preferences set db-signal-filter-other {1}
preferences set db-signal-filter-quantities {1}
preferences set db-signal-filter-signals {1}
preferences set db-signal-filter-terminals {1}
preferences set db-signal-filter-variables {1}
preferences set db-signal-gen-radix {default}
preferences set db-signal-gen-showdetail {0}
preferences set db-signal-gen-showstrength {0}
preferences set db-signal-gen-sort {name}
preferences set db-signal-show-assertions {1}
preferences set db-signal-show-errorsignals {1}
preferences set db-signal-show-fibers {1}
preferences set db-signal-show-inouts {1}
preferences set db-signal-show-inputs {1}
preferences set db-signal-show-internal {1}
preferences set db-signal-show-live {1}
preferences set db-signal-show-mutexes {1}
preferences set db-signal-show-outputs {1}
preferences set db-signal-show-semaphores {1}
preferences set db-signal-vlogfilter-branches {1}
preferences set db-signal-vlogfilter-memories {1}
preferences set db-signal-vlogfilter-parameters {1}
preferences set db-signal-vlogfilter-registers {1}
preferences set db-signal-vlogfilter-variables {1}
preferences set db-signal-vlogfilter-wires {1}
preferences set default-ams-formatting {potential}
preferences set default-time-units {ns}
preferences set delete-unused-cursors-on-exit {1}
preferences set delete-unused-groups-on-exit {1}
preferences set enable-toolnet {0}
preferences set initial-zoom-out-full {0}
preferences set key-bindings {
	Edit>Undo "Ctrl+Z"
	Edit>Redo "Ctrl+Y"
	Edit>Copy "Ctrl+C"
	Edit>Cut "Ctrl+X"
	Edit>Paste "Ctrl+V"
	Edit>Delete "Del"
	openDB "Ctrl+O"
	View>Zoom>InX "Alt+I"
	View>Zoom>OutX "Alt+O"
	View>Zoom>FullX "Alt+="
	View>Zoom>InX_widget "I"
	View>Zoom>OutX_widget "O"
	View>Zoom>FullX_widget "="
	View>Zoom>Cursor-Baseline "Alt+Z"
	View>Center "Alt+C"
	View>ExpandSequenceTime>AtCursor "Alt+X"
	View>CollapseSequenceTime>AtCursor "Alt+S"
	Edit>Create>Group "Ctrl+G"
	Edit>Ungroup "Ctrl+Shift+G"
	Edit>Create>Marker "Ctrl+M"
	Edit>Create>Condition "Ctrl+E"
	Edit>Create>Bus "Ctrl+W"
	Explore>NextEdge "Ctrl+\]"
	Explore>PreviousEdge "Ctrl+\["
	ScrollRight "Right arrow"
	ScrollLeft "Left arrow"
	ScrollUp "Up arrow"
	ScrollDown "Down arrow"
	PageUp "PageUp"
	PageDown "PageDown"
	TopOfPage "Home"
	BottomOfPage "End"
}
preferences set marching-waveform {1}
preferences set prompt-exit {1}
preferences set prompt-on-reinvoke {1}
preferences set respond-to-simvision-command {1}
preferences set restore-state-on-startup {0}
preferences set save-state-on-startup {0}
preferences set sb-double-click-command {@goto-definition}
preferences set sb-editor-command {xterm -e vi +%L %F}
preferences set sb-history-size {10}
preferences set sb-radix {default}
preferences set sb-show-strength {1}
preferences set sb-syntax-highlight {1}
preferences set sb-syntax-types {
    {-name "VHDL/VHDL-AMS" -cleanname "vhdl" -extensions {.vhd .vhdl}}
    {-name "Verilog/Verilog-AMS" -cleanname "verilog" -extensions {.v .vams .vms .va}}
    {-name "C" -cleanname "c" -extensions {.c}}
    {-name "C++" -cleanname "c++" -extensions {.h .hpp .cc .cpp .CC}}
    {-name "SystemC" -cleanname "systemc" -extensions {.h .hpp .cc .cpp .CC}}
}
preferences set sb-tab-size {8}
preferences set schematic-show-values {simulator}
preferences set search-toolbar {1}
preferences set seq-time-width {30}
preferences set sfb-colors {
    register #beded1
    variable #beded1
    assignStmt gray85
    force #faa385
}
preferences set sfb-default-tree {0}
preferences set sfb-max-cell-width {40}
preferences set show-database-names {0}
preferences set show-full-signal-names {0}
preferences set show-strength {0}
preferences set show-times-on-cursors {1}
preferences set show-times-on-markers {1}
preferences set signal-type-colors {
	group #0000FF
	overlay #0000FF
	input #FFFF00
	output #FFA500
	inout #00FFFF
	internal #00FF00
	fiber #FF99FF
	errorsignal #FF0000
	unknown #FFFFFF
}
preferences set snap-to-edge {1}
preferences set toolbars-style {icon}
preferences set transaction-height {3}
preferences set txe-locate-add-fibers {yes}
preferences set txe-locate-create-waveform {sometimes}
preferences set txe-locate-pop-waveform {yes}
preferences set txe-locate-scroll-x {yes}
preferences set txe-locate-scroll-y {yes}
preferences set txe-man-doubleclick-search {edit}
preferences set txe-navigate-search-locate {no}
preferences set txe-navigate-waveform-locate {yes}
preferences set txe-navigate-waveform-next-child {no}
preferences set txe-search-default-form {built_in.basic}
preferences set txe-search-result-limit {200}
preferences set txe-search-reuse-window {never}
preferences set txe-search-show-linenumbers {yes}
preferences set txe-search-style {form}
preferences set txe-view-hold {off}
preferences set use-signal-type-colors {0}
preferences set use-signal-type-icons {1}
preferences set verilog-colors {
	HiZ #ff9900
	StrX #ff0000
	Sm #00ff99
	Me #0000ff
	We #00ffff
	La #ff00ff
	Pu #9900ff
	St #00ff00
	Su #ff0099
	0 #00ff00
	1 #00ff00
	X #ff0000
	Z #ff9900
	other #ffff00
}
preferences set vhdl-colors {
	U #9900ff 
	X #ff0000 
	0 #00ff00 
	1 #00ff00 
	Z #ff9900 
	W #ff0000
	L #00ffff 
	H #00ffff
	- #0000ff
}
preferences set waveform-banding {1}
preferences set waveform-height {12}
preferences set waveform-space {4}
