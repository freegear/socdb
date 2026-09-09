--------------------------------------------------------------------------------
-- TITLE :                 I2C Master Core
-- FILE NAME :             i2cm_top.vhd
-- AUTHER :                Jinil Chung (jichung@konkuk.ac.kr)
-- ORGANIZATION :          Konkuk Univ. VLSI Design Lab.
-- CREATED :               December 14, 2002
-- LAST UPDATED :          December 14, 2002
-- PLATFORM :              MS Windows 2000 professional
-- SIMULATOR :             ModelSim SE 5.5c
-- SYNTHESIZER :           Synplify pro 7.0
-- TARGET :                FPGA (ALTERA EPF10K10TC144-3)
-- DISCRIPTION :           This module defines I2C Master Core
-- REVISION NUMBER :       -
-- VERSION NUMBER :        1.0
-- DATE OF CHANGE :        -
-- MODIFIEER :             -
-- DESCRIPTION OF CHANGE : -
-- NOTICE :                -
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- I2C Master Core
--------------------------------------------------------------------------------
--
--
--------------------------------------------------------------------------------

library IEEE ;
use IEEE.std_logic_1164.all ;
use IEEE.std_logic_arith.all ;
use IEEE.std_logic_unsigned.all ;


entity i2cm_top is
  generic (
           T : time := 1 ns -- for functional simulation
  ) ;
  port (
        clk      : in  std_logic ; -- system clock
        rst_n    : in  std_logic ; -- asychronous reset, active low
        rst_sn   : in  std_logic ; -- sychronous reset,  active high
        addr     : in  std_logic_vector (2 downto 0) ; -- lower address bits
        dat_i    : in  std_logic_vector (7 downto 0) ; -- databus input
        we_i     : in  std_logic ; -- write enable input
        stb_i    : in  std_logic ; -- strobe signals / core select signal
        cyc_i    : in  std_logic ; -- valid bus cycle input
        scl_i    : in  std_logic ; -- SCL input
        sda_i    : in  std_logic ; -- SDA input

        dat_o    : out std_logic_vector (7 downto 0) ; -- databus output
        ack_o    : out std_logic ; -- bus cycle acknowledge output
        inta_o   : out std_logic ; -- interrupt request output signal
        scl_o    : out std_logic ; -- SCL output
        scl_oen  : out std_logic ; -- SCL output enable, active low
        sda_o    : out std_logic ; -- SDA output
        sda_oen  : out std_logic   -- SDA output enable, active low
  ) ;
end i2cm_top ;


architecture rtl of i2cm_top is
  component i2cm_bytectrl
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
          scl_oen  : out std_logic ; -- SCL output enable, active low
          sda_o    : out std_logic ; -- SDA output
          sda_oen  : out std_logic   -- SDA output enable, active low
    ) ;
  end component ;

  -- registers
  signal pre_r      : std_logic_vector (15 downto 0) ; -- clock prescale register
  signal ctrl_r     : std_logic_vector (7  downto 0) ; -- control register
  signal tx_r       : std_logic_vector (7  downto 0) ; -- transmit register
  signal rx_r       : std_logic_vector (7  downto 0) ; -- receive register
  signal cmd_r      : std_logic_vector (7  downto 0) ; -- command register
  signal stat_r     : std_logic_vector (7  downto 0) ; -- status register

  -- done signal : command completed, clear command register
  signal done_a     : std_logic ;

  -- command register signlas
  signal sta_a      : std_logic ;
  signal sto_a      : std_logic ;
  signal rd_a       : std_logic ;
  signal wr_a       : std_logic ;
  signal ack_a      : std_logic ;
  signal iack_a     : std_logic ;

  -- core enable
  signal core_en_a  : std_logic ;
  signal ien_a      : std_logic ;

  -- status register signals
  signal rxack_a    : std_logic ; -- received acknowledge from slave (wire)
  signal rxack_r    : std_logic ; -- received acknowledge from slave (register)
  signal tip_r      : std_logic ; -- transfer in process
  signal irq_flag_r : std_logic ; -- interrupt pending flag
  signal i2c_busy_a : std_logic ; -- bus busy (start signal detected)
begin

-- 01_Assign -------------------------------------------------------------------

-- generate acknowledge output signal
ack_o <= cyc_i and stb_i ; -- because timing is always honored

-- assign dat_o
ASSIGN_DAT_O_PROC : process (addr, pre_r, ctrl_r, cmd_r, rx_r, stat_r, tx_r)
begin
  case addr is
    when "000" =>
      dat_o <= pre_r (7  downto 0) ;
    when "001" =>
      dat_o <= pre_r (15 downto 8) ;
    when "010" =>
      dat_o <= ctrl_r ;
    when "011" =>
      dat_o <= rx_r ;   -- wrtie is transmit register tx_r
    when "100" =>
      dat_o <= stat_r ; -- write is command register cmd_r

    -- Debugging registers
    when "101" =>
      dat_o <= tx_r ;
    when "110" =>
      dat_o <= cmd_r ;
    when "111" =>
      dat_o <= (others => '0') ;
    when others => -- for simulation only
      dat_o <= (others => 'X') ;
  end case ;
