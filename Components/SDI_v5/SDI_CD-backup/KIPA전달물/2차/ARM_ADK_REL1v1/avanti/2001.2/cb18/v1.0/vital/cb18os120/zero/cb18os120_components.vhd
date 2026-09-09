-- ****************************************************
-- (C) Copyright 1999 Avant! Corp. All rights reserved.
-- AVANT! COMPONENTS DECLARATIONS PACKAGE.
-- ****************************************************
-- Description     : package
-- Library         : CB18OS120
-- Programmer      : echarlet
-- Date            : 13-Jul-1999
-- ****************************************************
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.vital_timing.ALL;
USE ieee.vital_primitives.ALL;


PACKAGE CB18OS120_COMPONENTS is


	COMPONENT ad01d0
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ad01d1
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ad01d2
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT adiode
	  PORT(
	  I : IN std_ulogic
	  );
	END COMPONENT;

	COMPONENT adp1d0
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, P, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT adp1d1
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, P, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT adp1d2
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, P, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ah01d0
	  PORT(
	  A, B : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ah01d1
	  PORT(
	  A, B : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ah01d2
	  PORT(
	  A, B : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an02d0
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an03d0
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an03d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an03d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an03d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an04d0
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an04d1
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an04d2
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an04d4
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an12d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an12d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT an12d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi211d1
	  PORT(
	  C1, C2, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi211d2
	  PORT(
	  C1, C2, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi211d4
	  PORT(
	  C1, C2, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi21d1
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi21d2
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi21d4
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi221d1
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi221d2
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi221d4
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi2222d1
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi2222d2
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi2222d4
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi222d1
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi222d2
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi222d4
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi22d1
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi22d2
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi22d4
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi31d1
	  PORT(
	  B1, B2, B3, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi31d2
	  PORT(
	  B1, B2, B3, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi31d4
	  PORT(
	  B1, B2, B3, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi321d1
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi321d2
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi321d4
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi322d1
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi322d2
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoi322d4
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim21d1
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim21d2
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim21d4
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim22d1
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim22d2
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim22d4
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim2m11d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim2m11d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim2m11d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim31d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim31d2
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim31d4
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim3m11d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim3m11d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aoim3m11d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aon211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aon211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aon211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor21d1
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor21d2
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor21d4
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor221d1
	  PORT(
	  C2, C1, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor221d2
	  PORT(
	  C2, C1, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor221d4
	  PORT(
	  C2, C1, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor222d1
	  PORT(
	  C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor222d2
	  PORT(
	  C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor222d4
	  PORT(
	  C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor22d1
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor22d2
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor22d4
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor31d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor31d2
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT aor31d4
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT bh01d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT bufbd1
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT bufbd3
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT bufbd7
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT bufbda
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buffd1
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buffd3
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buffd7
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buffda
	  PORT(
	  I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buftd1
	  PORT(
	  EN, I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buftd2
	  PORT(
	  EN, I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buftd4
	  PORT(
	  EN, I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buftd7
	  PORT(
	  EN, I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT buftda
	  PORT(
	  EN, I : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT cg01d0
	  PORT(
	  A, B, CI : IN std_ulogic;
	  CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT cg01d1
	  PORT(
	  A, B, CI : IN std_ulogic;
	  CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT cg01d2
	  PORT(
	  A, B, CI : IN std_ulogic;
	  CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT clk2d2
	  PORT(
	  CLK : IN std_ulogic;
	  C, CN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT cload1
	  PORT(
	  CLK : IN std_ulogic;
	  C, CN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT decfq1
	  PORT(
	  D, ENN, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT decfq2
	  PORT(
	  D, ENN, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT decrq1
	  PORT(
	  D, ENN, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT decrq2
	  PORT(
	  D, ENN, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT denrq1
	  PORT(
	  D, ENN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT denrq2
	  PORT(
	  D, ENN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT depfq1
	  PORT(
	  D, ENN, SDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT depfq2
	  PORT(
	  D, ENN, SDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT deprq1
	  PORT(
	  D, ENN, SDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT deprq2
	  PORT(
	  D, ENN, SDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfbfb1
	  PORT(
	  D, CDN, SDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfbfb2
	  PORT(
	  D, CDN, SDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfbrb1
	  PORT(
	  D, CDN, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfbrb2
	  PORT(
	  D, CDN, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcfb1
	  PORT(
	  D, CDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcfb2
	  PORT(
	  D, CDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcfq1
	  PORT(
	  D, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcfq2
	  PORT(
	  D, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrb1
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrb2
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrn1
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrn2
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrq1
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfcrq2
	  PORT(
	  D, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnfb1
	  PORT(
	  D, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnfb2
	  PORT(
	  D, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrb1
	  PORT(
	  D, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrb2
	  PORT(
	  D, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrn1
	  PORT(
	  D, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrn2
	  PORT(
	  D, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrq1
	  PORT(
	  D, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfnrq2
	  PORT(
	  D, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfpfb1
	  PORT(
	  D, SDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfpfb2
	  PORT(
	  D, SDN, CPN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfprb1
	  PORT(
	  D, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT dfprb2
	  PORT(
	  D, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0d0
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0d1
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0d2
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0d4
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0d7
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT inv0da
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invbd2
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invbd4
	  PORT(
	  I : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invtd1
	  PORT(
	  I, EN : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invtd2
	  PORT(
	  I, EN : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invtd4
	  PORT(
	  I, EN : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invtd7
	  PORT(
	  I, EN : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT invtda
	  PORT(
	  I, EN : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT jkbrb1
	  PORT(
	  J, KZ, CDN, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT jkbrb2
	  PORT(
	  J, KZ, CDN, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT labhb1
	  PORT(
	  D, CDN, SDN, E : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT labhb2
	  PORT(
	  D, CDN, SDN, E : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lachq1
	  PORT(
	  D, CDN, E : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lachq2
	  PORT(
	  D, CDN, E : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT laclq1
	  PORT(
	  D, CDN, EN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT laclq2
	  PORT(
	  D, CDN, EN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhb1
	  PORT(
	  D, E : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhb2
	  PORT(
	  D, E : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhn1
	  PORT(
	  D, E : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhn2
	  PORT(
	  D, E : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhq1
	  PORT(
	  D, E : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanhq2
	  PORT(
	  D, E : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanht1
	  PORT(
	  D, OE, E : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanht2
	  PORT(
	  D, OE, E : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanlb1
	  PORT(
	  D, EN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanlb2
	  PORT(
	  D, EN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanln1
	  PORT(
	  D, EN : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanln2
	  PORT(
	  D, EN : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanlq1
	  PORT(
	  D, EN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT lanlq2
	  PORT(
	  D, EN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mffnrb1
	  PORT(
	  D, ENN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mffnrb2
	  PORT(
	  D, ENN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mi02d0
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mi02d1
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mi02d2
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mi02d4
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx02d0
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx02d1
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx02d2
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx02d4
	  PORT(
	  I0, I1, S : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx04d0
	  PORT(
	  I0, I1, I2, I3, S0, S1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx04d1
	  PORT(
	  I0, I1, I2, I3, S0, S1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx04d2
	  PORT(
	  I0, I1, I2, I3, S0, S1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT mx04d4
	  PORT(
	  I0, I1, I2, I3, S0, S1 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd02d0
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd03d0
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd03d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd03d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd03d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd04d0
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd04d1
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd04d2
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd04d4
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd12d0
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd12d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd12d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd12d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd13d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd13d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd13d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd23d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd23d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nd23d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr02d0
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr03d0
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr03d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr03d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr03d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr04d0
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr04d1
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr04d2
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr04d4
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr13d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr13d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr13d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr23d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr23d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT nr23d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai211d1
	  PORT(
	  C1, C2, A, B : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai211d2
	  PORT(
	  C1, C2, A, B : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai211d4
	  PORT(
	  C1, C2, A, B : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai21d1
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai21d2
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai21d4
	  PORT(
	  B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai221d1
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai221d2
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai221d4
	  PORT(
	  C1, C2, B1, B2, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai2222d1
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai2222d2
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai2222d4
	  PORT(
	  A1, A2, B1, B2, C1, C2, D1, D2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai222d1
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai222d2
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai222d4
	  PORT(
	  A1, A2, B1, B2, C1, C2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai22d1
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai22d2
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai22d4
	  PORT(
	  A1, A2, B1, B2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai31d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai31d2
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai31d4
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai321d1
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai321d2
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai321d4
	  PORT(
	  C3, C2, C1, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai322d1
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai322d2
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oai322d4
	  PORT(
	  C3, C2, C1, B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim21d1
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim21d2
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim21d4
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim22d1
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim22d2
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim22d4
	  PORT(
	  B2, B1, A2, A1 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim2m11d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim2m11d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim2m11d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim31d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim31d2
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim31d4
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim3m11d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim3m11d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oaim3m11d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oan211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oan211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT oan211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or02d0
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or03d0
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or03d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or03d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or03d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or04d0
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or04d1
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or04d2
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT or04d4
	  PORT(
	  A1, A2, A3, A4 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora211d1
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora211d2
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora211d4
	  PORT(
	  C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora21d1
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora21d2
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora21d4
	  PORT(
	  B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora311d1
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora311d2
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora311d4
	  PORT(
	  C3, C2, C1, B, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora31d1
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora31d2
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT ora31d4
	  PORT(
	  B3, B2, B1, A : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdbrb1
	  PORT(
	  D, SD, SC, SDN, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdbrb2
	  PORT(
	  D, SD, SC, SDN, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcfq1
	  PORT(
	  D, SD, SC, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcfq2
	  PORT(
	  D, SD, SC, CDN, CPN : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrb1
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrb2
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrn1
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrn2
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrq1
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdcrq2
	  PORT(
	  D, SD, SC, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrb1
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrb2
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrn1
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrn2
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrq1
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdnrq2
	  PORT(
	  D, SD, SC, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdprb1
	  PORT(
	  D, SD, SC, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT sdprb2
	  PORT(
	  D, SD, SC, SDN, CP : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT secrq1
	  PORT(
	  D, SD, ENN, SC, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT secrq2
	  PORT(
	  D, SD, ENN, SC, CDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT senrq1
	  PORT(
	  D, SD, ENN, SC, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT senrq2
	  PORT(
	  D, SD, ENN, SC, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT seprq1
	  PORT(
	  D, ENN, SC, SD, SDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT seprq2
	  PORT(
	  D, ENN, SC, SD, SDN, CP : IN std_ulogic;
	  Q : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT srlab1
	  PORT(
	  RN, SN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT srlab2
	  PORT(
	  RN, SN : IN std_ulogic;
	  Q, QN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT su01d0
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT su01d1
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT su01d2
	  PORT(
	  A, B, CI : IN std_ulogic;
	  S, CO : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xn02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xn02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xn02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  ZN : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr02d1
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr02d2
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr02d4
	  PORT(
	  A1, A2 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr03d1
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr03d2
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

	COMPONENT xr03d4
	  PORT(
	  A1, A2, A3 : IN std_ulogic;
	  Z : OUT std_ulogic
	  );
	END COMPONENT;

END  CB18OS120_COMPONENTS;
