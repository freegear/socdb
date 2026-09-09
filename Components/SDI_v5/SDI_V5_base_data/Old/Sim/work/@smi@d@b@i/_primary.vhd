library verilog;
use verilog.vl_types.all;
entity SmiDBI is
    port(
        nSMCDATAEN      : in     vl_logic_vector(3 downto 0);
        TICREAD         : in     vl_logic;
        SMCDATAOUT      : in     vl_logic_vector(31 downto 0);
        HRDATATIC       : in     vl_logic_vector(31 downto 0);
        nSMDATAEN       : out    vl_logic_vector(3 downto 0);
        SMDATAOUT       : out    vl_logic_vector(31 downto 0)
    );
end SmiDBI;
