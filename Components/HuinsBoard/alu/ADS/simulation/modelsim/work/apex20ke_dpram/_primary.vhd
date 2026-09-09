library verilog;
use verilog.vl_types.all;
entity apex20ke_dpram is
    generic(
        operation_mode  : string  := "single_port";
        output_mode     : string  := "reg";
        width           : integer := 32;
        addrwidth       : integer := 14;
        depth           : integer := 16384;
        ramblock        : integer := 65535;
        ramcontent      : string  := ""
    );
    port(
        portadatain     : in     vl_logic_vector(63 downto 0);
        portadataout    : out    vl_logic_vector(63 downto 0);
        portaaddr       : in     vl_logic_vector(16 downto 0);
        portawe         : in     vl_logic;
        portaena        : in     vl_logic;
        portaclk        : in     vl_logic;
        portbdatain     : in     vl_logic_vector(15 downto 0);
        portbdataout    : out    vl_logic_vector(15 downto 0);
        portbaddr       : in     vl_logic_vector(14 downto 0);
        portbwe         : in     vl_logic;
        portbena        : in     vl_logic;
        portbclk        : in     vl_logic
    );
end apex20ke_dpram;
