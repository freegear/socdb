library verilog;
use verilog.vl_types.all;
entity EOREG is
    port(
        EDB             : in     vl_logic_vector(19 downto 0);
        SOBWS           : in     vl_logic_vector(1 downto 0);
        EOBLE           : in     vl_logic;
        XRST            : in     vl_logic;
        ENP             : in     vl_logic;
        ESYNC           : in     vl_logic;
        TE              : in     vl_logic;
        MCK             : in     vl_logic;
        EOLE            : in     vl_logic;
        EOS1            : in     vl_logic;
        EOS0            : in     vl_logic;
        TI              : in     vl_logic;
        EOO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic;
        LRCK            : out    vl_logic;
        SCK             : out    vl_logic;
        SDO2            : out    vl_logic;
        SDO1            : out    vl_logic
    );
end EOREG;
