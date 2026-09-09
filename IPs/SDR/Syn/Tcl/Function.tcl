#============================================================================
#-- 1. Define clock
#============================================================================

proc pCreateClock { clock_name clock_period half_period clock_uncertainty } {

  #------------------------
  #-- Define clock
  #------------------------

  #-- clock
  create_clock -p $clock_period -w [list 0 $half_period] [find port $clock_name]

  #----------------------------
  #-- Plus clock skew (tpskew)
  #----------------------------   
  #-- Performed by using 
  #-- plus_uncertainty parameter
  #-----------------------------

  set_clock_uncertainty -setup $clock_uncertainty [find port $clock_name]
  #set_clock_skew -ideal -plus_uncertainty $clock_tpskew [find clock $clock_name]

  #-------------------------------
  #-- Ensure clock is not buffered
  #-------------------------------

  #-- Ignore all transition times as it is an ideal clock 
  set_clock_transition 0 $clock_name
  
  #-- Infinite drive strength clock signal 
  set_drive 0 $clock_name
  
  #-- Zero load clock signal 
  set_load 0 $clock_name
  
  #-- Set no driving cell on clock 
  remove_driving_cell [find port $clock_name]
  
  #-- Zero resistance for zero net delay(interconnect delay) on ideal clock net
  set_resistance 0 [find net $clock_name]
  
  #-- Preserve the clock net during optimisation 
  set_dont_touch_network [find clock $clock_name]
}

#============================================================================
#-- 2. Create reset pCreateReset (reset_name reset_clock tidmax tholdmax)
#============================================================================

proc pCreateReset { reset_name reset_clock tidmax tholdmax } {

  #----------------------------
  #-- Define reset
  #----------------------------

  set_input_delay -clock $reset_clock -rise -max $tidmax $reset_name
  set_input_delay -clock $reset_clock -rise -min $tholdmax $reset_name

  #----------------------------
  #-- Ensure reset is not buffered
  #----------------------------

  #-- Do not check reset timing during synthesis 
  set_disable_timing [find port $reset_name]
  
  #-- Zero load reset signal 
  set_load 0 $reset_name
  
  #-- Zero resistance for zero net delay(interconnect delay) on ideal reset net
  set_resistance 0 [find net $reset_name]
  
  #-- Infinite drive strength reset signal 
  set_drive 0 $reset_name
  
  #-- Set no driving cell on reset 
  remove_driving_cell [find port $reset_name]
  
  #-- Define an ideal net for the reset net 
  set_ideal_net [find net $reset_name]
  
  #-- Define an ideal net for the reset net 
  set_dont_touch_network [find port $reset_name]

}
