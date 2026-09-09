library verilog;
use verilog.vl_types.all;
entity Tube is
    generic(
        CR              : integer := 13;
        LF              : integer := 10;
        CTRLD           : integer := 4
    );
    port(
        XD              : in     vl_logic_vector(31 downto 0);
        XCSN            : in     vl_logic_vector(3 downto 0);
        XWEN            : in     vl_logic_vector(3 downto 0)
    );
end Tube;
