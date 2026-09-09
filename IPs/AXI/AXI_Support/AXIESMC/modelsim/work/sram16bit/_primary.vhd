library verilog;
use verilog.vl_types.all;
entity sram16bit is
    generic(
        taa             : integer := 10;
        tacs            : integer := 10;
        tclz            : integer := 4;
        tchz            : integer := 5;
        toe             : integer := 5;
        tohz            : integer := 5;
        toh             : integer := 4;
        tbe             : integer := 5;
        taw             : integer := 8;
        tcw             : integer := 8;
        tbw             : integer := 8;
        tas             : integer := 0;
        twp             : integer := 8;
        tdw             : integer := 5;
        tow             : integer := 3;
        twhz            : integer := 6
    );
    port(
        data            : inout  vl_logic_vector(15 downto 0);
        addr            : in     vl_logic_vector(17 downto 0);
        we_n            : in     vl_logic;
        oe_n            : in     vl_logic;
        cs_n            : in     vl_logic;
        ble_n           : in     vl_logic;
        bhe_n           : in     vl_logic
    );
end sram16bit;
