library verilog;
use verilog.vl_types.all;
entity GPDEC is
    port(
        A               : in     vl_logic_vector(10 downto 0);
        WM              : out    vl_logic;
        CHO             : out    vl_logic;
        WSIP            : out    vl_logic;
        \MOD\           : out    vl_logic;
        PM              : out    vl_logic;
        SYS             : out    vl_logic
    );
end GPDEC;
