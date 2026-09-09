library verilog;
use verilog.vl_types.all;
entity IntMem is
    generic(
        MemBits         : integer := 10;
        FileName        : string  := "intram.dat"
    );
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HADDR           : in     vl_logic_vector(31 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HSELIntMem      : in     vl_logic;
        HREADY          : in     vl_logic;
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HREADYOUT       : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0)
    );
end IntMem;
