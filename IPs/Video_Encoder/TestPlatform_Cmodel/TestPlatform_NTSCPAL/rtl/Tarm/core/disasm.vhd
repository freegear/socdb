-------------------------------------------------------------------------------------
-- DisAsm.VHD
-- Designed by Im, JinHyeock
-- Copyright (C) 2003 by Chips&Media Inc.
--
-- version 0.1 (30/09/2003)
--     0.1 Created in 30/09/2003
--
-- Purpose : dis-assemble
-------------------------------------------------------------------------------------

library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_misc.all;
    use ieee.std_logic_arith.all;

entity disasm is port (
    IA : in std_logic_vector (31 downto 0);
    ID : in std_logic_vector (31 downto 0));
end disasm;

architecture sim of disasm is

type arm_op_type is (
    nop,     bx,      mul,    mla,     swp,
    sumull,  sumlal,  str,    ldr,     andd,
    eor,     sub,     rsb,    add,     adc,
    sbc,     rsc,     msr,    mrs,     tst,
    teq,     cmp,     cmn,    orr,     mov,
    bic,     mvn,     stm,    ldm,     b,
    swi,
    -- Generic coprocessor
    cdp,     mrc,     mcr,    stc,     ldc,
    -- V5J
    bxj,
    -- XScale
    mia,     miaph,   mar,    mra,     pld,
    -- V5
    bkpt,    blx,     clz,    ldc2,
    stc2,    cdp2,    mcr2,   mrc2,
    -- V5E "El Segundo"
    smlabb,  smlatb,  smlabt,
    smlatt,  smlawb,  smlawt, smlalbb, smlaltb,
    smlalbt, smlaltt, smulbb, smultb,  smulbt,
    smultt,  smulwb,  smulwt, qadd,    qdadd,
    qsub,    qdsub,   mcrr,   mrrc,
    undefined);

type arm_op_record_type is record
    code : std_logic_vector (31 downto 0);
    mask : std_logic_vector (31 downto 0);
    op   : arm_op_type;
end record;

type arm_op_table_type is array (0 to 1024) of arm_op_record_type;

signal PC   : std_logic_vector (31 downto 0);
signal INST : arm_op_type;

begin

