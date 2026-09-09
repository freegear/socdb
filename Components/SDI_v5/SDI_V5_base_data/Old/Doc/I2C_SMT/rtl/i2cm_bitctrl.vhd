--------------------------------------------------------------------------------
-- TITLE :                 I2C Master Bit Command Controller
-- FILE NAME :             i2cm_bitctrl.vhd
-- AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
-- ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
-- CREATED :               December 14, 2002
-- LAST UPDATED :          December 14, 2002
-- PLATFORM :              MS Windows 2000 professional
-- SIMULATOR :             ModelSim SE 5.5c
-- SYNTHESIZER :           Synplify pro 7.0
-- TARGET :                FPGA (ALTERA EPF10K10TC144-3)
-- DISCRIPTION :           This module defines Bit Command Controller of I2C Master Core
-- REVISION NUMBER :       -
-- VERSION NUMBER :        1.0
-- DATE OF CHANGE :        -
-- MODIFIEER :             -
-- DESCRIPTION OF CHANGE : -
-- NOTICE :                -
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Bit Command Controller
--------------------------------------------------------------------------------
--
-- Translate simple commands into SCL/SDA transitions
-- Each command has 5 states, A/B/C/D/IDLE
-- 
-- 1. START : 
--            SCL	~~~~~~~~~~~~~~\______
--            SDA ~~~~~~~~~~\__________
--                x | A | B | C | D | i
--
-- 2. Repeated START :
--            SCL	______/~~~~~~~\______
--            SDA __/~~~~~~~\__________
--                x | A | B | C | D | i
--
-- 3. STOP :
--            SCL	______/~~~~~~~~~~~~~~
--            SDA ==\_______/~~~~~~~~~~
--                x | A | B | C | D | i
--
-- 4. WRITE :
--            SCL	______/~~~~~~~\______
--            SDA ==x===============x==
--                x | A | B | C | D | i
--
-- 5. READ :
--            SCL	______/~~~~~~~\______
--            SDA xxxxxxx=======xxxxxxx
--                x | A | B | C | D | i
--
-- This is implemented by state machine and output decoder (FYI : 02, 03) 
--
--------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all ;


entity i2cm_bitctrl is
  generic (
           T : time := 1 ns -- for functional simulation
  ) ;
  port (
        clk     : in  std_logic ; -- system clock
        rst_n   : in  std_logic ; -- asychronous reset, active low
        rst_sn  : in  std_logic ; -- sychronous reset,  active high
        ena     : in  std_logic ; -- core enable signal
        clk_cnt : in  std_logic_vector (15 downto 0) ; -- clock prescale vaule
        cmd     : in  std_logic_vector (3  downto 0) ; -- command
        din     : in  std_logic ; -- data bit for transmission
        scl_i   : in  std_logic ; -- SCL input
        sda_i   : in  std_logic ; -- SDA input

        cmd_ack : out std_logic ; -- command complete
        busy    : out std_logic ; -- bus busy
        dout    : out std_logic ; -- received data bit
        scl_o   : out std_logic ; -- SCL output
        scl_oen : out std_logic ; -- SCL output enable
        sda_o   : out std_logic ; -- SDA output
        sda_oen : out std_logic   -- SDA output enable
  ) ;
end i2cm_bitctrl ;


architecture rtl of i2cm_bitctrl is
  -- bit commands
  constant I2C_CMD_NOP   : std_logic_vector (3 downto 0) := "0000" ;
  constant I2C_CMD_START : std_logic_vector (3 downto 0) := "0001" ;
  constant I2C_CMD_STOP  : std_logic_vector (3 downto 0) := "0010" ;
  constant I2C_CMD_READ  : std_logic_vector (3 downto 0) := "0100" ;
  constant I2C_CMD_WRITE : std_logic_vector (3 downto 0) := "1000" ;
  
  -- bit command states
  type states is (IDLE, 
                  START_A, START_B, START_C, START_D,
                  STOP_A,  STOP_B,  STOP_C,
                  RD_A,    RD_B,    RD_C,    RD_D,
                  WR_A,    WR_B,    WR_C,    WR_D) ;
  signal bit_state_r  : states ;

  signal cnt_r         : std_logic_vector (15 downto 0) ; -- clock divider counter
  signal clk_en_r      : std_logic ; -- clock generation signal
  signal sync_scl_r    : std_logic ; -- synchronized SCL input
  signal sync_sda_r    : std_logic ; -- synchronized SDA input
  signal scl_oen_r     : std_logic ; -- internal SCL output enable 
  signal sda_oen_r     : std_logic ; -- internal SDA output enable
  signal scl_oen_r_p1  : std_logic ; -- delayed scl_oen
  signal slave_wait_a  : std_logic ; -- for synchronization
  signal sync_sda_r_p1 : std_logic ; -- delayed sync_sda_r
  signal sta_cond_r    : std_logic ;
  signal sto_cond_r    : std_logic ;
  signal busy_r        : std_logic ;
