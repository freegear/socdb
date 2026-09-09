-- --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : apbif.vhd.rca
-- File Revision          : 1.1
--
-- Release Information    : PrimeCell(TM)-GLOBAL-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : Converts ASB signals to APB signals with correct timing.
--
-- --=================================================================--

library ieee;
use     ieee.std_logic_1164.all;

-- include the Synopsys library when using Synopsys
--library synopsys;
--use     synopsys.attributes.all;

library common ;
use     common.defs.all ;
--#synth off
use     common.params.all ;
--#synth on

------------------------------------------------------------------------
--   Signal 
--   convention    Bxxxx    - this is an Advanced System Bus signal
--                 Pxxxx    - this is an Advanced Peripheral Bus signal
--                 Txxxx    - this is a Test Bus Signal
--                 Axxxx    - unidirectional signal related to the bus 
--                            Arbiter
--                 Dxxxx    - unidirectional signal related to the bus 
--                            Decoder
------------------------------------------------------------------------

entity apbif is
  port(
       BCLK          : in     std_ulogic;  -- Bus  clock
       BA            : in     std_logic_vector(31 downto 0); 
                                           -- System Address
       BnRES         : in     std_ulogic;  -- Reset Status, driven by 
                                           -- reset controller 
       BWRITE        : in     std_logic;   -- System bus write 
       DSEL          : in     std_ulogic;  -- Decoder selection 

       BD            : inout  std_logic_vector(31 downto 0); 
                                           -- Bi directional System Bus
       BWAIT         : out    std_logic;   -- Bus Wait signal
       BERROR        : out    std_logic;   -- Bus error signal 
       BLAST         : out    std_logic;   -- Last in sequence
 
       PWDATA        : out    std_ulogic_vector(31 downto 0); 
                                           -- Peripheral Write Data Bus
       PRDATA        : in     std_ulogic_vector(31 downto 0); 
                                           -- Peripheral Read Data Bus
       PA            : out    std_ulogic_vector(15 downto 0); 
                                           -- Peripheral address bus
       PWRITE        : out    std_ulogic;  -- Peripheral bus Write 
       PSTB          : out    std_ulogic;  -- Peripheral Strobe Signal 
       PSELRPC       : out    std_ulogic;  -- Peripheral select - Reset
                                           -- and Halt
       PSELIC        : out    std_ulogic;  -- Peripheral select - 
                                           -- Interrupt Controllers
       PSELUUT       : out    std_ulogic   -- Peripheral select - Unit 
                                           -- Under Test
       );
end apbif;


architecture behavioural of apbif is

-- include this attribute to get resettable latches when using Synopsys
--   attribute async_set_reset of BnRES : signal is "true";

   constant APB_AddressWidth : integer := 16;
   
   signal APBIFstate : APBIF_S;
   signal state      : APBIF_S;
   signal nextstate  : APBIF_S;
   signal B_WRITET2  : std_ulogic;       -- Pipelined BWRITE
   signal P_Aint     : std_ulogic_vector(APB_AddressWidth - 1 downto 0); 
                                         -- Internal PA

   signal B_Den      : std_ulogic;       -- BD tristate enable
   signal BWAITi     : std_logic;        -- Internal BWAIT
   signal BERRORi    : std_logic;
   signal B_WELen    : std_ulogic;       -- Enable for BWAIT, BERROR 
                                         -- and BLAST signals
   signal P_Data     : std_ulogic_vector(31 downto 0);-- Internal PD
   signal APBError   : std_ulogic;

   signal SELRPC      : std_ulogic;  
   signal SELIC       : std_ulogic;
   signal SELUUT0     : std_ulogic;
   signal SELUUT1     : std_ulogic;
   signal SELUUT2     : std_ulogic;
   signal SELUUT3     : std_ulogic;
   signal SELUUT4     : std_ulogic;
   signal SELUUT5     : std_ulogic;
   signal SELUUT6     : std_ulogic;
   signal SELUUT7     : std_ulogic;
   signal SELUUT8     : std_ulogic;
   signal SELUUT9     : std_ulogic;
   signal SELUUT10    : std_ulogic;

   signal PSELUUT0     : std_ulogic;
   signal PSELUUT1     : std_ulogic;
   signal PSELUUT2     : std_ulogic;
   signal PSELUUT3     : std_ulogic;
   signal PSELUUT4     : std_ulogic;
   signal PSELUUT5     : std_ulogic;
   signal PSELUUT6     : std_ulogic;
   signal PSELUUT7     : std_ulogic;
   signal PSELUUT8     : std_ulogic;
   signal PSELUUT9     : std_ulogic;
   signal PSELUUT10    : std_ulogic;

   signal PDen_Latchen : std_ulogic;
   signal B_WRITET2en  : std_ulogic;
   
