------------------------------------------------------------------------
-- Copyright 1997-1998 VAutomation Inc. Nashua NH USA. 
-- Visit HTTP://www.vautomation.com for mor details on our other
-- Synthesizable microprocessor and peripheral cores.
--
-- This program is free software; you can redistribute it and/or modify
-- it under the terms of the GNU General Public License version 2 as
-- published by the Free Software Foundation.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- The GNU Public License can be found at HTTP://www.gnu.org.
-- 
-- The copyright notice above MUST remain in the source code at all
-- times!
--
-- File: vspi.vhd
-- Revision: $Name: REV9910 $
-- Gate Count: 500 gates (LSI Logic 10K)
-- Description:
--
--      Serial Peripheral Interface (SPI)
--
-- The VSPI core implements an SPI interface compatible with the many
-- serial EEPROMs, and microcontrollers. The VSPI core is typically used
-- as an SPI master, but it can be configured as an SPI slave as well.
--
-- The SPI bus is a 3 wire bus that in effect links a serial shift
-- register between the "master" and the "slave". Typically both the
-- master and slave have an 8 bit shift register so the combined
-- register is 16 bits. When an SPI transfer takes place, the master and
-- slave shift their shift registers 8 bits and thus exchange their 8
-- bit register values.
--
-- The VPSI core is completely software configurable. The clock
-- polarity, clock phase, the clock frequency in master mode, and the
-- number of bits to be transferred are all software programmable. These
-- configuration bits are usually determined by the capabilities of the
-- other device you wish to communicate with.
--
-- SPI supports multiple slaves on a single 3 wire bus by using seperate
-- SLaVe SELect signals (SVLSEL) to enable the desired slave. Multiple
-- masters are also supported and some support is provided for detecting
-- collisions when multiple masters attempt to transfer at the same
-- time.
--
-- A Wired-OR mode is provided which allows multiple masters to collide
-- on the bus without risk of damage. In this mode, an external pullup
-- resisitor is required on the SI and SO pins. WOR mode also allows the
-- SPI bus to operate as a 2 wire bus by connecting the SI and SO pins
-- together to form a single bidirectional data pin.
--
-- Generally, pullups are recommended on all of the external SPI signals
-- to insure they are held in a valid state even when the VSPI core is
-- disabled.
--
-- Limitations:

--      When operating as a slave, the SPI clock signal (SCK) must be
--      slower than 1/8th of the CPU clock. 1/16th is recommended. Note
--      that this core is fully synchronous to the cpu CLK and thus SCK
--      is sampled and then operated on. This results in 3 to 4 clocks
--      of delay which will violate the SPI spec if SCK is faster than
--      1/8th of the CPU clock. When the VSPI core is in master mode, it
--      operates exactly on the proper edges since it is generating SCK.
--
--      The VSPI core was specifically designed to be an SPI master and
--      to be connected to a microprocessor such as VAutomations
--      V8-uRISC CPU. This core also has the capability to be a slave
--      but that feature is considered secondary which is why it is
--      speed limited.
--
-- Register Definition:
-- Addr Name    R/W     Description
--  0   DOUT    W       8 Bit data out register
--  0   DIN     R       8 Bit data in register
--  1   CTL     R/W     Control Register
--                      [0]=Reserved.
--                      [1]=MSTENB      Enable SPI master mode
--                      [2]=WOR Wire-OR mode enabled
--                      [3]=CKPOL       Clock Polarity 1=SCK idles high,
--                                      0=SCK idles low
--                      [4]=PHASE       Phase Select
--                      [6:5]=DVD       Clock divide - 00=8, 01=16,
--                                      10=32, 11=64
--                      [7]=IRQENB      Interrupt enable
--  2   STATUS  R/W     Interrupt Status register
--                      Each bit of the status register is cleared to
--                      zero by by writting ONE to the respective bit.
--                      [7]=IRQ Interrupt active
--                              Set at the end of a master mode
--                              transfer, or when SLVSEL goes high on a
--                              slave transfer
--                      [6]=Overrun
--                              This bit is set when the DOUT register
--                              is written while an SPI transfer is in
--                              progress.
--                      [5]=COL
--                              This bit is set when there is a master
--                              mode collision between multiple SPI
--                              masters. It is set when SLVSEL goes low
--                              while MSTENB=1.
--                      [2:4]=zero
--                      [1]=TXRUN
--                              1=Master mode operation underway.
--                              This bit is read only.
--                      [0]=SLVSEL
--                              This bit corresponds to the SLVSEL pin
--                              on the VSPI core (note that this is
--                              normally interted at the IO pin). read
--                              only.
--  3   SSEL    R/W     Slave Select/bit count register
--                      SSEL[7:5]
--                              Number of bits to shift in master mode, 
--                              000=8 bits, 001=1 bit, 111=7 bits.
--                      SSEL[4:0]
--                              5 individual Slave Selects for master
--                              mode
--
-- The VSPI core operates in two fundamentally different modes based on
-- the PHASE bit (CTL[4]). The two modes are depicted in the timing
-- diagrams below. The key difference centers around the fact that SPI
-- data is clocked out on one edge of the clock, and sampled on the
-- other. The two modes select where the opposite edge DFF is placed.
-- When PHASE=0, a negative edge flop is inserted into the shift_in
-- path. The shift_out data is tricky because we must output data from
-- the TX_HOLD register for the first bit as we have not seen a clock on
-- SCK to clock the data into the shift register. When PHASE=1, the
-- negative edge flop is inserted into the shift_out path to hold the
-- data for an extra 1/2 clock.
--
-- Microprocessor interface
--      The VSPI microprocessor interface is quite simple and connects
-- easily to VAutomations V8-uRISC CPU. Transfers are fully synchronous
-- to the CLK signal. When CHIP_SEL and WRITE are both active at the
-- rising edge of CLK, a write to the desired register occurs. CHIP_SEL
-- and WRITE should only be active for 1 clock cycle.
--
-- Timing diagram:
--
-- PHASE=0 (POLCK=0 shown, invert SCKI if POLCK=1)
-- Cycle #     | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
--                _   _   _   _   _   _   _   _      
-- SCK    _______| |_| |_| |_| |_| |_| |_| |_| |_____
--              ___ ___ ___ ___ ___ ___ ___ ___
-- MOSI  ------<_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_>-----
--            _____ ___ ___ ___ ___ ___ ___ _______
-- MISO  ----<___7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_XXXX>-
--            _____________________________________
-- SLVSEL ___/                                     \_
-- Shift register runs on the second edge of SCKI. A negative edge flop
-- is placed in the shift_in path to sample data on the first edge of
-- SCKI.