begin

-- 01_Prescale -----------------------------------------------------------------

-- generate clk_en_r
GEN_CLK_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    cnt_r    <= (others => '0') after T ;
    clk_en_r <= '1'             after T ; 
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      cnt_r    <= (others => '0') after T ;
      clk_en_r <= '1'             after T ;
    else
      if ena = '0' or cnt_r = 0 then
        cnt_r    <= clk_cnt  after T ;
        clk_en_r <= '1'      after T ;
      else
        if slave_wait_a = '0' then -- FYI : go to "04_BusyBit"
          cnt_r    <= cnt_r - 1 after T ;
        end if ;
        clk_en_r <= '0'         after T ;
      end if ;
    end if ;
  end if ;
end process ;

-- 02_StateMachine -------------------------------------------------------------

-- synchronize SCL and SDA inputs
SYNC_SCL_SDA_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    sync_scl_r <= '0' after T ;
    sync_sda_r <= '0' after T ;
  elsif clk = '1' and clk'event then
    sync_scl_r <= scl_i after T ;
    sync_sda_r <= sda_i after T ;
  end if ;
end process ;

-- generate statemachine
NEXT_STATE_DEC_PROC : process (clk, rst_n, bit_state_r, cmd)
  variable next_state_v : states ;
  variable cmd_ack_v    : std_logic ;
  variable store_sda_v  : std_logic ;
begin
  next_state_v := bit_state_r ;
  cmd_ack_v    := '0' ; -- default NAK(= no acknowledge)
  store_sda_v  := '0' ;

  case bit_state_r is
    -- IDLE state
    when IDLE =>
      case cmd is
        when I2C_CMD_START => next_state_v := START_A ;
        when I2C_CMD_STOP  => next_state_v := STOP_A ;
        when I2C_CMD_WRITE => next_state_v := WR_A ;
        when I2C_CMD_READ  => next_state_v := RD_A ;
        when others => next_state_v := IDLE ;
      end case ;

    -- START state
    when START_A =>
      next_state_v := START_B ;
    when START_B =>
      next_state_v := START_C ;
    when START_C =>
      next_state_v := START_D ;
    when START_D =>
      next_state_v := IDLE ;
      cmd_ack_v    := '1' ; -- command complete

    -- STOP state
    when STOP_A =>
      next_state_v := STOP_B ;
    when STOP_B =>
      next_state_v := STOP_C ;
    when STOP_C =>
      next_state_v := IDLE ;
      cmd_ack_v    := '1' ; -- command complete

    -- READ state
    when RD_A =>
      next_state_v := RD_B ;
    when RD_B =>
      next_state_v := RD_C ;
    when RD_C =>
      next_state_v := RD_D ;
      store_sda_v  := '1' ;
    when RD_D =>
      next_state_v := IDLE ;
      cmd_ack_v    := '1' ; -- command complete

    -- WRITE state
    when WR_A =>
      next_state_v := WR_B ;
    when WR_B =>
      next_state_v := WR_C ;
    when WR_C =>
      next_state_v := WR_D ;
    when WR_D =>
      next_state_v := IDLE ;
      cmd_ack_v    := '1' ; -- command complete
  end case ;

  -- generate regs
  if rst_n = '0' then
    bit_state_r <= IDLE after T ;
    cmd_ack     <= '0'  after T ;
    dout        <= '0'  after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      bit_state_r <= IDLE after T ;
      cmd_ack     <= '0'  after T ;
      dout        <= '0'  after T ;
    else
      if clk_en_r = '1' then
        bit_state_r <= next_state_v after T ;
        
        if store_sda_v = '1' then
          dout <= sync_sda_r after T ;
        end if ;
      end if ;

      cmd_ack <= cmd_ack_v and clk_en_r after T ;     
    end if ;
  end if ;
end process ;

-- 03_OutputDecoder ------------------------------------------------------------

OUTPUT_DECODER_PROC : process (clk, rst_n, bit_state_r, scl_oen_r, sda_oen_r, din)
  variable scl_oen_v : std_logic ;
  variable sda_oen_v : std_logic ;