begin 


------------------------------------------------------------------------
-- APB address decoding for slave devices goes here.
------------------------------------------------------------------------
   
   apbif_slave_decode : process (BA, DSEL)

   ---------------------------------------------------------------------
   -- EASY Peripherals decoding 
   -- Reset & Pause            0x88000000 to 0x8BFFFFFF
   constant RPCBase     : std_logic_vector(29 downto 26) := "0010";


   -- Interrupt Controller     0x80000000 to 0x83FFFFFF
   constant ICBase      : std_logic_vector(29 downto 26) := "0000"; 

   -- New peripherals should use the next available UUT*Base address.
   -- After a UUT*Base address has been selected assign the selected 
   -- PSELUUT* to the PSELUUT signal

   -- Uart                   0x8C000000
   constant UUT0Base    : std_logic_vector(29 downto 26) := "0011";

   -- Ssp                    0x90000000
   constant UUT1Base    : std_logic_vector(29 downto 26) := "0100";

   -- Rtc                    0x94000000
   constant UUT2Base    : std_logic_vector(29 downto 26) := "0101";

   constant UUT3Base    : std_logic_vector(29 downto 26) := "0110";
   constant UUT4Base    : std_logic_vector(29 downto 26) := "0111";
   constant UUT5Base    : std_logic_vector(29 downto 26) := "1000";
   constant UUT6Base    : std_logic_vector(29 downto 26) := "1001";
   constant UUT7Base    : std_logic_vector(29 downto 26) := "1010";
   constant UUT8Base    : std_logic_vector(29 downto 26) := "1011";
   constant UUT9Base    : std_logic_vector(29 downto 26) := "1100";
   constant UUT10Base   : std_logic_vector(29 downto 26) := "1101";

   ---------------------------------------------------------------------

   begin
   
       SELRPC <= '0';
       SELIC  <= '0';
       APBError <= '0' after GAT3;
       SELUUT0 <= '0';
       SELUUT1 <= '0';
       SELUUT2 <= '0';
       SELUUT3 <= '0';
       SELUUT4 <= '0';
       SELUUT5 <= '0';
       SELUUT6 <= '0';
       SELUUT7 <= '0';
       SELUUT8 <= '0';
       SELUUT9 <= '0';
       SELUUT10 <= '0';

     if DSEL = '1' then
       if    (BA(29 downto 26) = RPCBase) then
          SELRPC <= '1';
       elsif (BA(29 downto 26) = ICBase)  then
          SELIC  <= '1';
       elsif (BA(29 downto 26) = UUT0Base)  then
          SELUUT0  <= '1';
       elsif (BA(29 downto 26) = UUT1Base)  then
          SELUUT1  <= '1';
       elsif (BA(29 downto 26) = UUT2Base)  then
          SELUUT2  <= '1';
       elsif (BA(29 downto 26) = UUT3Base)  then
          SELUUT3  <= '1';
       elsif (BA(29 downto 26) = UUT4Base)  then
          SELUUT4  <= '1';
       elsif (BA(29 downto 26) = UUT5Base)  then
          SELUUT5  <= '1';
       elsif (BA(29 downto 26) = UUT6Base)  then
          SELUUT6  <= '1';
       elsif (BA(29 downto 26) = UUT7Base)  then
          SELUUT7  <= '1';
       elsif (BA(29 downto 26) = UUT8Base)  then
          SELUUT8  <= '1';
       elsif (BA(29 downto 26) = UUT9Base)  then
          SELUUT9  <= '1';
       elsif (BA(29 downto 26) = UUT10Base)  then
          SELUUT10  <= '1';
       else
          APBError <= '1' after GAT3;
       end if;
     end if;
   end process apbif_slave_decode;

   latch_sel : process (BCLK, APBIFstate, SELRPC, SELIC,
                        SELUUT0, SELUUT1, SELUUT2, SELUUT3, SELUUT4,
                        SELUUT5, SELUUT6, SELUUT7, SELUUT8, SELUUT9,
                        SELUUT10)
   begin 
      -- Latch select lines during high phase of wait state
      if (BCLK = '1') then
         if (APBIFstate = S_WAIT) then
            PSELRPC       <= SELRPC      after TLPG;
            PSELUUT0      <= SELUUT0     after TLPG;
            PSELUUT1      <= SELUUT1     after TLPG;
            PSELUUT2      <= SELUUT2     after TLPG;
            PSELUUT3      <= SELUUT3     after TLPG;
            PSELUUT4      <= SELUUT4     after TLPG;
            PSELUUT5      <= SELUUT5     after TLPG;
            PSELUUT6      <= SELUUT6     after TLPG;
            PSELUUT7      <= SELUUT7     after TLPG;
            PSELUUT8      <= SELUUT8     after TLPG;
            PSELUUT9      <= SELUUT9     after TLPG;
            PSELUUT10     <= SELUUT10    after TLPG;
            PSELIC        <= SELIC       after TLPG;
         elsif (APBIFstate = S_IDLE) then
            PSELRPC       <= '0'         after TLPG;
            PSELUUT0      <= '0'         after TLPG;
            PSELUUT1      <= '0'         after TLPG;
            PSELUUT2      <= '0'         after TLPG;
            PSELUUT3      <= '0'         after TLPG;
            PSELUUT4      <= '0'         after TLPG;
            PSELUUT5      <= '0'         after TLPG;
            PSELUUT6      <= '0'         after TLPG;
            PSELUUT7      <= '0'         after TLPG;
            PSELUUT8      <= '0'         after TLPG;
            PSELUUT9      <= '0'         after TLPG;
            PSELUUT10     <= '0'         after TLPG;
            PSELIC        <= '0'         after TLPG;
         end if;
      end if;
   end process latch_sel;

   -- assign the selected PSELUUT* to PSELUUT
   PSELUUT <= PSELUUT1;

   -- Alias P_Aint = PA
   PA <= P_Aint;

   -- Alias PWRITE = B_WRITET2
   PWRITE <= B_WRITET2;

   -- Alias APBIFstate = state
   APBIFstate <= state;

