library verilog;
use verilog.vl_types.all;
entity I2C is
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 2);
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(15 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        I2cInt          : out    vl_logic_vector(1 downto 0);
        ISCL            : in     vl_logic_vector(1 downto 0);
        ISDA            : in     vl_logic_vector(1 downto 0);
        OSCL            : out    vl_logic_vector(1 downto 0);
        OSDA            : out    vl_logic_vector(1 downto 0)
    );
end I2C;
