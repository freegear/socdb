library verilog;
use verilog.vl_types.all;
entity ERREG is
    port(
        EDB             : in     vl_logic_vector(19 downto 0);
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        ERLRS           : in     vl_logic;
        ERS2            : in     vl_logic;
        ERS1            : in     vl_logic;
        ERLE            : in     vl_logic;
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        ERO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end ERREG;