------------------------------------------------------------------------
-- Next state logic for APB state machine
------------------------------------------------------------------------
   nextstatep : process (BnRES, state, DSEL, APBError)
   begin
     if (BnRES = '0') then -- sync reset
       nextstate <= S_IDLE after GAT3;
     else
           case state is
             when S_IDLE =>           -- Idle state
               if (DSEL = '1') then   -- If selected, insert wait cycle
                 nextstate <= S_WAIT after GAT3;
               else
                 nextstate <= S_IDLE after GAT3;
               end if;
             when S_WAIT =>           -- Wait cycle to set up 
                                      -- address + data
               if (APBError = '1') then      
                 nextstate <= S_ERROR after GAT3;
               else
                 nextstate <= S_STROBE after GAT3;
               end if;
             when S_STROBE =>           -- Strobe cycle to complete 
                                        -- transaction
               if (DSEL = '1') then     -- Sequential, insert wait cycle
                 nextstate <= S_WAIT after GAT3;
               else
                 nextstate <= S_IDLE after GAT3;
               end if;
             when S_ERROR =>              -- undefined APB address area
               if (DSEL = '1') then       -- assert BERROR
                 nextstate <= S_WAIT after GAT3;
               else
                 nextstate <= S_IDLE after GAT3;
               end if;
             when others =>
               nextstate <= S_IDLE after GAT3;
           end case;
     end if;
   end process nextstatep;

