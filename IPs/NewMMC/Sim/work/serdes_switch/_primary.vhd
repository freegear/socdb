library verilog;
use verilog.vl_types.all;
entity serdes_switch is
    port(
        mcstate         : in     vl_logic_vector(4 downto 0);
        mclk            : in     vl_logic;
        mresetn         : in     vl_logic;
        mcs             : in     vl_logic;
        mcmdin          : in     vl_logic;
        mdatin          : in     vl_logic_vector(7 downto 0);
        cmdin           : out    vl_logic;
        datin           : out    vl_logic_vector(7 downto 0)
    );
end serdes_switch;
