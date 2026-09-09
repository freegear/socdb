--------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1998 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : apbmux.vhd,v
--  File Revision          : 1.2
--
--  Release Information    : PL050-REL1v1
--
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--  Purpose          : Mux for APB Data Reads
-- --=========================================================================--

library ieee;
use     ieee.std_logic_1164.all;

library buswatcher;
use buswatcher.busw_pck.all;

entity apbmux is
  port(
       BCLK        : in std_logic;
       BnRES       : in std_logic;
       PSEL        : in std_logic; 
       PSELT       : in std_logic; 
       PRData0     : in std_logic_vector(31 downto 0);
       PRData1     : in std_logic_vector(31 downto 0);
       PRData      : out std_logic_vector(31 downto 0)
       );

end apbmux;

architecture behavioural of apbmux is

signal MuxSel     : std_logic_vector(1 downto 0);
signal Res_stored : std_logic;
signal Res_sig    : std_logic;

constant ZERO     : std_logic_vector(31 downto 0)
                    := "00000000000000000000000000000000";

constant Data_check : boolean := FALSE; -- Set this constant to FALSE if PRDATA 
                                        -- checking has to be disabled

begin


    MuxSel <= PSELT & PSEL;

    p_Res_store : process (BnRES)
    begin
      Res_stored <= BnRES;
      if (BnRES'event and BnRES = '1' and Res_stored = '0') then
        Res_sig <= '1';
      end if;
    end process p_Res_store;

    p_DataMux : process (MuxSel ,PRData0 ,PRData1)  
    begin
       case MuxSel is
         when "00"    =>  PRData <= (others => '0');
         when "01"    =>  PRData <= PRData0;
         when "10"    =>  PRData <= PRData1;
         when others  =>  PRData <= (others => '0');
       end case;
 
       if (Muxsel = "11") then
         assert false
           report "PSEL and PSELT asserted at the same time"
           severity error;
       end if;
    end process p_DataMux;

    p_Check_DATA0 : process (BCLK)
    begin
      if (PSEL/= '1' and PRDATA0 /= ZERO and Res_sig = '1' and Data_check) then
        if (BCLK'event and BCLK = '1') then
         errhandler(
         "PDRO: PRDATA has non-zero value on rising BCLK when UUT not selected",
          error);
        elsif (BCLK'event and BCLK = '0') then
         errhandler(
        "PDF0: PRDATA has non-zero value on falling BCLK when UUT not selected",
         error);
        end if;
      end if;
    end process p_Check_DATA0;

    p_Check_DATA1 : process (BCLK)
    begin
      if (PSELT/= '1' and PRDATA1 /= ZERO and Res_sig = '1' and Data_check) then
        if (BCLK'event and BCLK = '1') then
         errhandler(
         "PDRO: PRDATA has non-zero value on rising BCLK when Trickbox not selected",
          error);
        elsif (BCLK'event and BCLK = '0') then
         errhandler(
         "PDF0: PRDATA has non-zero value on falling BCLK when Trickbox not selected",
         error);
        end if;
      end if;
    end process p_Check_DATA1;
  
end behavioural;

-- --================================= End ===================================--
