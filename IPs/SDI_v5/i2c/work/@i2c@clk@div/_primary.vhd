library verilog;
use verilog.vl_types.all;
entity I2cClkDiv is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        CCR             : in     vl_logic_vector(6 downto 0);
        ClkEnab         : out    vl_logic;
        MaClkEnab       : out    vl_logic
    );
end I2cClkDiv;
