library verilog;
use verilog.vl_types.all;
entity mmc is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        mclk            : in     vl_logic;
        mcs             : in     vl_logic;
        mcmdin          : in     vl_logic;
        mcmdout         : out    vl_logic;
        mcmdouten       : out    vl_logic;
        mdatin          : in     vl_logic_vector(7 downto 0);
        mdatout         : out    vl_logic_vector(7 downto 0);
        mdatouten       : out    vl_logic
    );
end mmc;