begin
  case bit_state_r is
    -- IDLE
    when IDLE    => 
      scl_oen_v := scl_oen_r ; -- keep SCL in same state 
      sda_oen_v := sda_oen_r ; -- keep SDA in same state

    -- START
    when START_A =>
      scl_oen_v := scl_oen_r ; -- keep SCL in same state (for repeated start)
      sda_oen_v := '1' ;       -- set SDA high
    when START_B =>
      scl_oen_v := '1' ;       -- set SCL high
      sda_oen_v := '1' ;       -- keep SDA high
    when START_C =>
      scl_oen_v := '1' ;       -- keep SCL high
      sda_oen_v := '0' ;       -- set SDA low
    when START_D =>
      scl_oen_v := '0' ;       -- set SCL low
      sda_oen_v := '0' ;       -- keep SDA low
    
    -- STOP
    when STOP_A  =>
      scl_oen_v := '0' ;       -- keep SCL disabled
      sda_oen_v := '0' ;       -- set SDA low
    when STOP_B  =>
      scl_oen_v := '1' ;       -- set SCL high
      sda_oen_v := '0' ;       -- keep SDA low
    when STOP_C  =>
      scl_oen_v := '1' ;       -- keep SCL high
      sda_oen_v := '1' ;       -- set SDA high

    -- WRITE
    when WR_A    =>
      scl_oen_v := '0' ;       -- keep SCL low
      sda_oen_v := din ;       -- set SDA
    when WR_B    =>
      scl_oen_v := '1' ;       -- set SCL high
      sda_oen_v := din ;       -- keep SDA
    when WR_C    =>
      scl_oen_v := '1' ;       -- keep SCL high
      sda_oen_v := din ;       -- keep SDA
    when WR_D    =>
      scl_oen_v := '0' ;       -- set SCL low
      sda_oen_v := din ;       -- keep SDA

    -- READ
    when RD_A    =>
      scl_oen_v := '0' ;       -- keep SCL low
      sda_oen_v := '1' ;       -- tri-state SDA
    when RD_B    =>
      scl_oen_v := '1' ;       -- set SCL high
      sda_oen_v := '1' ;       -- tri-state SDA
    when RD_C    =>
      scl_oen_v := '1' ;       -- keep SCL high
      sda_oen_v := '1' ;       -- tri-state SDA
    when RD_D    =>
      scl_oen_v := '0' ;       -- set SCL low
      sda_oen_v := '1' ;       -- tri-state SDA
  end case ;

  -- generate regs
  if rst_n = '0' then
    scl_oen_r <= '1' after T ;
    sda_oen_r <= '1' after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      scl_oen_r <= '1' after T ;
      sda_oen_r <= '1' after T ;
    else
      if clk_en_r = '1' then
        scl_oen_r <= scl_oen_v ;
        sda_oen_r <= sda_oen_v ;
      end if ;
    end if ;
  end if ;
end process ;

-- assign outputs
scl_o   <= '0' ;
scl_oen <= scl_oen_r ;
sda_o   <= '0' ;
sda_oen <= sda_oen_r ;

-- 04_BusyBit ------------------------------------------------------------------

-- delay scl_oen
DELAY_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    scl_oen_r_p1 <= '0' ;
  elsif clk = '1' and clk'event then
    scl_oen_r_p1 <= scl_oen_r ;
  end if ;
end process ;

-- whenever the slave is not ready it can delay the cycle by pulling SCL low
slave_wait_a <= scl_oen_r_p1 and (not sync_scl_r) ;


-- detect start condition => detect falling edge on SDA while SCL is high
-- detect stop  condition => detect rising  edge on SDA while SCL is low
DETECT_STA_STO : process (clk, rst_n)
begin
  if rst_n = '0' then
    sync_sda_r_p1 <= '0' ;
    sta_cond_r    <= '0' ;
    sto_cond_r    <= '0' ;
  elsif clk = '1' and clk'event then
    sync_sda_r_p1 <= sync_sda_r ;
    sta_cond_r    <= ((not sync_sda_r) and sync_sda_r_p1) and sync_scl_r ;
    sto_cond_r    <= (sync_sda_r and (not sync_sda_r_p1)) and sync_scl_r ;
  end if ;
end process ;

-- generate bus busy signals
GEN_BUSY_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    busy_r <= '0' after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then 
      busy_r <= '0' after T ;
    else
      busy_r <= (sta_cond_r or busy_r) and (not sto_cond_r) after T ;
    end if ;
  end if ;
end process ;

-- assign output
busy <= busy_r ;

--------------------------------------------------------------------------------


end rtl ;

