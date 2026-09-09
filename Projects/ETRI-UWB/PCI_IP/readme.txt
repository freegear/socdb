//
// Copyright by Eureka Technology Inc.
//
// All rights reserved.
//
// ##################################################################
//
// Design release of EP454g6 AHB-PCI bridge
//
// Rev 1.0
//
// ##################################################################
//
// Rev 1.0 release notes.
//
// PCI Bus Arbiter
//
// This design includes PCI bus arbiter.
// The PCI bus arbiter has 9 ports, arb_gnt_b and arb_req_b.
// All 9 ports are available externally. The user is expected to
// connect the req_b and gnt_b signals from the AHB-PCI to one
// of the ports externally outside the core. (Please see tb454.v
// as an example.) This leaves 8 PCI bus request and grant ports
// for the rest of the system.
//
//
// Source Code
//
// Per license agreement, the RTL source code are encrypted.
// However, the top level source code (ep454g6.v) and the design
// template, top454.v, are clear source code for easy reference.
// The lower level modules, if they are encrpted, are fully
// synthesizable and can be simulated with any Verilog simulator.
// They are encrypted only to the extended to prevent reverse
// engineering. Other than that, the RTL source code are fully
// usable by ASIC design software.
//
//
// Test Bench
//
// Please see the following section on " Instruction for running
// system level simulation" on how to use the test bench. This test
// bench is designed by Eureka to test the IP core only. It is not
// designed to test any logic created by the user.
// The test bench consists of the IP core and Bus Functional Models
// (BFM) to model the AHB and PCI bus. The BFM consists of AHB bus
// master devices, slave devices, AHB bus arbiter, PCI master devices
// and PCI target devices.
// These BFM issues transfers to the IP core and test the IP core
// for correct responds. The test bench consists of 2 sections:
// a fixed test sequence and a dynamic test section.
// The fixed test sequence issues a pre-defined test pattern to the
// IP core and check for correct results. The dynamic test section
// generate test patterns dynamically and checks for the correct
// results dynamically. The test bench, especially the dynamic test,
// should not be modified by the user. However, user may create
// its own test bench modeled after the fixed sequence test portion
// of the test bench. The fixed sequence test are in the following
// tasks of the std_mback.v module:
// gen_fixed_test1
// gen_fixed_test2
// gen_fixed_test3
// gen_fixed_test4
// gen_fixed_test10
// gen_fixed_test11
//
// ##################################################################
//
// This release includes the following files:
//
// 1. src/ep454g6.v: RTL code of the ep454-g6 IP core.
// 2. src/pciif.v: submodule used by the ep454-g6.
// 3. src/ab_masb.v: submodule used by the ep454-g6.
// 4. src/ab_slvb.v: submodule used by the ep454-g6.
// 5. src/mbackpci.v: submodule used by the ep454-g6.
// 6. src/tbackpci.v: submodule used by the ep454-g6.
// 7. src/pciarb.v: submodule used by the ep454-g6.
// 8. src/eu_dpramx1.v: submodule used by the ep454-g6.
// 9. src/eu_dpramx2.v: submodule used by the ep454-g6.
// 10. src/ahdlprim.v: submodule used by the ep454-g6.
// 11. src/buf.v: submodule used by the ep454-g6.
// 12. src/top454.v: Top level design template for ep454-g6. This
//	file shows how the ep454-g6 can be used as a module inside
//	a chip level design.
// 13. src/ep454.scrpt: Sample Synopsys synthesis script for ep454g6
// 14. system_test/tb454.v: System level test bench for ep454g6
// 15. system_test/ab_mas_m.v: functional model used by the test bench.
// 16. system_test/ahb_arb.v: functional model used by the test bench.
// 17. system_test/ahbmdevice.v: functional model used by the test bench.
// 18. system_test/ahbslave.v: functional model used by the test bench.
// 19. system_test/boundchk.v: functional model used by the test bench.
// 20. system_test/monitor_bus.v: functional model used by the test bench.
// 21. system_test/monitor_pci.v: functional model used by the test bench.
// 22. system_test/pcimdevice.v: functional model used by the test bench.
// 23. system_test/pcimodel.v: functional model used by the test bench.
// 24. system_test/pcitdevice.v: functional model used by the test bench.
// 25. system_test/std_mback.v: functional model used by the test bench.
// 26. system_test/std_tback.v: functional model used by the test bench.
// 27. system_test/comp_all.do: Sample script for compiling the test bench
//				in Modelsim.
// 28. readme.txt: This file
//
// ######################################################################
//
// Instruction for running system level simulation:
//
// 1. Copy files in the src and system_test sub-directories.
// 2. Simulate the top level test bench in system_test/tb454.
// 3. The tb454 test bench consists of bus functional models in both
//    the PCI bus and AHB bus. In this setup, several bus functional models are
//    simulated together with the IP core. Each bus functional model generates
//    bus accesses that exercise the IP core. The bus functional model also
//    checks the result of each access with the expected results. If any
//    mismatch is found, the model prints error message and stops simulation.
//    If no mismatch if found, simulation continues.
// 4. Bus accesses are generated dynamically within each bus functional
//    model. This test bench runs continueously and ends only if there
//    is an error or simulation is stopped by the user. By running this
//    test bench for a long period of time, every combination of read and
//    write access and different response types can be exercised completely.
// 5. To prevent and detect possible deadlock, the simulation test bench
//    prints the number of access periodically. The access counts should
//    increase with each print out. If the access counts remain unchanged
//    after a long period of time, a deadlock may occur in the bus and
//    the simulation should be stopped and investigate. Deadlock is not
//    expected to happen. If it happens, please contact technical support
//    at Eureka Technology.
//
// ##################################################################
//
// Questions regarding this design release should be directed to:
//
// email: info@eurekatech.com
// tel: +1 650 960 3800
// fax: +1 650 960 3805
// http://www.eurekatech.com
//
// ##################################################################
