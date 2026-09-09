library verilog;
use verilog.vl_types.all;
entity VideoEncTop is
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(5 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        HSYNCn          : in     vl_logic;
        VSYNCn          : in     vl_logic;
        BLANKn          : in     vl_logic;
        Rin             : in     vl_logic_vector(7 downto 0);
        Gin             : in     vl_logic_vector(7 downto 0);
        Bin             : in     vl_logic_vector(7 downto 0);
        DAC0_ENABLE     : out    vl_logic;
        DAC1_ENABLE     : out    vl_logic;
        DAC2_ENABLE     : out    vl_logic;
        DAC0_DATA       : out    vl_logic_vector(9 downto 0);
        DAC1_DATA       : out    vl_logic_vector(9 downto 0);
        DAC2_DATA       : out    vl_logic_vector(9 downto 0)
    );
end VideoEncTop;
