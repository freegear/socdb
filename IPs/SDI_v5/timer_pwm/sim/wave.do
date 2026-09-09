onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_timer_pwm/PRESETn
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/PADDR
add wave -noupdate -format Logic /tb_timer_pwm/PWRITE
add wave -noupdate -format Logic /tb_timer_pwm/PSEL
add wave -noupdate -format Logic /tb_timer_pwm/PENABLE
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/PWDATA
add wave -noupdate -format Logic -height 18 /tb_timer_pwm/U0_APB_Timers_EXA0/TEN
add wave -noupdate -format Literal /tb_timer_pwm/U0_APB_Timers_EXA0/ReadRegs
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/PRDATA
add wave -noupdate -divider internal_timer
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/R0
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/R1
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/R2
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/R3
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/R4
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/Timers_OverFlow
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/Timers_CLR
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/Timer_Out
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/Timer_Match_Set
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/FLAG_TIMER
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/FLAG_PREC
add wave -noupdate -format Logic /tb_timer_pwm/PCLK
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/Timer_Cnt
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/OMS
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/Prescale_Cnt
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/TDAT_Value
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/TPWM
add wave -noupdate -divider int
add wave -noupdate -format Logic /tb_timer_pwm/INT_TMC
add wave -noupdate -format Logic /tb_timer_pwm/INT_TOF
add wave -noupdate -format Logic /tb_timer_pwm/INT_TPOUT
add wave -noupdate -format Logic {/tb_timer_pwm/TCAP[5]}
add wave -noupdate -format Logic {/tb_timer_pwm/TCAP[4]}
add wave -noupdate -format Logic {/tb_timer_pwm/TCAP[3]}
add wave -noupdate -format Literal /tb_timer_pwm/TCAP
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/TDx_CapEn
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/TDX_CapEn_1Pd
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/TDX_Up
add wave -noupdate -format Literal /tb_timer_pwm/U0_APB_Timers_EXA0/TCAP
add wave -noupdate -format Literal /tb_timer_pwm/U0_APB_Timers_EXA0/TCAP_Reg
add wave -noupdate -format Literal /tb_timer_pwm/U0_APB_Timers_EXA0/TCAP_Reg_1d
add wave -noupdate -divider OUTclk
add wave -noupdate -format Logic /tb_timer_pwm/PCLK
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/TCLK
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/OUTCLK_1d
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/OUTCLK_2d
add wave -noupdate -format Logic /tb_timer_pwm/U0_APB_Timers_EXA0/FLAG_TIMER
add wave -noupdate -format Literal -radix unsigned /tb_timer_pwm/U0_APB_Timers_EXA0/Timer_Cnt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {737772 ps} 0}
WaveRestoreZoom {0 ps} {1681152 ps}
configure wave -namecolwidth 150
configure wave -valuecolwidth 77
configure wave -justifyvalue right
configure wave -signalnamewidth 5
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 9
configure wave -childrowmargin 7
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
