library verilog;
use verilog.vl_types.all;
entity stripe is
    port(
        clk_ref         : in     vl_logic;
        npor            : in     vl_logic;
        nreset          : inout  vl_logic;
        masterhclk      : in     vl_logic;
        masterhready    : in     vl_logic;
        masterhgrant    : in     vl_logic;
        masterhrdata    : in     vl_logic_vector(31 downto 0);
        masterhresp     : in     vl_logic_vector(1 downto 0);
        masterhwrite    : out    vl_logic;
        masterhlock     : out    vl_logic;
        masterhbusreq   : out    vl_logic;
        masterhaddr     : out    vl_logic_vector(31 downto 0);
        masterhburst    : out    vl_logic_vector(2 downto 0);
        masterhsize     : out    vl_logic_vector(1 downto 0);
        masterhtrans    : out    vl_logic_vector(1 downto 0);
        masterhwdata    : out    vl_logic_vector(31 downto 0)
    );
end stripe;
