library verilog;
use verilog.vl_types.all;
entity SspScaleCntr is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        SSESync         : in     vl_logic;
        SSPCPSR         : in     vl_logic_vector(7 downto 1);
        SSPCLKDIV       : out    vl_logic;
        SSPCPSC         : out    vl_logic_vector(6 downto 0)
    );
end SspScaleCntr;
