
cmCreateLib
setFormField "Create Library" "Library Name" "TOP"
setFormField "Create Library" "Technology File Name" "../LIB/tsmc18_4lm.tf"
setFormField "Create Library" "Set Case Sensitive" "1"
formOK "Create Library"

cmRefLib
setFormField "Ref Library" "Library Name" "TOP"
setFormField "Ref Library" "Ref Library Name" "tsmc18"
formApply "Ref Library"
setFormField "Ref Library" "Ref Library Name" "tpd973g_usb2"
formOK "Ref Library"

cmShowRefLib
setFormField "Show Ref Libraries" "Library Name" "TOP"
formOK "Show Ref Libraries"

cmItfToTLUPlus
setFormField "Convert ITF to TLU" "Library Name" "TOP"
setFormField "Convert ITF to TLU" "Nom CapTable File" "../LIB/t018s4ml.CapTbl"
setFormField "Convert ITF to TLU" "Nom ITF File" "../LIB/t018s4ml.itf"
setFormField "Convert ITF to TLU" "Star-RCXT Mapping File" "../LIB/map"
formButton "Convert ITF to TLU" "updateMWTech"
formButton "Convert ITF to TLU" "sanityCheck"
formOK "Convert ITF to TLU"

auVerilogIn
setFormField "Verilog In Data File" "Verilog File Name" "../2_syn/TOP_syn.v"
setFormField "Verilog In Data File" "Library Name" "TOP"
setFormField "Verilog In Data File" "Bus Naming Style" "[%d]"
formOK "Verilog In Data File"

cmCmdExpand
setFormField "Expand Netlist" "Library Name" "TOP"
setFormField "Expand Netlist" "Unexpanded Cell Name" "TOP"
setFormField "Expand Netlist" "Expanded Cell Name" "TOP.EXP"
formButton "Expand Netlist" "globalNetOptions"
setFormField "Expand Netlist" "Net Name" "VDD"
setFormField "Expand Netlist" "Port Pattern" "VDD.*"
formButton "Expand Netlist" "apply"
setFormField "Expand Netlist" "Net Name" "VSS"
setFormField "Expand Netlist" "Port Pattern" "VSS.*"
formButton "Expand Netlist" "apply"
subFormHide "Expand Netlist" 1
formOK "Expand Netlist"

geOpenLib
setFormField "Open Library" "Library Name" "TOP"
formOK "Open Library"

geCreateCell
setFormField "Create Cell" "Cell Name" "TOP"
formOK "Create Cell"

axgBindNetlist
setFormField "Bind Netlist" "Net Cell" "TOP.EXP"
formOK "Bind Netlist"

astInitHierPreservation
setFormField "Init Hierarchy Preservation" "Flat Cell Name" "TOP.CEL"
setFormField "Init Hierarchy Preservation" "Hier. Net Cell Name" "TOP.NETL"
formOK "Init Hierarchy Preservation"

astMarkHierAsPreserved
setFormField "Mark Module Instances As Preserved" "Flattened Cell Name" "TOP.CEL"
formOK "Mark Module Instances As Preserved"

aprPGConnect
setFormField "Connect/Disconnect PG" "Net Name" "VDD"
setFormField "Connect/Disconnect PG" "Port Pattern" "VDD.*"
setFormField "Connect/Disconnect PG" "Net Type" "Power"
setFormField "Connect/Disconnect PG" "Update Tie Up/Down" "1"
formApply "Connect/Disconnect PG"
formYes "Dialog Box"
formYes "Dialog Box"
setFormField "Connect/Disconnect PG" "Net Name" "VSS"
setFormField "Connect/Disconnect PG" "Port Pattern" "VSS.*"
setFormField "Connect/Disconnect PG" "Net Type" "Ground"
formOK "Connect/Disconnect PG"
formYes "Dialog Box"
formYes "Dialog Box"

axgPlanner
setFormField "Floor Planning" "Control Parameter" "width & height"
setFormField "Floor Planning" "Core Width" "2000"
setFormField "Floor Planning" "Core Height" "2000"
;setFormField "Floor Planning" "Control Parameter" "aspect ratio"
;setFormField "Floor Planning" "Core Utilization" "0.7"
;setFormField "Floor Planning" "Core Aspect Ratio (H/W)" "1"
setFormField "Floor Planning" "Row/Core Ratio" "1"
setFormField "Floor Planning" "Double Back" "1"
setFormField "Floor Planning" "Start from first row" "1"
setFormField "Floor Planning" "Flip first row" "1"
setFormField "Floor Planning" "Core To Left" "20"
setFormField "Floor Planning" "Core To Right" "20"
setFormField "Floor Planning" "Core To Bottom" "20"
setFormField "Floor Planning" "Core To Top" "20"
formButton "Floor Planning" "Set"
formOK "Floor Planning"

