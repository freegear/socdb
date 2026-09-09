library verilog;
use verilog.vl_types.all;
entity I2CTop is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(1 downto 0);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        int             : out    vl_logic;
        SCL_i           : in     vl_logic;
        SCL_o           : out    vl_logic;
        nSCL_En         : out    vl_logic;
        SDA_i           : in     vl_logic;
        SDA_o           : out    vl_logic;
        nSDA_En         : out    vl_logic
    );
end I2CTop;
