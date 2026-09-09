library verilog;
use verilog.vl_types.all;
entity flexible_lvds_rx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4
    );
    port(
        rx_in           : in     vl_logic_vector;
        rx_fastclk      : in     vl_logic;
        rx_slowclk      : in     vl_logic;
        rx_locked       : in     vl_logic;
        rx_out          : out    vl_logic_vector
    );
end flexible_lvds_rx;