axgCreateRectangularRings
setFormField "Create Rectangular Rings" "Around" "Core"
setFormField "Create Rectangular Rings" "Net Name(s)" "VDD"
setToggleField "Create Rectangular Rings" "Skip Side(s)" "Left" 0
setToggleField "Create Rectangular Rings" "Skip Side(s)" "Right" 0
setToggleField "Create Rectangular Rings" "Skip Side(s)" "Bottom" 0
setToggleField "Create Rectangular Rings" "Skip Side(s)" "Top" 0
setFormField "Create Rectangular Rings" "L-Width" "5"
setFormField "Create Rectangular Rings" "R-Width" "5"
setFormField "Create Rectangular Rings" "T-Width" "5"
setFormField "Create Rectangular Rings" "B-Width" "5"
setFormField "Create Rectangular Rings" "L-Layer" "18"
setFormField "Create Rectangular Rings" "R-Layer" "18"
setFormField "Create Rectangular Rings" "T-Layer" "16"
setFormField "Create Rectangular Rings" "B-Layer" "16"
setFormField "Create Rectangular Rings" "Are" "Absolute"
setFormField "Create Rectangular Rings" "Left" "1"
setFormField "Create Rectangular Rings" "Right" "1"
setFormField "Create Rectangular Rings" "Top" "1"
setFormField "Create Rectangular Rings" "Bottom" "1"
setFormField "Create Rectangular Rings" "Ignore Parallel Targets" "1"
setFormField "Create Rectangular Rings" "Extend for Multiple Connections" "1"
formApply "Create Rectangular Rings"
setFormField "Create Rectangular Rings" "Net Name(s)" "VSS"
setFormField "Create Rectangular Rings" "Left" "10"
setFormField "Create Rectangular Rings" "Right" "10"
setFormField "Create Rectangular Rings" "Top" "10"
setFormField "Create Rectangular Rings" "Bottom" "10"
formOK "Create Rectangular Rings"

hdpClearSDC
formOK "Clear SDC"
ataLoadSDC
setFormField "Load SDC File" "SDC File Name" "TOPfix.sdc"
formOK "Load SDC File"

atTimingSetup
atCmdSetField "Ignore Clock Uncertainty" "0"
atCmdSetField "Ignore Propagated Clock" "1"
atCmdSetField "Set IO Clock Latency" "1"
atCmdSetField "Enable Ideal Network Delay" "1"
atCmdSetField "Enable Gated Clock Checks" "1"
atCmdSetEnvModel 
atTimingSetupGoto "Optimization" 
atCmdSetField "Optimization Max Transition" "0.2"
atCmdSetOptModel 
atTimingSetupGoto "Parasitics" 
atCmdSetField "Parasitic Model Capacitance Model" "tluplus"
;atCmdSetField "Parasitic Model Capacitance Model" "tlu"
atCmdSetParaModel
atTimingSetupGoto "Model" 
atCmdSetField "Delay Model Net Delay Model" "awe"
atCmdSetModels 
atTimingSetupHide 

astReportTiming
setFormField "Report Timing" "Through" "X1/TXREADY"
setFormField "Report Timing" "Output To" "File"
setFormField "Report Timing" "File Name" "timing_output.rpt"
formOK "Report Timing"

astReportTiming
setFormField "Report Timing" "Through" "X1/TXVALID"
setFormField "Report Timing" "Output To" "File"
setFormField "Report Timing" "File Name" "timing_input.rpt"
formOK "Report Timing"

ataDumpSDF
formOK "SDF Write"

astPlaceOptions
setFormField "AstroPlace Options" "Timing Driven" "1"
formOK "AstroPlace Options"

astPlaceDesign
formOK "AstroPlace - Design"

axgDisplayPLTimingMap
formButton "Pre-routing Timing Violation Map" "clear"
setFormField "Pre-routing Timing Violation Map" "threshold" "0.0"
formCancel "Pre-routing Timing Violation Map"

astClockOptions
setFormField "Clock Common Options" "Clock Nets" "CLK"
formOK "Clock Common Options"

astCTS
formOK "Clock Tree Synthesis"

