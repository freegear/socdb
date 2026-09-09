# SimVision Command Script (Wed May 09 10:50:13 KST 2007)

#
# databases
#
if {[database find -match exact -name "TestDM_A"] == {}} {
    database open /home/admin/Project/HDC/Sim/TestDM_A.shm/TestDM_A.trn -name "TestDM_A"
}

#
# groups
#

if {[group find -match exact -name "Internal sram"] == {}} {
    group new -name "Internal sram" -overlay 0
} else {
    group using "Internal sram"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {TestDM_A::tb.VideoMem.RDATA[31:0]} \
    {TestDM_A::tb.VideoMem.RVALID} \
    {TestDM_A::tb.VideoMem.RLAST} \
    {TestDM_A::tb.TestDMTop.TestDM.DATAin[15:0]} \
    {TestDM_A::tb.TestDMTop.TestDM.HD_MODE[1:0]} \
    {TestDM_A::tb.VideoMem.MEMADDR[29:0]} \
    {TestDM_A::tb.VIDEOEnC_SRAM32bit.ADDR[29:0]} \
    {TestDM_A::tb.VIDEOEnC_SRAM32bit.RDATA[31:0]} \
    {TestDM_A::tb.VIDEOEnC_SRAM32bit.CEn} \
    {TestDM_A::tb.VIDEOEnC_SRAM32bit.WEn[3:0]}

if {[group find -match exact -name "Input timing"] == {}} {
    group new -name "Input timing" -overlay 0
} else {
    group using "Input timing"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {TestDM_A::tb.HDCTop.BLANKn} \
    {TestDM_A::tb.HDCTop.Rin[7:0]} \
    {TestDM_A::tb.HDCTop.Gin[7:0]} \
    {TestDM_A::tb.HDCTop.Bin[7:0]} \
    {TestDM_A::tb.HDCTop.VSYNCn} \
    {TestDM_A::tb.HDCTop.HSYNCn}

if {[group find -match exact -name "Group 2"] == {}} {
    group new -name "Group 2" -overlay 0
} else {
    group using "Group 2"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {TestDM_A::tb.HDCTop.HDCCore.ACT_DISPLAY_SYN} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.Rin[7:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.Gin[7:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.Bin[7:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.wY[18:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.wPr[18:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCRGB2YPbPr.wPb[18:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.Y[9:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.Pb[9:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.Pr[9:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCTimerGen.H_SET} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCTimerGen.H_CNT[11:0]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCTimerGen.V_CNT[10:0]}

if {[group find -match exact -name "Group 3"] == {}} {
    group new -name "Group 3" -overlay 0
} else {
    group using "Group 3"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[8]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[9]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[10]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[11]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[12]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[13]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[14]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[15]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[16]} \
    {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.SatuYMul[17]}

if {[group find -match exact -name "Group 4"] == {}} {
    group new -name "Group 4" -overlay 0
} else {
    group using "Group 4"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {TestDM_A::tb.OUT_DAC0} \
    {TestDM_A::tb.OUT_DAC1} \
    {TestDM_A::tb.OUT_DAC2}

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
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 1280x944+-4+-4
} else {
    window geometry "Waveform 1" 1280x944+-4+-4
}
window target "Waveform 1" on
waveform using "Waveform 1"
waveform sidebar select designbrowser
waveform set \
    -primarycursor "TimeA" \
    -signalnames name \
    -signalwidth 175 \
    -units ns \
    -valuewidth 75
cursor set -using "TimeA" -time 585,510ps
waveform baseline set -time 780,680ps

set id [waveform add -signals {TestDM_A::tb.TestDMTop.ACLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {TestDM_A::tb.TestDMTop.CLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{TestDM_A::tb.TestDMTop.TestDM.Vcnt[11:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set groupId [waveform add -groups {"Input timing"}]
foreach id [waveform hierarchy contents $groupId] attrs {
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
} {
    eval waveform format $id $attrs
}
waveform hierarchy collapse $groupId

set groupId [waveform add -groups {"Group 2"}]
foreach id [waveform hierarchy contents $groupId] attrs {
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %d -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-radix %d -trace digital -color #00ff00 -symbol {}}
    {-radix %d -trace digital -color #00ff00 -symbol {}}
} {
    eval waveform format $id $attrs
}
waveform hierarchy collapse $groupId

set id [waveform add -signals {TestDM_A::tb.HDCTop.HDCCore.HDCOutGen.ACT_DISPLAY_SYN_7d}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set groupId [waveform add -groups {"Group 4"}]
foreach id [waveform hierarchy contents $groupId] attrs {
    {-radix %d -height 106 -trace analogLinear -color #ffff00 -symbol {}}
    {-radix %d -height 116 -trace analogLinear -color #ffff00 -symbol {}}
    {-radix %d -height 118 -trace analogLinear -color #ffff00 -symbol {}}
} {
    eval waveform format $id $attrs
}
waveform hierarchy collapse $groupId

set id [waveform add -signals {TestDM_A::tb.ClockVideo}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}

waveform xview limits 0 5519178.78ns

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
preferences set default-time-units {ar}
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
        Select>All "Ctrl+A"
        Edit>Select>All "Ctrl+A"
        Edit>SelectAll "Ctrl+A"
      	openDB "Ctrl+O"
        Simulation>Run "F2"
        Simulation>Next "F6"
        Simulation>Step "F5"
        #Schematic window
        View>Zoom>Fit "Alt+="
        View>Zoom>In "Alt+I"
        View>Zoom>Out "Alt+O"
        #Waveform Window
	View>Zoom>InX "Alt+I"
	View>Zoom>OutX "Alt+O"
	View>Zoom>FullX "Alt+="
	View>Zoom>InX_widget "I"
	View>Zoom>OutX_widget "O"
	View>Zoom>FullX_widget "="
	View>Zoom>FullY_widget "Y"
	View>Zoom>Cursor-Baseline "Alt+Z"
	View>Center "Alt+C"
	View>ExpandSequenceTime>AtCursor "Alt+X"
	View>CollapseSequenceTime>AtCursor "Alt+S"
	Edit>Create>Group "Ctrl+G"
	Edit>Ungroup "Ctrl+Shift+G"
	Edit>Create>Marker "Ctrl+M"
	Edit>Create>Condition "Ctrl+E"
	Edit>Create>Bus "Ctrl+W"
	Explore>NextEdge "Ctrl+]"
	Explore>PreviousEdge "Ctrl+["
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
	assertion #FF0000
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
	St ""
	Su #ff0099
	0 ""
	1 ""
	X #ff0000
	Z #ff9900
	other #ffff00
}
preferences set vhdl-colors {
	U #9900ff 
	X #ff0000 
	0 ""
	1 ""
	Z #ff9900 
	W #ff0000
	L #00ffff 
	H #00ffff
	- ""
}
preferences set waveform-banding {1}
preferences set waveform-height {10}
preferences set waveform-space {2}
