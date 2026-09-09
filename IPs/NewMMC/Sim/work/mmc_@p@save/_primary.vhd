library verilog;
use verilog.vl_types.all;
entity mmc_psave is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        ckpulse         : in     vl_logic;
        cmst            : in     vl_logic;
        enclk_reg       : in     vl_logic;
        enclk_fifo      : in     vl_logic;
        cmdctrlidle     : in     vl_logic;
        busychkidle     : in     vl_logic;
        datctrlidle     : in     vl_logic;
        psaveon         : in     vl_logic;
        enclk           : out    vl_logic
    );
end mmc_psave;
