library verilog;
use verilog.vl_types.all;
entity Memory is
    port(
        XA              : in     vl_logic_vector(30 downto 0);
        XCSN            : in     vl_logic_vector(3 downto 0);
        XWEN            : in     vl_logic_vector(3 downto 0);
        XOEN            : in     vl_logic;
        XD              : inout  vl_logic_vector(31 downto 0)
    );
end Memory;
