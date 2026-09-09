library verilog;
use verilog.vl_types.all;
entity ESPCV is
    port(
        MCHS            : in     vl_logic;
        SDI2            : in     vl_logic;
        XRST            : in     vl_logic;
        TI              : in     vl_logic;
        ESYNC           : in     vl_logic;
        ENP             : in     vl_logic;
        TE              : in     vl_logic;
        SDI1            : in     vl_logic;
        MCK             : in     vl_logic;
        LRS             : in     vl_logic;
        SPCO            : out    vl_logic_vector(19 downto 0);
        LRCK            : out    vl_logic;
        SCK             : out    vl_logic;
        \TO\            : out    vl_logic
    );
end ESPCV;
