library verilog;
use verilog.vl_types.all;
entity sram16bit is
    generic(
        Taa             : integer := 10;
        Tacs            : integer := 10;
        Tclz            : integer := 4;
        Tchz            : integer := 5;
        Toe             : integer := 5;
        Tohz            : integer := 5;
        Toh             : integer := 4;
        Tbe             : integer := 5;
        Taw             : integer := 8;
        Tcw             : integer := 8;
        Tbw             : integer := 8;
        Tas             : integer := 0;
        Twp             : integer := 8;
        Tdw             : integer := 5;
        Tow             : integer := 3;
        Twhz            : integer := 6
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
