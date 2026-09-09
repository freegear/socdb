library verilog;
use verilog.vl_types.all;
entity nfsspscalecntr is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        ssesync         : in     vl_logic;
        sspcpsr         : in     vl_logic_vector(7 downto 1);
        sspclkdiv       : out    vl_logic;
        sspcpsc         : out    vl_logic_vector(6 downto 0)
    );
end nfsspscalecntr;