-- alias
    PC <= IA;

    process
    variable i            : integer;
    variable arm_op_table : arm_op_table_type;
    begin
        arm_op_table( 0).code := x"e1a00000";
        arm_op_table( 0).mask := x"ffffffff";
        arm_op_table( 0).op   := nop;
        arm_op_table( 1).code := x"012FFF10";
        arm_op_table( 1).mask := x"0ffffff0";
        arm_op_table( 1).op   := bx;
        arm_op_table( 2).code := x"00000090";
        arm_op_table( 2).mask := x"0fe000f0";
        arm_op_table( 2).op   := mul;
        arm_op_table( 3).code := x"00200090";
        arm_op_table( 3).mask := x"0fe000f0";
        arm_op_table( 3).op   := mla;
        arm_op_table( 4).code := x"01000090";
        arm_op_table( 4).mask := x"0fb00ff0";
        arm_op_table( 4).op   := swp;
        arm_op_table( 5).code := x"00800090";
        arm_op_table( 5).mask := x"0fa000f0";
        arm_op_table( 5).op   := sumull;
        arm_op_table( 6).code := x"00a00090";
        arm_op_table( 6).mask := x"0fa000f0";
        arm_op_table( 6).op   := sumlal;
        arm_op_table( 7).code := x"00000090";
        arm_op_table( 7).mask := x"0e100090";
        arm_op_table( 7).op   := str;
        arm_op_table( 8).code := x"00100090";
        arm_op_table( 8).mask := x"0e100090";
        arm_op_table( 8).op   := ldr;
        arm_op_table( 9).code := x"00000000";
        arm_op_table( 9).mask := x"0de00000";
        arm_op_table( 9).op   := andd;
        arm_op_table(10).code := x"00200000";
        arm_op_table(10).mask := x"0de00000";
        arm_op_table(10).op   := eor;
        arm_op_table(11).code := x"00400000";
        arm_op_table(11).mask := x"0de00000";
        arm_op_table(11).op   := sub;
        arm_op_table(12).code := x"00600000";
        arm_op_table(12).mask := x"0de00000";
        arm_op_table(12).op   := rsb;
        arm_op_table(13).code := x"00800000";
        arm_op_table(13).mask := x"0de00000";
        arm_op_table(13).op   := add;
        arm_op_table(14).code := x"00a00000";
        arm_op_table(14).mask := x"0de00000";
        arm_op_table(14).op   := adc;
        arm_op_table(15).code := x"00c00000";
        arm_op_table(15).mask := x"0de00000";
        arm_op_table(15).op   := sbc;
        arm_op_table(16).code := x"00e00000";
        arm_op_table(16).mask := x"0de00000";
        arm_op_table(16).op   := rsc;
        arm_op_table(17).code := x"0120f000";
        arm_op_table(17).mask := x"0db0f000";
        arm_op_table(17).op   := msr;
        arm_op_table(18).code := x"010f0000";
        arm_op_table(18).mask := x"0fbf0fff";
        arm_op_table(18).op   := mrs;
        arm_op_table(19).code := x"01000000";
        arm_op_table(19).mask := x"0de00000";
        arm_op_table(19).op   := tst;
        arm_op_table(20).code := x"01200000";
        arm_op_table(20).mask := x"0de00000";
        arm_op_table(20).op   := teq;
        arm_op_table(21).code := x"01400000";
        arm_op_table(21).mask := x"0de00000";
        arm_op_table(21).op   := cmp;
        arm_op_table(22).code := x"01600000";
        arm_op_table(22).mask := x"0de00000";
        arm_op_table(22).op   := cmn;
        arm_op_table(23).code := x"01800000";
        arm_op_table(23).mask := x"0de00000";
        arm_op_table(23).op   := orr;
        arm_op_table(24).code := x"01a00000";
        arm_op_table(24).mask := x"0de00000";
        arm_op_table(24).op   := mov;
        arm_op_table(25).code := x"01c00000";
        arm_op_table(25).mask := x"0de00000";
        arm_op_table(25).op   := bic;
        arm_op_table(26).code := x"01e00000";
        arm_op_table(26).mask := x"0de00000";
        arm_op_table(26).op   := mvn;
        arm_op_table(27).code := x"04000000";
        arm_op_table(27).mask := x"0e100000";
        arm_op_table(27).op   := str;
        arm_op_table(28).code := x"06000000";
        arm_op_table(28).mask := x"0e100ff0";
        arm_op_table(28).op   := str;
        arm_op_table(29).code := x"04000000";
        arm_op_table(29).mask := x"0c100010";
        arm_op_table(29).op   := str;
        arm_op_table(30).code := x"06000010";
        arm_op_table(30).mask := x"0e000010";
        arm_op_table(30).op   := undefined;
        arm_op_table(31).code := x"04100000";
        arm_op_table(31).mask := x"0c100000";
        arm_op_table(31).op   := ldr;
        arm_op_table(32).code := x"08000000";
        arm_op_table(32).mask := x"0e100000";
        arm_op_table(32).op   := stm;
        arm_op_table(33).code := x"08100000";
        arm_op_table(33).mask := x"0e100000";
        arm_op_table(33).op   := ldm;
        arm_op_table(34).code := x"0a000000";
        arm_op_table(34).mask := x"0e000000";
        arm_op_table(34).op   := b;
        arm_op_table(35).code := x"0f000000";
        arm_op_table(35).mask := x"0f000000";
        arm_op_table(35).op   := swi;
        arm_op_table(36).code := x"0e000000";
        arm_op_table(36).mask := x"0f000010";
        arm_op_table(36).op   := cdp;
        arm_op_table(37).code := x"0e100010";
        arm_op_table(37).mask := x"0f100010";
        arm_op_table(37).op   := mrc;
        arm_op_table(38).code := x"0e000010";
        arm_op_table(38).mask := x"0f100010";
        arm_op_table(38).op   := mcr;
        arm_op_table(39).code := x"0c000000";
        arm_op_table(39).mask := x"0e100000";
        arm_op_table(39).op   := stc;
        arm_op_table(40).code := x"0c100000";
        arm_op_table(40).mask := x"0e100000";
        arm_op_table(40).op   := ldc;
        arm_op_table(41).code := x"012fff20";
        arm_op_table(41).mask := x"0ffffff0";
        arm_op_table(41).op   := bxj;
        arm_op_table(42).code := x"0e200010";
        arm_op_table(42).mask := x"0fff0ff0";
        arm_op_table(42).op   := mia;
        arm_op_table(43).code := x"0e280010";
        arm_op_table(43).mask := x"0fff0ff0";
        arm_op_table(43).op   := miaph;
        arm_op_table(44).code := x"0e2c0010";
        arm_op_table(44).mask := x"0ffc0ff0";
        arm_op_table(44).op   := mia;
        arm_op_table(45).code := x"0c400000";
        arm_op_table(45).mask := x"0ff00fff";
        arm_op_table(45).op   := mar;
        arm_op_table(46).code := x"0c500000";
        arm_op_table(46).mask := x"0ff00fff";
        arm_op_table(46).op   := mra;
        arm_op_table(47).code := x"f450f000";
        arm_op_table(47).mask := x"fc70f000";
        arm_op_table(47).op   := pld;
        arm_op_table(48).code := x"e1200070";
        arm_op_table(48).mask := x"fff000f0";
        arm_op_table(48).op   := bkpt;
        arm_op_table(49).code := x"fa000000";
        arm_op_table(49).mask := x"fe000000";
        arm_op_table(49).op   := blx;
        arm_op_table(50).code := x"012fff30";
        arm_op_table(50).mask := x"0ffffff0";
        arm_op_table(50).op   := blx;
        arm_op_table(51).code := x"016f0f10";
        arm_op_table(51).mask := x"0fff0ff0";
        arm_op_table(51).op   := clz;
        arm_op_table(52).code := x"fc100000";
        arm_op_table(52).mask := x"fe100000";
        arm_op_table(52).op   := ldc2;
        arm_op_table(53).code := x"fc000000";
        arm_op_table(53).mask := x"fe100000";
        arm_op_table(53).op   := stc2;
        arm_op_table(54).code := x"fe000000";
        arm_op_table(54).mask := x"ff000010";
        arm_op_table(54).op   := cdp2;
        arm_op_table(55).code := x"fe000010";
        arm_op_table(55).mask := x"ff100010";
        arm_op_table(55).op   := mcr2;
        arm_op_table(56).code := x"fe100010";
        arm_op_table(56).mask := x"ff100010";
        arm_op_table(56).op   := mrc2;
        arm_op_table(57).code := x"000000d0";
        arm_op_table(57).mask := x"0e1000f0";
        arm_op_table(57).op   := ldr;
        arm_op_table(58).code := x"000000f0";
        arm_op_table(58).mask := x"0e1000f0";
        arm_op_table(58).op   := str;
        arm_op_table(59).code := x"01000080";
        arm_op_table(59).mask := x"0ff000f0";
        arm_op_table(59).op   := smlabb;
        arm_op_table(60).code := x"010000a0";
        arm_op_table(60).mask := x"0ff000f0";
        arm_op_table(60).op   := smlatb;
        arm_op_table(61).code := x"010000c0";
        arm_op_table(61).mask := x"0ff000f0";
        arm_op_table(61).op   := smlabt;
        arm_op_table(62).code := x"010000e0";
        arm_op_table(62).mask := x"0ff000f0";
        arm_op_table(62).op   := smlatt;
        arm_op_table(63).code := x"01200080";
        arm_op_table(63).mask := x"0ff000f0";
        arm_op_table(63).op   := smlawb;
        arm_op_table(64).code := x"012000c0";
        arm_op_table(64).mask := x"0ff000f0";
        arm_op_table(64).op   := smlawt;
        arm_op_table(65).code := x"01400080";
        arm_op_table(65).mask := x"0ff000f0";
        arm_op_table(65).op   := smlalbb;
        arm_op_table(66).code := x"014000a0";
        arm_op_table(66).mask := x"0ff000f0";
        arm_op_table(66).op   := smlaltb;
        arm_op_table(67).code := x"014000c0";
        arm_op_table(67).mask := x"0ff000f0";
        arm_op_table(67).op   := smlalbt;
        arm_op_table(68).code := x"014000e0";
        arm_op_table(68).mask := x"0ff000f0";
        arm_op_table(68).op   := smlaltt;
        arm_op_table(69).code := x"01600080";
        arm_op_table(69).mask := x"0ff0f0f0";
        arm_op_table(69).op   := smulbb;
        arm_op_table(70).code := x"016000a0";
        arm_op_table(70).mask := x"0ff0f0f0";
        arm_op_table(70).op   := smultb;
        arm_op_table(71).code := x"016000c0";
        arm_op_table(71).mask := x"0ff0f0f0";
        arm_op_table(71).op   := smulbt;
        arm_op_table(72).code := x"016000e0";
        arm_op_table(72).mask := x"0ff0f0f0";
        arm_op_table(72).op   := smultt;
        arm_op_table(73).code := x"012000a0";
        arm_op_table(73).mask := x"0ff0f0f0";
        arm_op_table(73).op   := smulwb;
        arm_op_table(74).code := x"012000e0";
        arm_op_table(74).mask := x"0ff0f0f0";
        arm_op_table(74).op   := smulwt;
        arm_op_table(75).code := x"01000050";
        arm_op_table(75).mask := x"0ff00ff0";
        arm_op_table(75).op   := qadd;
        arm_op_table(76).code := x"01400050";
        arm_op_table(76).mask := x"0ff00ff0";
        arm_op_table(76).op   := qdadd;
        arm_op_table(77).code := x"01200050";
        arm_op_table(77).mask := x"0ff00ff0";
        arm_op_table(77).op   := qsub;
        arm_op_table(78).code := x"01600050";
        arm_op_table(78).mask := x"0ff00ff0";
        arm_op_table(78).op   := qdsub;
        arm_op_table(79).code := x"0c400000";
        arm_op_table(79).mask := x"0ff00000";
        arm_op_table(79).op   := mcrr;
        arm_op_table(80).code := x"0c500000";
        arm_op_table(80).mask := x"0ff00000";
        arm_op_table(80).op   := mrrc;
        loop
            i    := 0;
            INST <= undefined;
            while (i < 81) loop
                if ((ID and arm_op_table(i).mask) = (arm_op_table(i).code)) then
                    INST <= arm_op_table(i).op;
                    exit;
                else
                    i := i + 1;
                end if;
            end loop;
            wait on ID;
        end loop;
    end process;

end sim;

configuration cfg_disasm of disasm is
    for sim
    end for;
end cfg_disasm;
