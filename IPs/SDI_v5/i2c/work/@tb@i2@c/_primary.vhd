library verilog;
use verilog.vl_types.all;
entity TbI2C is
    generic(
        CKP1            : integer := 5;
        DLY             : integer := 0;
        I2CCTL          : integer := 128;
        I2CSTS          : integer := 132;
        I2CADR          : integer := 136;
        I2CDAT          : integer := 140;
        I2CCCR          : integer := 144;
        I2CRST          : integer := 148;
        IEN             : integer := 32;
        Enab            : integer := 16;
        STA             : integer := 32;
        STP             : integer := 0
    );
end TbI2C;