-- PHASE=1 (POLCK=0 shown, invert SCKI if POLCK=1)
-- Cycle #       | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
--                _   _   _   _   _   _   _   _      
-- SCK   ________| |_| |_| |_| |_| |_| |_| |_| |_______
--                ___ ___ ___ ___ ___ ___ ___ ___
-- MOSI  --------<_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_>-----
--                _ ___ ___ ___ ___ ___ ___ _________
-- MISO  ----XXXXX_7_X_6_X_5_X_4_X_3_X_2_X_1_X_0_____>-
--            _______________________________________
-- SLVSEL ___/                                       \_
-- Shift register runs on the second edge of SCKI. A negative edge flop
-- is placed in the shift_out path to hold data data for an extra 1/2
-- clock.
--
-- Crude block diagram:
--
-- DATAIN--------------------------+
--                                 |
--                    |\           |
-- MISO-------+-------> \      +---v--------+                |\
--            |       |  >-----> 8bit Shift >-------+--------> \
--            |    +--> /      |> Register  |       |        |  >-->MOSI
--            |    |  |/       +---v--------+       |   +----> /        
--            |    |               |                |   |    |/
--            |    |               +---DATAOUT      |   |      
--            |    |                                |   |      
--            |    +-------------------------+      |   |               
--            |     +------------------------|------+   |
--            |     |  |\                    |          | 
--            |     +--> \        +----+     |          | 
--            |        |  >------->Neg >-----+----------+ 
--            +--------> /        |DFF |                  
--                     |/        O|>   |                  
--                                +----+                  
-- Not shown are the control and status registers, the master mode bit
-- counters and other control logic.
-- 
-- IO cell Requirements:
-- The IO cells required for the SPI bus are quite simple. The following
-- VHDL code will synthesize to the appropriate cells.
--
--   miso <= misoo when misoe='1' ELSE 'Z';  -- tristate buffer
--   mosi <= mosio when mosie='1' ELSE 'Z';  -- tristate buffer
--   sck  <= scko  when scke ='1' ELSE 'Z';  -- tristate buffer

