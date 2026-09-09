--------------------------------------------------------------------------------
-- TITLE :                 I2C Master Byte Command Controller
-- FILE NAME :             i2cm_bytectrl.vhd
-- AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
-- ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
-- CREATED :               December 14, 2002
-- LAST UPDATED :          December 14, 2002
-- PLATFORM :              MS Windows 2000 professional
-- SIMULATOR :             ModelSim SE 5.5c
-- SYNTHESIZER :           Synplify pro 7.0
-- TARGET :                FPGA (ALTERA EPF10K10TC144-3)
-- DISCRIPTION :           This module defines Byte Command Controller of I2C Master Core
-- REVISION NUMBER :       -
-- VERSION NUMBER :        1.0
-- DATE OF CHANGE :        -
-- MODIFIEER :             -
-- DESCRIPTION OF CHANGE : -
-- NOTICE :                -
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Byte Command Controller
--------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all ;


entity i2cm_bytectrl is
  generic (
           T : time := 1 ns -- for functional simulation
  ) ;
  port (
        clk      : in  std_logic ; -- system clock
        rst_n    : in  std_logic ; -- asychronous reset, active low
        rst_sn   : in  std_logic ; -- sychronous reset,  active high
        ena      : in  std_logic ; -- core enable signal
        clk_cnt  : in  std_logic_vector (15 downto 0) ; -- clock prescale vaule
        start    : in  std_logic ;
        stop     : in  std_logic ;
        read     : in  std_logic ;
        write    : in  std_logic ;
        ack_in   : in  std_logic ;
        d_in     : in  std_logic_vector (7  downto 0) ;
        scl_i    : in  std_logic ; -- SCL input
        sda_i    : in  std_logic ; -- SDA input

        cmd_ack  : out std_logic ; 
        ack_out  : out std_logic ;
        i2c_busy : out std_logic ;
        dout     : out std_logic_vector (7  downto 0) ;
        scl_o    : out std_logic ; -- SCL output
        scl_oen  : out std_logic ; -- SCL output enable
        sda_o    : out std_logic ; -- SDA output
        sda_oen  : out std_logic   -- SDA output enable
  ) ;
end i2cm_bytectrl ;


architecture rtl of i2cm_bytectrl is
  component i2cm_bitctrl
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
          busy    : out std_logic ; -- I2C bus busy
          dout    : out std_logic ; -- received data bit
          scl_o   : out std_logic ; -- SCL output
          scl_oen : out std_logic ; -- SCL output enable
          sda_o   : out std_logic ; -- SDA output
          sda_oen : out std_logic   -- SDA output enable
    ) ;
  end component ;

  -- commands for bit command controller block
  constant I2C_CMD_NOP   : std_logic_vector (3 downto 0) := "0000" ;
  constant I2C_CMD_START : std_logic_vector (3 downto 0) := "0001" ;
  constant I2C_CMD_STOP  : std_logic_vector (3 downto 0) := "0010" ;
  constant I2C_CMD_READ  : std_logic_vector (3 downto 0) := "0100" ;
  constant I2C_CMD_WRITE : std_logic_vector (3 downto 0) := "1000" ;

  -- states for byte command controller state machine
  type states is (ST_IDLE, ST_START, ST_READ, ST_WRITE, ST_ACK, ST_STOP) ;
  signal byte_state_r : states ;

  -- signals for bit command controller
  signal core_cmd_r : std_logic_vector (3 downto 0) ;
  signal core_ack_a : std_logic ;
  signal core_txd_r : std_logic ;
  signal core_rxd_a : std_logic ;

  -- signals for shift register
  signal shf_reg_r  : std_logic_vector (7 downto 0) ;
  signal shift_r    : std_logic ;
  signal load_r     : std_logic ;

  -- signals for state machine
  signal go_a       : std_logic ;
  signal host_ack_r : std_logic ;
  signal data_cnt_r : std_logic_vector (2 downto 0) ;
  signal cnt_done_a : std_logic ;
begin

-- 01_BitCtrl ------------------------------------------------------------------

U0_I2CM_BITCTRL : i2cm_bitctrl
    port map (
              clk     => clk,        -- system clock
              rst_n   => rst_n,      -- asychronous reset, active low
              rst_sn  => rst_sn,     -- sychronous reset,  active high
              ena     => ena,        -- core enable signal
              clk_cnt => clk_cnt,    -- clock prescale vaule
              cmd     => core_cmd_r, -- bit commands
              din     => core_txd_r, -- data bit for transmission
              scl_i   => scl_i,      -- SCL input
              sda_i   => sda_i,      -- SDA input
      
              cmd_ack => core_ack_a, -- bit command complete
              busy    => i2c_busy,   -- I2C bus busy
              dout    => core_rxd_a, -- received data bit
              scl_o   => scl_o,      -- SCL output
              scl_oen => scl_oen,    -- SCL output enable
              sda_o   => sda_o,      -- SDA output
              sda_oen => sda_oen     -- SDA output enable
    ) ;

-- generate host-command-acknowledge
cmd_ack <= host_ack_r ;

-- generate go-signal
go_a <= (read or write or stop) and (not host_ack_r) ;

-- assign Dout output to shift-register
dout <= shf_reg_r ;

-- 02_ShiftRegister ------------------------------------------------------------

--generate shift register
SHIFT_REG_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    shf_reg_r <= (others => '0') after T ;
  elsif clk = '1' and clk'event then  
    if rst_sn = '1' then
      shf_reg_r <= (others => '0') after T ;
    elsif load_r = '1' then
      shf_reg_r <= d_in after T ;
    elsif shift_r = '1' then
      shf_reg_r <= (shf_reg_r (6 downto 0) & core_rxd_a) after T ;
    end if ;
  end if ;
