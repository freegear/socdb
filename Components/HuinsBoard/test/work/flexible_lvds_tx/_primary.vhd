library verilog;
use verilog.vl_types.all;
entity flexible_lvds_tx is
    generic(
        number_of_channels: integer := 1;
        deserialization_factor: integer := 4;
        registered_input: string  := "ON"
    );
    port(
        tx_in           : in     vl_logic_vector;
        tx_fastclk      : in     vl_logic;
        tx_slowclk      : in     vl_logic;
        tx_regclk       : in     vl_logic;
        tx_locked       : in     vl_logic;
        tx_out          : out    vl_logic_vector
    );
end flexible_lvds_tx;