-----------------------------------------------------------------------
-- This product is licensed to:
-- ÇÑÈ«¼· of ÅÂÀÎ½Ã½ºÅÛ
-- for use at site(s):
-- tsi
--------------Revision History-----------------------------------------
-- $Log: vspi.vhd,v $
-- Revision 1.7  1999/09/09 16:02:37  scott
-- std_ulogic'ified, numeric_std'ified, RMM'ified
--
-- Revision 1.6  1999/02/17 00:51:50  eric
-- Added more checking on various error conditions.
--
-- Revision 1.5  1999/02/02 19:56:13  eric
-- Changes to fully sync to the CPU clock.
--
-- Revision 1.4  1998/10/16 13:54:57  eric
-- Corrected missing sensitiviy list signals for FIRST_BIT.
--
-- Revision 1.3  1998/09/30 14:56:56  eric
-- Initial release level.
--
-- Revision 1.2  1998/09/24 02:51:44  eric
-- Master mode works in phase=0.
-----------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all; -- we use IEEE standard 1164 logic types.
use ieee.numeric_std.all;    -- + and - operators

entity vspi is  ----------------------------ENTITY---------------------
  port(
    clk      : in  std_ulogic;   -- everything clocks on rising edge
    rst      : in  std_ulogic;   -- reset
    addr     : in  std_ulogic_vector(1 downto 0);  -- address bus
    datain   : in  std_ulogic_vector(7 downto 0);  -- data bus
    dataout  : out std_ulogic_vector(7 downto 0);  -- data bus
    write    : in  std_ulogic;   -- write enable
    chip_sel : in  std_ulogic;   -- device Select
    irq      : out std_ulogic;   -- interrupt request
    -- SPI interface without IO cells
    misoe    : out std_ulogic;   -- MISO tristate enable
    misoi    : in  std_ulogic;   -- Master in/Slave out data in
    misoo    : out std_ulogic;   -- MISO data out
    mosie    : out std_ulogic;   -- MOSI tristate enable
    mosii    : in  std_ulogic;   -- Master out/Slave in data in
    mosio    : out std_ulogic;   -- MOSI data out
    scke     : out std_ulogic;   -- SCK Clock tristate enable
    scki     : in  std_ulogic;
    -- SCK Clock input (shift register runs on this)
    scko     : out std_ulogic;   -- SCK clock output
    slvsele  : out std_ulogic;   -- tristate enable for slave selects
    slvselo  : out std_ulogic_vector(4 downto 0);
    -- external slave selects
    slvsel   : in  std_ulogic    -- Slave Select
    );
end vspi;

architecture empty of vspi is -------- ARCHITECTURE empty --------

  -- This architecture is provided to easily and quickly remove the SPI
  -- core for your ASIC or FPGA.

begin 
  dataout <= (others => '0');
  irq     <= '0';
  misoo   <= '0';
  misoe   <= '0';
  mosie   <= '0';
  mosio   <= '0';
  scko    <= '0';
  scke    <= '0';
  slvsele <= '0';
  slvselo <= "00000";
end empty;

architecture rtl of vspi is -----------ARCHITECTURE rtl-----------
  attribute sync_set_reset : string; -- required for synopsys
  attribute sync_set_reset of rst : signal is "true";
  -- required for synopsys

  signal bit_ctr     : std_ulogic_vector(2 downto 0);
  -- # bits in a byte
  signal ctl_reg     : std_ulogic_vector(7 downto 0);
  -- control register
  signal col_flag    : std_ulogic; -- collision flag
  signal dvd_ctr     : std_ulogic_vector(4 downto 0); -- clock divider
  signal dvd2        : std_ulogic;
  signal dvd_zero    : std_ulogic; -- clk divider controls
  signal irq_flag    : std_ulogic;
  -- local version of IRQ before gated with IRQENB
  signal master_mode : std_ulogic; -- Master mode when 1
  signal misoe_lcl   : std_ulogic; -- local version
  signal mosie_lcl   : std_ulogic; -- local version
  signal oflow       : std_ulogic;
  signal open_drain  : std_ulogic;
  signal phase       : std_ulogic;
  signal polck       : std_ulogic;
  signal sck_r1      : std_ulogic;
  signal sck_r2      : std_ulogic;
  signal sck_r3      : std_ulogic; -- synchronizers
  signal sel_clk     : std_ulogic_vector(1 downto 0);
  signal shift_reg   : std_ulogic_vector(7 downto 0);
  -- THE SPI shift register 
  signal shift_clk   : std_ulogic;
  signal shift_clk_negedge       : std_ulogic; -- negative edge of SCK
  signal shift_negative_edge_nxt : std_ulogic;
  signal shift_negative_edge     : std_ulogic;
  signal shift_datain  : std_ulogic;
  signal shift_dataout : std_ulogic;
  signal slvsel_r1     : std_ulogic;
  signal slvsel_r2     : std_ulogic;
  signal slvsel_r3     : std_ulogic; -- synchronizers
  signal spi_go        : std_ulogic; -- begin a transfer
  signal ssel          : std_ulogic_vector(7 downto 0);
  -- slave select register
  signal status        : std_ulogic_vector(7 downto 0);
  -- status register
  signal tx_end        : std_ulogic;
  -- TX has completed, TX_RUN will go low
  signal tx_run        : std_ulogic; -- tx is running
  signal tx_start      : std_ulogic;
  signal tx_start_r1   : std_ulogic;

