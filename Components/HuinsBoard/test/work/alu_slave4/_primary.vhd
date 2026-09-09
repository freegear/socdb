library verilog;
use verilog.vl_types.all;
entity alu_slave4 is
    port(
        HCLOCK          : in     vl_logic;
        HSEL            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HWRITE          : in     vl_logic;
        HADDRESS        : in     vl_logic_vector(31 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HSIZE           : in     vl_logic_vector(1 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HREADY          : out    vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HRESP           : out    vl_logic_vector(1 downto 0);
        testout         : out    vl_logic_vector(7 downto 0);
        DATA_AVAIL      : in     vl_logic;
        DATA_A          : in     vl_logic;
        DATA_B          : in     vl_logic;
        DATA_C          : in     vl_logic;
        DATA_D          : in     vl_logic;
        Int_PLD         : out    vl_logic
    );
end alu_slave4;
