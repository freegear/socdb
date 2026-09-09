library verilog;
use verilog.vl_types.all;
entity sram8bit is
    generic(
        taa             : integer := 15;
        tacs            : integer := 15;
        tclz            : integer := 4;
        tchz            : integer := 7;
        toe             : integer := 7;
        tohz            : integer := 6;
        toh             : integer := 4;
        taw             : integer := 10;
        tcw             : integer := 10;
        tas             : integer := 0;
        twp             : integer := 10;
        tdw             : integer := 7;
        tow             : integer := 4;
        twhz            : integer := 6
    );
    port(
        data            : inout  vl_logic_vector(7 downto 0);
        addr            : in     vl_logic_vector(17 downto 0);
        we_n            : in     vl_logic;
        oe_n            : in     vl_logic;
        cs_n            : in     vl_logic
    );
end sram8bit;
