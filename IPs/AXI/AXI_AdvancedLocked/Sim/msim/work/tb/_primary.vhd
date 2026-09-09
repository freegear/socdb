library verilog;
use verilog.vl_types.all;
entity tb is
    generic(
        CLK_HALFPERIOD  : integer := 5;
        BUS_WID         : integer := 32;
        ADDR_WID        : integer := 32;
        ID_WID          : integer := 4;
        AWLEN_WID       : integer := 4;
        AWSIZE_WID      : integer := 3;
        AWBURST_WID     : integer := 2;
        AWLOCK_WID      : integer := 2;
        AWCACHE_WID     : integer := 4;
        AWPROT_WID      : integer := 3;
        WSTRB_WID       : integer := 4;
        BRESP_WID       : integer := 2;
        RRESP_WID       : integer := 2;
        ARLEN_WID       : integer := 4;
        ARSIZE_WID      : integer := 3;
        ARBURST_WID     : integer := 2;
        ARLOCK_WID      : integer := 2;
        ARCACHE_WID     : integer := 4;
        ARPROT_WID      : integer := 3;
        MASTERWID       : integer := 4;
        SLAVEWID        : integer := 3
    );
end tb;
