-- VHDL Model Created from SGE Symbol stdio_ta01.sym -- Sep 17 14:41:10 2003

library IEEE;
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_misc.all;
   use IEEE.std_logic_arith.all;

entity STDIO_TA01 is
      Port (     CLK : In    std_logic;
                  DA : In    std_logic_vector (31 downto 0);
               DDOUT : In    std_logic_vector (31 downto 0);
              DNMREQ : In    std_logic;
                DNRW : In    std_logic;
               RESET : In    std_logic;
                DDIN : Out   std_logic_vector (31 downto 0) );
end STDIO_TA01;

architecture VHPI of STDIO_TA01 is
  attribute foreign of VHPI :
    architecture is "vhpi:stdio_ta01-O:stdio_ta01_elab:stdio_ta01_init:stdio_ta01";
   begin

end VHPI;

configuration CFG_STDIO_TA01 of STDIO_TA01 is
   for VHPI

   end for;

end CFG_STDIO_TA01;
