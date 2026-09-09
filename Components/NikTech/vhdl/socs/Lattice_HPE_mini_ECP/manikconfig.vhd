library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.all;

-- synopsys translate_off
library std;
use STD.textio.All;
-- synopsys translate_on

package manikconfig is
    

    constant CONFIG_BAUD_RATE         : integer := 115200;
    constant CONFIG_RAM_ADDR_W        : integer := 18;
    constant CONFIG_COUNT_READ        : integer := 1;
    constant CONFIG_COUNT_WRITE       : integer := 0;
    constant CONFIG_SRAM_ADDR_W       : integer := 18;
    constant CONFIG_ICACHE_ENABLED    : boolean := true;
    constant CONFIG_DCACHE_ENABLED    : boolean := true;
    constant CONFIG_ICACHE_LINE_WORDS : integer := 1;
    constant CONFIG_DCACHE_LINE_WORDS : integer := 1;
    constant CONFIG_ICACHE_ADDR_WIDTH : integer := 10;
    constant CONFIG_DCACHE_ADDR_WIDTH : integer := 10;
    constant CONFIG_UINST_WIDTH       : integer := 32;
    constant CONFIG_TIMER_WIDTH       : integer := 32;
    constant CONFIG_TIMER_CLK_DIV     : integer := 0;
    constant CONFIG_INTR_VECBASE      : integer := 0;
    constant CONFIG_INTR_SWIVEC       : integer := 4;
    constant CONFIG_INTR_TMRVEC       : integer := 8;
    constant CONFIG_INTR_EXTVEC       : integer := 12;
    constant CONFIG_BASE_ROW          : integer := 0;
    constant CONFIG_BASE_COL          : integer := 2;
    constant CONFIG_USER_INST         : Boolean := True;
    constant CONFIG_SHIFT_SWIDTH      : integer := 4;
    constant CONFIG_MULT_BWIDTH       : integer := 32;
    constant CONFIG_HW_WPENB          : boolean := false;
    constant CONFIG_HW_BPENB 	      : boolean := false;

        
    -- clock related constants
    constant IN_FREQ_MHZ   : integer := 25;  -- input clock frequency in MHZ
    constant CORE_FREQ_MHZ : integer := 50;  -- core frequency in MHZ
    constant CLK_MULBY     : integer := 2;
    constant CLK_DIVBY     : integer := 1;
    constant CLKIN_FREQ    : natural := 1000000/IN_FREQ_MHZ; 
    constant CLKIN_PERIOD  : real    := real(1000/IN_FREQ_MHZ);         
    
    -- configuration globals
    constant Technology    : string  := "LATTICE";
    constant Lattice_Family: string  := "ECP";
    
    constant FPGA_Family : string  := "Virtex2";    
    constant Altera_Family : string  := "Stratix";
    constant Actel_Family  : string  := "APA3";
    
    constant RESET_POS : boolean := false;  -- true when reset active high
    
    constant ADDR_WIDTH        : integer := 32;

    
    -- signal monitoring , debugging & tracing related signals
--    constant DEBUG_WIDTH  : integer := 80;
--    constant DEBUGCORE    : Boolean := True;
--    constant DEBUGSRAMILA : Boolean := False;
--    constant DEBUGCOREILA : Boolean := False;
--    signal   debug_out    : std_logic_vector(DEBUG_WIDTH-1 downto 0);
--    signal   sfr_expc     : std_logic_vector (ADDR_WIDTH-1 downto 0);

end manikconfig;
