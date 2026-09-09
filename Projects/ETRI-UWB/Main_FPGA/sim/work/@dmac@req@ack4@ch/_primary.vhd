library verilog;
use verilog.vl_types.all;
entity DmacReqAck4Ch is
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        DMAReq          : in     vl_logic_vector(3 downto 0);
        DMAAck          : out    vl_logic_vector(3 downto 0);
        Start           : out    vl_logic;
        Ready           : in     vl_logic;
        Active          : out    vl_logic_vector(3 downto 0);
        Memory2Memory   : in     vl_logic_vector(3 downto 0);
        Enabled         : in     vl_logic_vector(3 downto 0)
    );
end DmacReqAck4Ch;
