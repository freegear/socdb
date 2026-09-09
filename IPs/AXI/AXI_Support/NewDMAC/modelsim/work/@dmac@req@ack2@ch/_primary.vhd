library verilog;
use verilog.vl_types.all;
entity dmacreqack2ch is
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        dmareq          : in     vl_logic_vector(1 downto 0);
        dmaack          : out    vl_logic_vector(1 downto 0);
        start           : out    vl_logic;
        ready           : in     vl_logic;
        active          : out    vl_logic_vector(1 downto 0);
        memory2memory   : in     vl_logic_vector(1 downto 0);
        enabled         : in     vl_logic_vector(1 downto 0)
    );
end dmacreqack2ch;