begin   ---------------------------------------------------------------

  mosio <= shift_dataout when mosie_lcl='1' and open_drain='0' else
           '0'; 
  mosie <= mosie_lcl when open_drain='0' else
           '1' when mosie_lcl='1' and shift_dataout='0' else
           -- drive low when open drain enabled.
           '0';

  misoo <= shift_dataout when misoe_lcl='1' and open_drain='0' else
           '0'; 
  misoe <= misoe_lcl when open_drain='0' else
           '1' when misoe_lcl='1' and shift_dataout='0' else
           -- drive low when open drain enabled.
           '0';

  misoe_lcl <= '1' when master_mode='0' and slvsel='1' else
               '0';
  mosie_lcl <= '1' when master_mode='1' else
               '0';

  -- spi_go initiates a transfer - A write to the DOUT reg in master
  -- mode ignore the CPU write if we're already running.
  spi_go <= '1' when chip_sel='1' and write='1' and addr="00" and 
                     tx_run='0' and slvsel_r3='0' else
            '0';

  sr_proc : process(clk) -------------Shift register----------------
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        shift_reg <= "00000000";   -- sync reset
      else
        if (spi_go='1') then -- don't reload while running
          shift_reg  <= datain;    -- load with data from CPU
        elsif (shift_clk='1') then
          shift_reg <= shift_reg(6 downto 0) & shift_datain;
        end if;
      end if;
    end if;
  end process;

  neg_proc : process(clk) ----------Hold time register--------------
  begin
    if (clk'event and clk='1') then        -- negative edge pipeline DFF
      if (rst='1') then
        shift_negative_edge <= '0';     -- sync reset
      elsif (shift_clk_negedge='1') then
        shift_negative_edge  <= shift_negative_edge_nxt;
      elsif (spi_go='1') then
        shift_negative_edge  <= datain(7); -- preload for phase=0 mode
      end if;
    end if;
  end process;

  shift_negative_edge_nxt <= shift_reg(7) when phase='1' else
                             misoi when master_mode='1' else
                             mosii;

  shift_dataout <= shift_negative_edge when phase='1' else
                   -- add in the negative edge dff on phase=1
                   shift_reg(7);

  shift_datain <= shift_negative_edge when phase='0' else
                  -- insert the neg DFF in phase=0
                  misoi when master_mode='1' else
                  mosii;

  tr_proc : process(clk) ---------------TX run------------------
  -- this bit is active while a transmit is running
  begin
    if (clk'event and clk='1') then
      if (rst='1') then
        tx_run <= '0';     -- sync reset
      else
        if (tx_start='1') then
          tx_run  <= '1';
        elsif (tx_end='1') then
          tx_run <= '0';
        end if;
      end if;
    end if;
  end process;

  bc_proc : process (clk)
  begin -------------Bit counter for master mode----------------
    if (clk'event and clk='1') then
      if (rst='1') then -- sync reset
        bit_ctr <= "000"; 
      else
        if (tx_start='1') then
          bit_ctr <= ssel(7 downto 5);
        elsif (shift_clk='1') then
          bit_ctr <= std_ulogic_vector(unsigned(bit_ctr)-1);
        end if;
      end if;
    end if;
  end process; -- bit counter

  tx_end <= '1' when master_mode='1' and bit_ctr="001"
                     and shift_clk='1' and tx_run='1' else
            '0';
  tx_start <= '1' when master_mode='1' and spi_go='1' else
              '0';

  gjr_proc : process (clk)
  begin        ---------Control Register----------------------
    if (clk'event and clk='1') then
      if (rst='1') then -- sync reset
        ctl_reg <= "00000000"; 
      else
        if (chip_sel='1' and write='1' and addr="01") then -- load
          ctl_reg <= datain;
        end if;
      end if;
    end if;
  end process;

  -- map the control register to more meaningfull names
  master_mode <= ctl_reg(1);
  open_drain  <= ctl_reg(2);
  polck       <= ctl_reg(3);
  phase       <= ctl_reg(4);
  sel_clk     <= ctl_reg(6 downto 5);

  s_proc : process (clk)
  begin  ---------Slave Select Register-------------------------
    if (clk'event and clk='1') then
      if (rst='1') then -- sync reset
        ssel <= "00000000"; 
      else
        if (chip_sel='1' and write='1' and addr="11") then -- load
          ssel <= datain;
        end if;
      end if;
    end if;
  end process;
  slvselo <= ssel(4 downto 0);    -- drive the port
  slvsele <= master_mode;

  cf_proc : process (clk)
  begin ---------Collision flag bit---------------------------
    if (clk'event and clk='1') then
      if (rst='1') then
        col_flag <= '0';
      else
        if (master_mode='1' and slvsel_r3='1') then
          col_flag <= '1';        
        elsif (chip_sel='1' and write='1'
               and addr="10" and datain(5)='1') then
          col_flag <= '0';
        end if;
      end if;
    end if;
  end process;

  o_proc : process (clk)
  begin ---------OFLOw flag bit------------------------------
    if (clk'event and clk='1') then
      if (rst='1') then
        oflow <= '0';
      else
        if (chip_sel='1' and write='1' and addr="00" and
            -- write to DOUT
            (tx_run='1' or slvsel_r3='1')) then    -- and we're busy
          oflow <= '1';
        elsif (chip_sel='1' and write='1' and addr="10"
               and datain(6)='1') then
          oflow <= '0';
        end if;
      end if;
    end if;
  end process;

  elr_proc : process (clk)
  begin ---------IRQ flag bit------------------------------
    if (clk'event and clk='1') then
      if (rst='1') then
        irq_flag <= '0';
      else
        if (tx_end='1' or (slvsel_r2='0' and slvsel_r3='1')) then
          irq_flag <= '1';        
        elsif (chip_sel='1' and write='1' and addr="10"
               and datain(7)='1') then
          irq_flag <= '0';
        end if;
      end if;
    end if;
  end process;
  irq <= irq_flag and ctl_reg(7); -- gate with the IRQENB bit.

  flops_proc : process (clk)
  begin      ----------------various pipeline flops---------
    if (clk'event and clk='1') then
      slvsel_r3   <= slvsel_r2;
      slvsel_r2   <= slvsel_r1;         -- synchronizers
      slvsel_r1   <= slvsel;
      sck_r3      <= sck_r2;
      sck_r2      <= sck_r1;            -- synchronizers
      sck_r1      <= not scki xor polck;
      -- select the desired polarity of the slave clk
      tx_start_r1 <= tx_start;
    end if;
  end process;

  dvd_proc : process (clk) 
  begin----------------clock divider for clk generation-------
    -- create a 2x clock which creates 2 pulses.
    -- One for each edge of SCK.
    if (clk'event and clk='1') then
      if (not (tx_run='1' and master_mode='1') or tx_end='1') then
        -- divider only runs when sending data
        dvd_ctr <= "00000"; 
        dvd2 <= '0';
      else
        if (dvd_ctr="00000") then
          if (sel_clk="00") then
            dvd_ctr <= "00011";
          elsif (sel_clk="01") then
            dvd_ctr <= "00111";
          elsif (sel_clk="10") then
            dvd_ctr <= "01111";
          else
            dvd_ctr <= "11111";
          end if;
          if (tx_start_r1='0') then
            dvd2 <= not dvd2;
          end if;
        else
          dvd_ctr <= std_ulogic_vector(unsigned(dvd_ctr)-1);
        end if;
      end if;
    end if;
  end process; -- dvd
  dvd_zero <= '1' when dvd_ctr="00000" else
              '0';

  shift_clk <= dvd_zero and dvd2 and tx_run and not tx_start_r1 
               -- TX_START_R1 prevents data from shifting on the first
               -- clock in POLCK=1 mode which we don't want.We only get
               -- 7 clocks otherwise.
               when master_mode='1' else
               sck_r2 and not sck_r3;

  shift_clk_negedge <= dvd_zero and not dvd2 and tx_run
                       when master_mode='1'
                       else not sck_r2 and sck_r3;

  with addr select
    dataout <= -- dataout multiplexor for register readback
               shift_reg  when "00",
               ctl_reg    when "01",
               status     when "10",
               ssel       when "11",
               "XXXXXXXX" when others;

  -- assemble the bits that make up the status register
  status <= irq_flag & oflow & col_flag & "000" & tx_run & slvsel_r3;

  scke <= master_mode;
  scko <= dvd2 xor polck;

end rtl;
