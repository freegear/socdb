library verilog;
use verilog.vl_types.all;
entity mmc_delay is
    port(
        mcmdout         : in     vl_logic;
        mcmdouten       : in     vl_logic;
        mdatout         : in     vl_logic_vector(7 downto 0);
        mdatouten       : in     vl_logic;
        mcselect        : in     vl_logic;
        bus1            : in     vl_logic;
        bus4            : in     vl_logic;
        bus8            : in     vl_logic;
        cmd_index       : in     vl_logic_vector(5 downto 0);
        mcmdout_dly     : out    vl_logic;
        mcmdouten_dly   : out    vl_logic;
        mdatout_dly     : out    vl_logic_vector(7 downto 0);
        mdatouten_dly   : out    vl_logic;
        houtdly         : in     vl_logic_vector(5 downto 0)
    );
end mmc_delay;
