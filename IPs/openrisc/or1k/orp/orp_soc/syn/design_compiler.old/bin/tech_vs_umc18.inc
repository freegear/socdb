/* Set Virtual Silicon UMC 0.18u standard cell library */

search_path = {. /libs/Virtual_silicon/UMCL18U250D2_2.1/design_compiler/ /libs/vs_rams/  /usr/dc/libraries/syn/ }
snps = get_unix_variable("SYNOPSYS")
synthetic_library = { \
           snps + "/libraries/syn/dw01.sldb" \
           snps + "/libraries/syn/dw02.sldb" \
           snps + "/libraries/syn/dw03.sldb" \
           snps + "/libraries/syn/dw04.sldb" \
           snps + "/libraries/syn/dw05.sldb" \
           snps + "/libraries/syn/dw06.sldb" \
           snps + "/libraries/syn/dw07.sldb" \
	   snps + "/libraries/syn/dw_foundation.sldb" \
	   snps + "/libraries/syn/standard.sldb" }
target_library = { umcl18u250t2_wc.db \
			vs_hdsp_2048x32_tc_1.2V_25C.db \
			vs_hdsp_2048x8_tc_1.2V_25C.db \
			vs_hdsp_512x20_tc_1.2V_25C.db \
			vs_hdsp_64x14_tc_1.2V_25C.db \
			vs_hdsp_64x22_tc_1.2V_25C.db \
			vs_hdsp_64x24_tc_1.2V_25C.db \
			vs_hdtp_64x32_tc_1.2V_25C.db \
			}
link_library = target_library + synthetic_library
symbol_library = { umcl18u250t2.sdb }

