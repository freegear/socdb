# SimVision Command Script (Thu May 31 13:35:03 KST 2007)

#
# databases
#
if {[database find -match exact -name "RTC"] == {}} {
    database open /LDisk/HomeM4P1/kwoly/Project/RTC/Verilog/Sim/RTC.shm/RTC.trn -name "RTC"
}

#
# groups
#

if {[group find -match exact -name "Time"] == {}} {
    group new -name "Time" -overlay 0
} else {
    group using "Time"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {RTC::tb.Top.RTCCore.SecCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.SecCnt1[2:0]} \
    {RTC::tb.Top.RTCCore.MinCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.MinCnt1[2:0]} \
    {RTC::tb.Top.RTCCore.HourCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.HourCnt1[2:0]} \
    {RTC::tb.Top.RTCCore.HourCnt2} \
    {RTC::tb.Top.RTCCore.DayCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.DayCnt1[1:0]} \
    {RTC::tb.Top.RTCCore.MonCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.MonCnt1} \
    {RTC::tb.Top.RTCCore.YearCnt0[3:0]} \
    {RTC::tb.Top.RTCCore.YearCnt1[3:0]}

if {[group find -match exact -name "al_setting"] == {}} {
    group new -name "al_setting" -overlay 0
} else {
    group using "al_setting"
    group set -overlay 0
    group clear 0 end
}
group insert \
    {RTC::tb.Top.RTCCore.AL_DAY0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_DAY1[1:0]} \
    {RTC::tb.Top.RTCCore.AL_HOUR0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_HOUR1[2:0]} \
    {RTC::tb.Top.RTCCore.AL_MIN0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_MIN1[2:0]} \
    {RTC::tb.Top.RTCCore.AL_MON0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_MON1} \
    {RTC::tb.Top.RTCCore.AL_PMAM} \
    {RTC::tb.Top.RTCCore.AL_SEC0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_SEC1[2:0]} \
    {RTC::tb.Top.RTCCore.AL_YEAR0[3:0]} \
    {RTC::tb.Top.RTCCore.AL_YEAR1[3:0]}

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
    window new DesignBrowser -name "Design Browser 1" -geometry 700x500+202+221
} else {
    window geometry "Design Browser 1" 700x500+202+221
}
window target "Design Browser 1" on
browser using "Design Browser 1"
browser set \
    -scope {RTC::tb}
browser yview see {RTC::tb}

#
# Waveform windows
#
if {[window find -match exact -name "Waveform 1"] == {}} {
    window new WaveWindow -name "Waveform 1" -geometry 1272x936+4+23
} else {
    window geometry "Waveform 1" 1272x936+4+23
}
window target "Waveform 1" on
waveform using "Waveform 1"
waveform sidebar select designbrowser
waveform set \
    -primarycursor "TimeA" \
    -signalnames name \
    -signalwidth 216 \
    -units ns \
    -valuewidth 72
cursor set -using "TimeA" -time 1,331,575,905,315ps
waveform baseline set -time 2,902,600ps

set id [waveform add -signals {RTC::tb.Top.RTCCore.IntTimer2APB}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCCore.CLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set groupId [waveform add -groups {"Time"}]
foreach id [waveform hierarchy contents $groupId] attrs {
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %x -trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
} {
    eval waveform format $id $attrs
}
waveform hierarchy collapse $groupId

set groupId [waveform add -groups {"al_setting"}]
foreach id [waveform hierarchy contents $groupId] attrs {
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-radix %b -trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
    {-trace digital -color #00ff00 -symbol {}}
} {
    eval waveform format $id $attrs
}
waveform hierarchy collapse $groupId

set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_YEAR1[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_YEAR0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.RD_MON1}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_MON0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_DAY1[1:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_DAY0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_WEEK[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.RD_PMAM}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_HOUR1[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_HOUR0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_MIN1[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_MIN0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_SEC1[2:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {{RTC::tb.Top.RTCAPBinterface.RD_SEC0[3:0]}}]
waveform format $id -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCCore.CLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.PCLK}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.IntAlarm2APB}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.IntTimer2APB}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCCore.ALARM}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.rALARM}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.SECchangeEdge}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.FirstChAlarm_32K}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.ALARM}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}
set id [waveform add -signals {RTC::tb.Top.RTCAPBinterface.IntAlarm_32K}]
waveform format $id -radix %b -trace digital -color #00ff00 -symbol {}

waveform xview limits 1301783999.51ns 1301783999.52ns

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
