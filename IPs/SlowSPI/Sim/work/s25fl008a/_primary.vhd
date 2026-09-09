library verilog;
use verilog.vl_types.all;
entity s25fl008a is
    generic(
        userpreload     : integer := 0;
        mem_file_name   : string  := "none";
        timingmodel     : string  := "DefaultTimingModel";
        partid          : string  := "s25fl008a";
        maxdata         : integer := 255;
        secsize         : integer := 65535;
        secnum          : integer := 15;
        hiaddrbit       : integer := 23;
        hiaddrbitused   : integer := 19;
        addrrange       : integer := 1048575;
        byte            : integer := 8;
        es              : integer := 20;
        deviceid        : integer := 66055;
        idle            : integer := 0;
        write_sr        : integer := 1;
        dp_down         : integer := 2;
        sector_er       : integer := 3;
        bulk_er         : integer := 4;
        page_pg         : integer := 5;
        none            : integer := 0;
        wren            : integer := 1;
        wrdi            : integer := 2;
        wrsr            : integer := 3;
        rdsr            : integer := 4;
        read            : integer := 5;
        fast_read       : integer := 6;
        se              : integer := 8;
        be              : integer := 9;
        pp              : integer := 10;
        dp              : integer := 11;
        rdid            : integer := 12;
        res_read_es     : integer := 13;
        stand_by        : integer := 0;
        code_byte       : integer := 1;
        address_bytes   : integer := 2;
        dummy_bytes     : integer := 3;
        data_bytes      : integer := 4
    );
    port(
        sck             : in     vl_logic;
        si              : in     vl_logic;
        csneg           : in     vl_logic;
        holdneg         : in     vl_logic;
        wneg            : in     vl_logic;
        so              : out    vl_logic
    );
end s25fl008a;
