library verilog;
use verilog.vl_types.all;
entity sp_ctrl is
    generic(
        ADDRWIDTH       : integer := 16;
        DATAWIDTH       : integer := 8;
        RUN_SM_WIDTH    : integer := 3;
        \RUN\           : integer := 0;
        ACC             : integer := 1;
        \WAIT\          : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        set_addr        : in     vl_logic;
        acc_addr        : in     vl_logic_vector;
        write           : in     vl_logic;
        wdata           : in     vl_logic_vector;
        read            : in     vl_logic;
        rdata           : out    vl_logic_vector;
        run             : in     vl_logic;
        bus_addr        : in     vl_logic_vector;
        fetch           : in     vl_logic;
        restart         : out    vl_logic;
        spc_cs          : out    vl_logic;
        spc_addr        : out    vl_logic_vector;
        spc_read        : out    vl_logic;
        spc_write       : out    vl_logic;
        spc_dataout     : out    vl_logic_vector;
        spc_datain      : in     vl_logic_vector
    );
end sp_ctrl;
