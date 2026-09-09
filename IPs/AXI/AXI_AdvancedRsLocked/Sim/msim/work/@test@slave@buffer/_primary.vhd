library verilog;
use verilog.vl_types.all;
entity TestSlaveBuffer is
    generic(
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
        MASTER_WID      : integer := 4;
        SLAVE_WID       : integer := 3;
        SLAVE_NUM       : integer := 6;
        MASTER_NUM      : integer := 4;
        SLAVECNTWID     : integer := 5;
        REQDEPTH_WID    : integer := 2
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        AWIDts2s        : out    vl_logic_vector;
        AWADDRts2s      : out    vl_logic_vector;
        AWLENts2s       : out    vl_logic_vector;
        AWSIZEts2s      : out    vl_logic_vector;
        AWBURSTts2s     : out    vl_logic_vector;
        AWLOCKts2s      : out    vl_logic_vector;
        AWCACHEts2s     : out    vl_logic_vector;
        AWPROTts2s      : out    vl_logic_vector;
        AWVALIDts2s     : out    vl_logic;
        AWREADYs2ts     : in     vl_logic;
        AWIDmi2ts       : in     vl_logic_vector;
        AWADDRmi2ts     : in     vl_logic_vector;
        AWLENmi2ts      : in     vl_logic_vector;
        AWSIZEmi2ts     : in     vl_logic_vector;
        AWBURSTmi2ts    : in     vl_logic_vector;
        AWLOCKmi2ts     : in     vl_logic_vector;
        AWCACHEmi2ts    : in     vl_logic_vector;
        AWPROTmi2ts     : in     vl_logic_vector;
        AWVALIDmi2ts    : in     vl_logic;
        AWREADYts2mi    : out    vl_logic;
        BVALID          : in     vl_logic;
        BREADY          : in     vl_logic
    );
end TestSlaveBuffer;