end process ;

-- 03_DataCounter --------------------------------------------------------------

-- generate data-counter
DATA_CNT_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    data_cnt_r <= (others => '0') after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      data_cnt_r <= (others => '0') after T ;
    elsif load_r = '1' then
      data_cnt_r <= (others => '1') after T ; -- load counter with 7
    elsif shift_r = '1' then
      data_cnt_r <= data_cnt_r - 1 after T ;
    end if ;
  end if ;
end process ;

cnt_done_a <= '1' when data_cnt_r = 0 else '0' ;

-- 03_StateMachine -------------------------------------------------------------

-- state machine
-- command interpreter, translate complex commands into simpler I2C commands
NEXT_STATE_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    core_cmd_r   <= I2C_CMD_NOP after T ;
    core_txd_r   <= '0'         after T ;
    shift_r      <= '0'         after T ;
    load_r       <= '0'         after T ;
    host_ack_r   <= '0'         after T ;
    byte_state_r <= ST_IDLE     after T ;
    ack_out      <= '0'         after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      core_cmd_r   <= I2C_CMD_NOP after T ;
      core_txd_r   <= '0'         after T ;
      shift_r      <= '0'         after T ;
      load_r       <= '0'         after T ;
      host_ack_r   <= '0'         after T ;
      byte_state_r <= ST_IDLE     after T ;
      ack_out      <= '0'         after T ;
    else
      -- initially reset all signal
      core_txd_r <= shf_reg_r (7) after T ;
      shift_r    <= '0'           after T ;
      load_r     <= '0'           after T ;
      host_ack_r <= '0'           after T ;

-------------------- state machine for byte commands --------------------

      case byte_state_r is
        -- IDLE
        when ST_IDLE  =>
	  if go_a = '1' then
	    if start = '1' then   -- start
              byte_state_r <= ST_START      after T ;
	      core_cmd_r   <= I2C_CMD_START after T ;
	    elsif read = '1' then -- read
              byte_state_r <= ST_READ       after T ;
	      core_cmd_r   <= I2C_CMD_READ  after T ;
	    elsif write = '1' then -- write
	      byte_state_r <= ST_WRITE      after T ;
	      core_cmd_r   <= I2C_CMD_WRITE after T ;
	    else                   -- stop
              byte_state_r <= ST_STOP       after T ;
	      core_cmd_r   <= I2C_CMD_STOP  after T ;
              host_ack_r   <= '1'           after T ; -- generate acknowledge signal 
            end if ;
            load_r <= '1' after T ;
	  end if ;

        -- START
	when ST_START =>
	  if core_ack_a = '1' then
	    if read = '1' then
              byte_state_r <= ST_READ       after T ;
              core_cmd_r   <= I2C_CMD_READ  after T ;
	    else
              byte_state_r <= ST_WRITE      after T ;
              core_cmd_r   <= I2C_CMD_WRITE after T ;
	    end if ;
            load_r <= '1' after T ;
	  end if ;

        -- WRITE
	when ST_WRITE =>
	  if core_ack_a = '1' then
	    if cnt_done_a = '1' then
              byte_state_r <= ST_ACK        after T ;
              core_cmd_r   <= I2C_CMD_READ  after T ;
	    else
              byte_state_r <= ST_WRITE      after T ; -- stay in same state
              core_cmd_r   <= I2C_CMD_WRITE after T ; -- write next bit 
              shift_r      <= '1'           after T ;
	    end if ;
	  end if ;
 
        -- READ
	when ST_READ  =>
	  if core_ack_a = '1' then
	    if cnt_done_a = '1' then
              byte_state_r <= ST_ACK        after T ;
              core_cmd_r   <= I2C_CMD_WRITE after T ;
	    else
              byte_state_r <= ST_READ       after T ;
              core_cmd_r   <= I2C_CMD_READ  after T ;
	    end if ;
            shift_r    <= '1'    after T ;
            core_txd_r <= ack_in after T ;
	  end if ;
 
        -- ACK
	when ST_ACK   =>
	  if core_ack_a = '1' then
            -- check for stop
	    if stop = '1' then
              byte_state_r <= ST_STOP      after T ;
              core_cmd_r   <= I2C_CMD_STOP after T ;
	    else
              byte_state_r <= ST_IDLE      after T ;
              core_cmd_r   <= I2C_CMD_NOP after T ;
	    end if ;

            -- assign ack_out output to core_rxd_a (contains last received bit)
            ack_out    <= core_rxd_a after T ;
            -- generate command acknowledge signal
            host_ack_r <= '1' after T ;
            core_txd_r <= '1' after T ;
	  else
            core_txd_r <= ack_in after T ;
	  end if ;
        
        -- STOP
	when ST_STOP  =>
	  if core_ack_a = '1' then
              byte_state_r <= ST_IDLE      after T ;
              core_cmd_r   <= I2C_CMD_NOP  after T ;
	  end if ;

        -- illegal states
	when others   => 
              byte_state_r <= ST_IDLE      after T ;
              core_cmd_r   <= I2C_CMD_NOP  after T ;
              report ("Byte controller entered illegal state.") ; -- only simulation (Use 1993 language syntax)

      end case ;

-------------------------------------------------------------------------

    end if ;
  end if ;
end process ;

--------------------------------------------------------------------------------


end rtl ;