end process ;

-- 02_RegBlock -----------------------------------------------------------------

REGS_BLOCK_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    pre_r  <= (others => '1') after T ;
    ctrl_r <= (others => '0') after T ;
    tx_r   <= (others => '0') after T ;
    cmd_r  <= (others => '0') after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      pre_r  <= (others => '1') after T ;
      ctrl_r <= (others => '0') after T ;
      tx_r   <= (others => '0') after T ;
      cmd_r  <= (others => '0') after T ;
    else
      if cyc_i = '1' and stb_i = '1' and we_i = '1' then
        if addr (2) = '0' then
          case addr (1 downto 0) is
            when "00" => pre_r (7  downto 0) <= dat_i after T ;
            when "01" => pre_r (15 downto 8) <= dat_i after T ;
            when "10" => ctrl_r              <= dat_i after T ;
            when "11" => tx_r                <= dat_i after T ;
 
            -- illegal cases, for simulation only
            when others =>
              report ("illegal write address, setting all registers to unknown.") ;
              pre_r  <= (others => 'X') ;
              ctrl_r <= (others => 'X') ;
              tx_r   <= (others => 'X') ;
          end case ;
        elsif core_en_a = '1' and addr (1 downto 0) = 0 then
          -- only take new commands when I2C core enabled
          -- pending commands are finished
          cmd_r <= dat_i after T ;
        end if ;
      else
        -- clear command bits when done
        if done_a = '1' then
          cmd_r (7 downto 4) <= (others => '0') after T ;
        end if ;
  
        -- reserved bits
        cmd_r (2 downto 1)   <= (others => '0') after T ;

        -- clear iack when irq_flag_r cleared
        cmd_r (0)            <= cmd_r (0) and irq_flag_r ;
      end if ;
    end if ;
  end if ;  
end process ;


-- 03_DecReg -------------------------------------------------------------------

-- decode command register
sta_a  <= cmd_r (7) ;
sto_a  <= cmd_r (6) ;
rd_a   <= cmd_r (5) ;
wr_a   <= cmd_r (4) ;
ack_a  <= cmd_r (3) ;
iack_a <= cmd_r (2) ;

-- decode control register
core_en_a <= ctrl_r (7) ;
ien_a     <= ctrl_r (6) ;

-- 04_ByteCtrl -----------------------------------------------------------------

U0_I2CM_BYTECTRL : i2cm_bytectrl
    port map (
              clk      => clk,       -- system clock
              rst_n    => rst_n,     -- asychronous reset, active low
              rst_sn   => rst_sn,    -- sychronous reset,  active high
              ena      => core_en_a, -- core enable signal
              clk_cnt  => pre_r,     -- clock prescale vaule
              start    => sta_a,
              stop     => sto_a,
              read     => rd_a,
              write    => wr_a,
              ack_in   => ack_a,
              d_in     => tx_r,
              scl_i    => scl_i,
              sda_i    => sda_i,

              cmd_ack  => done_a,
              ack_out  => rxack_a,
              i2c_busy => i2c_busy_a,
              dout     => rx_r,
              scl_o    => scl_o,      -- SCL output
              scl_oen  => scl_oen,    -- SCL output enable, active low
              sda_o    => sda_o,      -- SDA output
              sda_oen  => sda_oen     -- SDA output enable, active low
    ) ;

-- 05_Stat&IRQBlock ------------------------------------------------------------

GEN_ST_BITS_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then 
    rxack_r    <= '0' after T ;
    tip_r      <= '0' after T ;
    irq_flag_r <= '0' after T ;
  elsif clk = '1' and clk'event then
    if rst_sn = '1' then
      rxack_r    <= '0' after T ;
      tip_r      <= '0' after T ;
      irq_flag_r <= '0' after T ;
    else
      rxack_r    <= rxack_a after T ;
      tip_r      <= rd_a or wr_a after T ;
      -- interrupt request flag is always generated
      irq_flag_r <= (done_a or irq_flag_r) and (not iack_a) after T ;
    end if ;
  end if ;
end process ;

-- generate interrupt request signals
GEN_IRQ_PROC : process (clk, rst_n)
begin
  if rst_n = '0' then
    inta_o <= '0' after T ;
  elsif clk = '1' and clk'event then
    if rst_sn  = '1' then
      inta_o <= '0' after T ;
    else
      -- interrupt signal is only generated when IEN(interrupt enable bit) is set
      inta_o <= irq_flag_r and ien_a after T ;
    end if ;
  end if ;
end process ;

-- 06_AssignStatReg ------------------------------------------------------------

-- assign status register bits
stat_r (7)          <= rxack_r ;
stat_r (6)          <= i2c_busy_a ;
stat_r (5 downto 2) <= (others => '0') ; -- reserved
stat_r (1)          <= tip_r ;
stat_r (0)          <= irq_flag_r ;


--------------------------------------------------------------------------------


end rtl ;