-- APBIF state machine
   apbif_bsm : process (BCLK, BnRES)
   begin
     if (BnRES = '0') then
       state <= S_IDLE after DLPG;        -- Asynch reset
     elsif (BCLK'event and BCLK = '0') then
       state <= nextstate after DLPG;
     end if;
   end process apbif_bsm;

------------------------------------------------------------------------
-- State decoding
------------------------------------------------------------------------
   apbif_decode : process (BCLK,BnRES,state, BA, BD, BWRITE, B_WRITET2,
                           DSEL)
   begin
      if (BnRES = '0') then -- power on reset
         B_Den    <= '0' after GAT2;
         B_WELen  <= '0' after GAT2;
         PSTB     <= '0' after GAT2;
         BWAITi   <= '0' after GAT1;
         BERRORi  <= '0' after GAT1;
      else
         case state is
            when S_IDLE =>               -- Idle cycle
               B_Den    <= '0' after GAT2;
               PSTB    <= '0' after GAT2;
               BWAITi  <= '0' after GAT1;
               BERRORi <= '0' after GAT1;
               if (DSEL = '1' and BCLK = '0') then
                  B_WELen  <= '1' after GAT2;
               else
                  B_WELen  <= '0' after GAT2;
               end if;

            when S_WAIT =>       -- Wait cycle, set up PA & PD
               B_Den <= '0' after GAT2;
               if BCLK = '1' then   
--#synth off
                  if Is_X(BA(APB_AddressWidth - 1 downto 0)) then
                     assert FALSE
                     report "BA contains X's when accessing APB bridge"
                     severity error;
                  end if;

                  if Is_X(BWRITE) then
                     assert FALSE
                     report "BWRITE X when accessing APB bridge"
                     severity error;
                  end if;
--#synth on
               end if;
--#synth off
               if (Is_X(BD) and falling_edge(BCLK) and BWRITE = '1') 
                                                                   then
                  assert FALSE 
                  report "BD contains X's when writing to APB bridge" 
                  severity error;
               end if;
--#synth on
               BWAITi <= '1' after GAT1;
               BERRORi <= '0' after GAT1;
               if (DSEL = '1' and BCLK = '0') then
                  B_WELen  <= '1' after GAT2;
               else
                  B_WELen  <= '0' after GAT2;
               end if;
               PSTB <= '0' after GAT2;

            when S_STROBE =>        -- strobe cycle
               PSTB <= '1' after GAT2;
               BWAITi  <= '0' after GAT1;
               BERRORi <= '0' after GAT1;
               if (DSEL = '1' and BCLK = '0') then
                  B_WELen  <= '1' after GAT2;
               else
                  B_WELen  <= '0' after GAT2;
               end if;
               if (B_WRITET2 = '0') then
                 B_Den <= '1' after GAT2;
               else
                 B_Den <= '0' after GAT2;
               end if;

            when S_ERROR =>
               PSTB    <= '0' after GAT2;
               BWAITi  <= '0' after GAT1;
               B_Den   <= '0' after GAT2;
               BERRORi <= '1' after GAT1;
               if (DSEL = '1' and BCLK = '0') then
                  B_WELen  <= '1' after GAT2;
               else
                  B_WELen  <= '0' after GAT2;
               end if;
         end case;
      end if;
  end process apbif_decode;

-- P_Den/BD Latch enable
  PDen_Latchen <= '1' after GAT2 when (BCLK = '1' and    
                  state = S_WAIT and BWRITE = '1') else
                  '0' after GAT2;

-- B_WRITET2/BA Latch enable
  B_WRITET2en <= '1' after GAT2 when (BCLK = '1' and 
                 state = S_WAIT) else
                 '0' after GAT2;

-- Latch BWRITE
  B_WRITET2_Latch : process (B_WRITET2en, BWRITE)
  begin
    if (B_WRITET2en = '1') then
      B_WRITET2 <= BWRITE after TLPG;
    end if;
  end process B_WRITET2_Latch;

-- Latch BA
  P_Aint_Latch : process (B_WRITET2en, BA)
  begin
    if (B_WRITET2en = '1') then
      P_Aint <= std_ulogic_vector(BA(APB_AddressWidth - 1 downto 0)) 
                                                             after TLPG;
    end if;
  end process P_Aint_Latch;

-- Latch BD
  P_Data_Latch : process (PDen_Latchen, BD)
  begin
    if (PDen_Latchen = '1') then
      P_Data <= To_X01(To_stdulogicvector(BD)) after TLPG;
    end if;
  end process P_Data_Latch;

  PWDATA <= P_Data after BUSE;

------------------------------------------------------------------------
-- Tristate drivers
------------------------------------------------------------------------
   Tri_BD_Drive : process(PRDATA, B_Den)
   begin
      if (B_Den = '1') then
         BD <= To_X01(To_stdlogicvector(PRDATA)) after BUSE;
      else
         BD <= (others => 'Z') after BUSD;
      end if;
   end process Tri_BD_Drive;

   Tri_resp_Drive : process(BWAITi, B_WELen, BERRORi)
   begin
      if (B_WELen  = '1') then
         BWAIT  <= BWAITi after BUSE;
         BERROR <= BERRORi after BUSE;
         BLAST  <= '0' after BUSE;
      else
         BWAIT  <= 'Z' after BUSD;
         BERROR <= 'Z' after BUSD;
         BLAST  <= 'Z' after BUSD;
      end if;
   end process Tri_resp_Drive;

end behavioural;

-- --============================== End ==============================--
