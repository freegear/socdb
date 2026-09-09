library verilog;
use verilog.vl_types.all;
entity EEMDEC is
    port(
        EEMRWC          : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        EEMEND          : in     vl_logic;
        EEMST           : in     vl_logic;
        CK              : in     vl_logic;
        EN              : in     vl_logic;
        EEMCE           : out    vl_logic;
        EEMDS           : out    vl_logic;
        EIMAE           : out    vl_logic;
        EEMACE          : out    vl_logic;
        \TO\            : out    vl_logic;
        EEMDILE         : out    vl_logic;
        EEMDOLE         : out    vl_logic;
        EEMALE          : out    vl_logic;
        XEEMWE          : out    vl_logic
    );
end EEMDEC;
