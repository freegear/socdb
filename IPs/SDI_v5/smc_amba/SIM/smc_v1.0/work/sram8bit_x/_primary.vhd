library verilog;
use verilog.vl_types.all;
entity sram8bit_x is
    generic(
        Taa             : integer := 15;
        Tacs            : integer := 15;
        Tclz            : integer := 4;
        Tchz            : integer := 7;
        Toe             : integer := 7;
        Tohz            : integer := 6;
        Toh             : integer := 4;
        Taw             : integer := 10;
        Tcw             : integer := 10;
        Tas             : integer := 0;
        Twp             : integer := 10;
        Tdw             : integer := 7;
        Tow             : integer := 4;
        Twhz            : integer := 6
    );
    port(
        data            : inout  vl_logic_vector(7 downto 0);
        addr            : in     vl_logic_vector(17 downto 0);
        we_n            : in     vl_logic;
        oe_n            : in     vl_logic;
        cs_n            : in     vl_logic
    );
end sram8bit_x;