sdc "set_propagated_clock [all_clocks]"

atTimingSetup
atTimingSetupGoto "Environment" 
atCmdSetField "Ignore Clock Uncertainty" "0"
atCmdSetField "Ignore Propagated Clock" "0"
atCmdSetField "Set IO Clock Latency" "0"
atCmdSetField "Enable Ideal Network Delay" "0"
atCmdSetField "Enable Gated Clock Checks" "1"
atCmdSetEnvModel 
atTimingSetupGoto "Model" 
atCmdSetField "Delay Model Net Delay Model" "awe"
atCmdSetModels 
atCmdSetEnvModel 
atTimingSetupHide 

axgAddFillerCell
setFormField "Add Filler Cell" "Master Cell Name(s)" "FILL64, FILL32, FILL16, FILL8, FILL4, FILL2, FILL1"
setFormField "Add Filler Cell" "between std cells only" "1"
formOK "Add Filler Cell"

axSetIntParam "droute" "blockageAsFatWire" 0

axgPrerouteStandardCells
setFormField "Preroute Standard Cells" "Extend to Boundaries and Generate Pins" "1"
setFormField "Preroute Standard Cells" "Extend for Multiple Connections" "1"
formOK "Preroute Standard Cells"

axgSetHPORouteOptions
setFormField "HPO Signal Route Options" "Timing-Driven Spacing" "user nets"
formOK "HPO Signal Route Options"

axgSetRouteOptions
setFormField "Route Common Options" "Skew Control" "1"
setFormField "Route Common Options" "Timing Driven" "1"
setFormField "Route Common Options" "Clock Routing" "balanced"
setFormField "Route Common Options" "Track Assign Timing Driven" "1"
formOK "Route Common Options"

axgRouteGroup
setFormField "Route Net Group" "Net Name(s) From" "All clock nets"
formOK "Route Net Group"

axgAutoRoute
setFormField "Auto Route" "Search & Repair Loop" "1"
setFormField "Auto Route" "Global Route Speed" "slow"
formOK "Auto Route"

geNewFillNG
formOK "New Fill Notch and Gap"

(dbSaveCell (geGetEditCell))

geConfirmCloseLib
formYes "Dialog Box"
formButton "Save Cells" "discardAll"
formOK "Save Cells"

auCreateHierVlogOut
setFormField "Create Hierarchical Verilog Out" "Library Name" "TOP"
setFormField "Create Hierarchical Verilog Out" "Cell Name" "TOP.CEL"
setFormField "Create Hierarchical Verilog Out" "reference Netlist Cell Name" "TOP.NETL"
setFormField "Create Hierarchical Verilog Out" "Output Cell Name" "TOP.HNET"
setFormField "Create Hierarchical Verilog Out" "No Assign Created In Verilog" "1"
formOK "Create Hierarchical Verilog Out"

auHierVerilogOut
setFormField "Hierarchical Verilog Out" "Library Name" "TOP"
setFormField "Hierarchical Verilog Out" "Cell Name" "TOP.HNET"
setFormField "Hierarchical Verilog Out" "Verilog Out Data File" "TOP_apr.v"
setFormField "Hierarchical Verilog Out" "Output Bus As Individual Bits" "0"
setFormField "Hierarchical Verilog Out" "Reference Top NETL Cell to Output Bus" "TOP"
formOK "Hierarchical Verilog Out"

auStreamOut
setFormField "Stream Out Data File" "Stream File Name" "TOP.gds"
setFormField "Stream Out Data File" "Library Name" "TOP"
setFormField "Stream Out Data File" "Layer File" "../LIB/gdsout.map"
setFormField "Stream Out Data File" "Child Extraction Depth" "20"
setFormField "Stream Out Data File" "Convert" "Specified Cell"
setFormField "Stream Out Data File" "Cell Name" "TOP"
setToggleField "Stream Out Data File" "Fill" "FILL" 1
setFormField "Stream Out Data File" "Generate Instance Name As Prop" "1"
setFormField "Stream Out Data File" "Generate Geometry Property" "1"
formButton "Stream Out Data File" "pinNetOptions"
setToggleField "Stream Out Data File" "Output Pins" "As Text" 1
setToggleField "Stream Out Data File" "Output Pins" "As Geometry" 1
setToggleField "Stream Out Data File" "Output Net" "As Text" 1
setToggleField "Stream Out Data File" "Output Net" "As Property" 1
formOK "Stream Out Data File"

exit

