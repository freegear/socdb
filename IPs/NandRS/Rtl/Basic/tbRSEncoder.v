module tbRS520_512Encoder;

reg RESETb;

reg CLK;

reg [9:0] DATA;


initial
begin

	RESETb 	= 0;
	CLK	= 0;
	#120 RESETb = 1;

end

//initial $readmemh ("./", inputdata);

always 
begin
	#10 CLK = ~CLK;
end

initial
begin
	#95;
	@(posedge CLK); #5 DATA =1;
	@(posedge CLK); #5 DATA =2;
	@(posedge CLK); #5 DATA =3;
	@(posedge CLK); #5 DATA =4;
	@(posedge CLK); #5 DATA =5;
	@(posedge CLK); #5 DATA =6;
	@(posedge CLK); #5 DATA =7;
	@(posedge CLK); #5 DATA =8;
	@(posedge CLK); #5 DATA =9;
	@(posedge CLK); #5 DATA =10;

	@(posedge CLK); #5 DATA =11;
	@(posedge CLK); #5 DATA =12;
	@(posedge CLK); #5 DATA =13;
	@(posedge CLK); #5 DATA =14;
	@(posedge CLK); #5 DATA =15;
	@(posedge CLK); #5 DATA =16;
	@(posedge CLK); #5 DATA =17;
	@(posedge CLK); #5 DATA =18;
	@(posedge CLK); #5 DATA =19;
	@(posedge CLK); #5 DATA =20;

	@(posedge CLK); #5 DATA =21;
	@(posedge CLK); #5 DATA =22;
	@(posedge CLK); #5 DATA =23;
	@(posedge CLK); #5 DATA =24;
	@(posedge CLK); #5 DATA =25;
	@(posedge CLK); #5 DATA =26;
	@(posedge CLK); #5 DATA =27;
	@(posedge CLK); #5 DATA =28;
	@(posedge CLK); #5 DATA =29;
	@(posedge CLK); #5 DATA =30;

	@(posedge CLK); #5 DATA =31;
	@(posedge CLK); #5 DATA =32;
	@(posedge CLK); #5 DATA =33;
	@(posedge CLK); #5 DATA =34;
	@(posedge CLK); #5 DATA =35;
	@(posedge CLK); #5 DATA =36;
	@(posedge CLK); #5 DATA =37;
	@(posedge CLK); #5 DATA =38;
	@(posedge CLK); #5 DATA =39;
	@(posedge CLK); #5 DATA =40;

	@(posedge CLK); #5 DATA =41;
	@(posedge CLK); #5 DATA =42;
	@(posedge CLK); #5 DATA =43;
	@(posedge CLK); #5 DATA =44;
	@(posedge CLK); #5 DATA =45;
	@(posedge CLK); #5 DATA =46;
	@(posedge CLK); #5 DATA =47;
	@(posedge CLK); #5 DATA =48;
	@(posedge CLK); #5 DATA =49;
	@(posedge CLK); #5 DATA =50;

	@(posedge CLK); #5 DATA =51;
	@(posedge CLK); #5 DATA =52;
	@(posedge CLK); #5 DATA =53;
	@(posedge CLK); #5 DATA =54;
	@(posedge CLK); #5 DATA =55;
	@(posedge CLK); #5 DATA =56;
	@(posedge CLK); #5 DATA =57;
	@(posedge CLK); #5 DATA =58;
	@(posedge CLK); #5 DATA =59;
	@(posedge CLK); #5 DATA =60;

	@(posedge CLK); #5 DATA =61;
	@(posedge CLK); #5 DATA =62;
	@(posedge CLK); #5 DATA =63;
	@(posedge CLK); #5 DATA =64;
	@(posedge CLK); #5 DATA =65;
	@(posedge CLK); #5 DATA =66;
	@(posedge CLK); #5 DATA =67;
	@(posedge CLK); #5 DATA =68;
	@(posedge CLK); #5 DATA =69;
	@(posedge CLK); #5 DATA =70;

	@(posedge CLK); #5 DATA =71;
	@(posedge CLK); #5 DATA =72;
	@(posedge CLK); #5 DATA =73;
	@(posedge CLK); #5 DATA =74;
	@(posedge CLK); #5 DATA =75;
	@(posedge CLK); #5 DATA =76;
	@(posedge CLK); #5 DATA =77;
	@(posedge CLK); #5 DATA =78;
	@(posedge CLK); #5 DATA =79;
	@(posedge CLK); #5 DATA =80;
 
	@(posedge CLK); #5	DATA =81;
	@(posedge CLK); #5	DATA =82;
	@(posedge CLK); #5	DATA =83;
	@(posedge CLK); #5	DATA =84;
	@(posedge CLK); #5	DATA =85;
	@(posedge CLK); #5	DATA =86;
	@(posedge CLK); #5	DATA =87;
	@(posedge CLK); #5	DATA =88;
	@(posedge CLK); #5	DATA =89;
	@(posedge CLK); #5	DATA =90;

	@(posedge CLK); #5	DATA =91;
	@(posedge CLK); #5	DATA =92;
	@(posedge CLK); #5	DATA =93;
	@(posedge CLK); #5	DATA =94;
	@(posedge CLK); #5	DATA =95;
	@(posedge CLK); #5	DATA =96;
	@(posedge CLK); #5	DATA =97;
	@(posedge CLK); #5	DATA =98;
	@(posedge CLK); #5	DATA =99;
	@(posedge CLK); #5	DATA =100;





	@(posedge CLK); #5	DATA =101;
	@(posedge CLK); #5	DATA =102;
	@(posedge CLK); #5	DATA =103;
	@(posedge CLK); #5	DATA =104;
	@(posedge CLK); #5	DATA =105;
	@(posedge CLK); #5	DATA =106;
	@(posedge CLK); #5	DATA =107;
	@(posedge CLK); #5	DATA =108;
	@(posedge CLK); #5	DATA =109;
	@(posedge CLK); #5	DATA =110;

	@(posedge CLK); #5	DATA =111;
	@(posedge CLK); #5	DATA =112;
	@(posedge CLK); #5	DATA =113;
	@(posedge CLK); #5	DATA =114;
	@(posedge CLK); #5	DATA =115;
	@(posedge CLK); #5	DATA =116;
	@(posedge CLK); #5	DATA =117;
	@(posedge CLK); #5	DATA =118;
	@(posedge CLK); #5	DATA =119;
	@(posedge CLK); #5	DATA =120;

	@(posedge CLK); #5	DATA =121;
	@(posedge CLK); #5	DATA =122;
	@(posedge CLK); #5	DATA =123;
	@(posedge CLK); #5	DATA =124;
	@(posedge CLK); #5	DATA =125;
	@(posedge CLK); #5	DATA =126;
	@(posedge CLK); #5	DATA =127;
	@(posedge CLK); #5	DATA =128;
	@(posedge CLK); #5	DATA =129;
	@(posedge CLK); #5	DATA =130;

	@(posedge CLK); #5	DATA =131;
	@(posedge CLK); #5	DATA =132;
	@(posedge CLK); #5	DATA =133;
	@(posedge CLK); #5	DATA =134;
	@(posedge CLK); #5	DATA =135;
	@(posedge CLK); #5	DATA =136;
	@(posedge CLK); #5	DATA =137;
	@(posedge CLK); #5	DATA =138;
	@(posedge CLK); #5	DATA =139;
	@(posedge CLK); #5	DATA =140;

	@(posedge CLK); #5	DATA =141;
	@(posedge CLK); #5	DATA =142;
	@(posedge CLK); #5	DATA =143;
	@(posedge CLK); #5	DATA =144;
	@(posedge CLK); #5	DATA =145;
	@(posedge CLK); #5	DATA =146;
	@(posedge CLK); #5	DATA =147;
	@(posedge CLK); #5	DATA =148;
	@(posedge CLK); #5	DATA =149;
	@(posedge CLK); #5	DATA =150;

	@(posedge CLK); #5	DATA =151;
	@(posedge CLK); #5	DATA =152;
	@(posedge CLK); #5	DATA =153;
	@(posedge CLK); #5	DATA =154;
	@(posedge CLK); #5	DATA =155;
	@(posedge CLK); #5	DATA =156;
	@(posedge CLK); #5	DATA =157;
	@(posedge CLK); #5	DATA =158;
	@(posedge CLK); #5	DATA =159;
	@(posedge CLK); #5	DATA =160;

	@(posedge CLK); #5	DATA =161;
	@(posedge CLK); #5	DATA =162;
	@(posedge CLK); #5	DATA =163;
	@(posedge CLK); #5	DATA =164;
	@(posedge CLK); #5	DATA =165;
	@(posedge CLK); #5	DATA =166;
	@(posedge CLK); #5	DATA =167;
	@(posedge CLK); #5	DATA =168;
	@(posedge CLK); #5	DATA =169;
	@(posedge CLK); #5	DATA =170;

	@(posedge CLK); #5	DATA =171;
	@(posedge CLK); #5	DATA =172;
	@(posedge CLK); #5	DATA =173;
	@(posedge CLK); #5	DATA =174;
	@(posedge CLK); #5	DATA =175;
	@(posedge CLK); #5	DATA =176;
	@(posedge CLK); #5	DATA =177;
	@(posedge CLK); #5	DATA =178;
	@(posedge CLK); #5	DATA =179;
	@(posedge CLK); #5	DATA =180;

	@(posedge CLK); #5	DATA =181;
	@(posedge CLK); #5	DATA =182;
	@(posedge CLK); #5	DATA =183;
	@(posedge CLK); #5	DATA =184;
	@(posedge CLK); #5	DATA =185;
	@(posedge CLK); #5	DATA =186;
	@(posedge CLK); #5	DATA =187;
	@(posedge CLK); #5	DATA =188;
	@(posedge CLK); #5	DATA =189;
	@(posedge CLK); #5	DATA =190;

	@(posedge CLK); #5	DATA =191;
	@(posedge CLK); #5	DATA =192;
	@(posedge CLK); #5	DATA =193;
	@(posedge CLK); #5	DATA =194;
	@(posedge CLK); #5	DATA =195;
	@(posedge CLK); #5	DATA =196;
	@(posedge CLK); #5	DATA =197;
	@(posedge CLK); #5	DATA =198;
	@(posedge CLK); #5	DATA =199;
	@(posedge CLK); #5	DATA =200;

	@(posedge CLK); #5	DATA =201;
	@(posedge CLK); #5	DATA =202;
	@(posedge CLK); #5	DATA =203;
	@(posedge CLK); #5	DATA =204;
	@(posedge CLK); #5	DATA =205;
	@(posedge CLK); #5	DATA =206;
	@(posedge CLK); #5	DATA =207;
	@(posedge CLK); #5	DATA =208;
	@(posedge CLK); #5	DATA =209;
	@(posedge CLK); #5	DATA =210;

	@(posedge CLK); #5	DATA =211;
	@(posedge CLK); #5	DATA =212;
	@(posedge CLK); #5	DATA =213;
	@(posedge CLK); #5	DATA =214;
	@(posedge CLK); #5	DATA =215;
	@(posedge CLK); #5	DATA =216;
	@(posedge CLK); #5	DATA =217;
	@(posedge CLK); #5	DATA =218;
	@(posedge CLK); #5	DATA =219;
	@(posedge CLK); #5	DATA =220;

	@(posedge CLK); #5	DATA =221;
	@(posedge CLK); #5	DATA =222;
	@(posedge CLK); #5	DATA =223;
	@(posedge CLK); #5	DATA =224;
	@(posedge CLK); #5	DATA =225;
	@(posedge CLK); #5	DATA =226;
	@(posedge CLK); #5	DATA =227;
	@(posedge CLK); #5	DATA =228;
	@(posedge CLK); #5	DATA =229;
	@(posedge CLK); #5	DATA =230;

	@(posedge CLK); #5	DATA =231;
	@(posedge CLK); #5	DATA =232;
	@(posedge CLK); #5	DATA =233;
	@(posedge CLK); #5	DATA =234;
	@(posedge CLK); #5	DATA =235;
	@(posedge CLK); #5	DATA =236;
	@(posedge CLK); #5	DATA =237;
	@(posedge CLK); #5	DATA =238;
	@(posedge CLK); #5	DATA =239;
	@(posedge CLK); #5	DATA =240;

	@(posedge CLK); #5	DATA =241;
	@(posedge CLK); #5	DATA =242;
	@(posedge CLK); #5	DATA =243;
	@(posedge CLK); #5	DATA =244;
	@(posedge CLK); #5	DATA =245;
	@(posedge CLK); #5	DATA =246;
	@(posedge CLK); #5	DATA =247;
	@(posedge CLK); #5	DATA =248;
	@(posedge CLK); #5	DATA =249;
	@(posedge CLK); #5	DATA =250;

	@(posedge CLK); #5	DATA =251;
	@(posedge CLK); #5	DATA =252;
	@(posedge CLK); #5	DATA =253;
	@(posedge CLK); #5	DATA =254;
	@(posedge CLK); #5	DATA =255;
	@(posedge CLK); #5	DATA =256;
	@(posedge CLK); #5	DATA =257;
	@(posedge CLK); #5	DATA =258;
	@(posedge CLK); #5	DATA =259;
	@(posedge CLK); #5	DATA =260;

	@(posedge CLK); #5	DATA =261;
	@(posedge CLK); #5	DATA =262;
	@(posedge CLK); #5	DATA =263;
	@(posedge CLK); #5	DATA =264;
	@(posedge CLK); #5	DATA =265;
	@(posedge CLK); #5	DATA =266;
	@(posedge CLK); #5	DATA =267;
	@(posedge CLK); #5	DATA =268;
	@(posedge CLK); #5	DATA =269;
	@(posedge CLK); #5	DATA =270;

	@(posedge CLK); #5	DATA =271;
	@(posedge CLK); #5	DATA =272;
	@(posedge CLK); #5	DATA =273;
	@(posedge CLK); #5	DATA =274;
	@(posedge CLK); #5	DATA =275;
	@(posedge CLK); #5	DATA =276;
	@(posedge CLK); #5	DATA =277;
	@(posedge CLK); #5	DATA =278;
	@(posedge CLK); #5	DATA =279;
	@(posedge CLK); #5	DATA =280;

	@(posedge CLK); #5	DATA =281;
	@(posedge CLK); #5	DATA =282;
	@(posedge CLK); #5	DATA =283;
	@(posedge CLK); #5	DATA =284;
	@(posedge CLK); #5	DATA =285;
	@(posedge CLK); #5	DATA =286;
	@(posedge CLK); #5	DATA =287;
	@(posedge CLK); #5	DATA =288;
	@(posedge CLK); #5	DATA =289;
	@(posedge CLK); #5	DATA =290;

	@(posedge CLK); #5	DATA =291;
	@(posedge CLK); #5	DATA =292;
	@(posedge CLK); #5	DATA =293;
	@(posedge CLK); #5	DATA =294;
	@(posedge CLK); #5	DATA =295;
	@(posedge CLK); #5	DATA =296;
	@(posedge CLK); #5	DATA =297;
	@(posedge CLK); #5	DATA =298;
	@(posedge CLK); #5	DATA =299;
	@(posedge CLK); #5	DATA =300;

	@(posedge CLK); #5	DATA =301;
	@(posedge CLK); #5	DATA =302;
	@(posedge CLK); #5	DATA =303;
	@(posedge CLK); #5	DATA =304;
	@(posedge CLK); #5	DATA =305;
	@(posedge CLK); #5	DATA =306;
	@(posedge CLK); #5	DATA =307;
	@(posedge CLK); #5	DATA =308;
	@(posedge CLK); #5	DATA =309;
	@(posedge CLK); #5	DATA =310;

	@(posedge CLK); #5	DATA =311;
	@(posedge CLK); #5	DATA =312;
	@(posedge CLK); #5	DATA =313;
	@(posedge CLK); #5	DATA =314;
	@(posedge CLK); #5	DATA =315;
	@(posedge CLK); #5	DATA =316;
	@(posedge CLK); #5	DATA =317;
	@(posedge CLK); #5	DATA =318;
	@(posedge CLK); #5	DATA =319;
	@(posedge CLK); #5	DATA =320;

	@(posedge CLK); #5	DATA =321;
	@(posedge CLK); #5	DATA =322;
	@(posedge CLK); #5	DATA =323;
	@(posedge CLK); #5	DATA =324;
	@(posedge CLK); #5	DATA =325;
	@(posedge CLK); #5	DATA =326;
	@(posedge CLK); #5	DATA =327;
	@(posedge CLK); #5	DATA =328;
	@(posedge CLK); #5	DATA =329;
	@(posedge CLK); #5	DATA =330;

	@(posedge CLK); #5	DATA =331;
	@(posedge CLK); #5	DATA =332;
	@(posedge CLK); #5	DATA =333;
	@(posedge CLK); #5	DATA =334;
	@(posedge CLK); #5	DATA =335;
	@(posedge CLK); #5	DATA =336;
	@(posedge CLK); #5	DATA =337;
	@(posedge CLK); #5	DATA =338;
	@(posedge CLK); #5	DATA =339;
	@(posedge CLK); #5	DATA =340;

	@(posedge CLK); #5	DATA =341;
	@(posedge CLK); #5	DATA =342;
	@(posedge CLK); #5	DATA =343;
	@(posedge CLK); #5	DATA =344;
	@(posedge CLK); #5	DATA =345;
	@(posedge CLK); #5	DATA =346;
	@(posedge CLK); #5	DATA =347;
	@(posedge CLK); #5	DATA =348;
	@(posedge CLK); #5	DATA =349;
	@(posedge CLK); #5	DATA =350;

	@(posedge CLK); #5	DATA =351;
	@(posedge CLK); #5	DATA =352;
	@(posedge CLK); #5	DATA =353;
	@(posedge CLK); #5	DATA =354;
	@(posedge CLK); #5	DATA =355;
	@(posedge CLK); #5	DATA =356;
	@(posedge CLK); #5	DATA =357;
	@(posedge CLK); #5	DATA =358;
	@(posedge CLK); #5	DATA =359;
	@(posedge CLK); #5	DATA =360;

	@(posedge CLK); #5	DATA =361;
	@(posedge CLK); #5	DATA =362;
	@(posedge CLK); #5	DATA =363;
	@(posedge CLK); #5	DATA =364;
	@(posedge CLK); #5	DATA =365;
	@(posedge CLK); #5	DATA =366;
	@(posedge CLK); #5	DATA =367;
	@(posedge CLK); #5	DATA =368;
	@(posedge CLK); #5	DATA =369;
	@(posedge CLK); #5	DATA =370;

	@(posedge CLK); #5	DATA =371;
	@(posedge CLK); #5	DATA =372;
	@(posedge CLK); #5	DATA =373;
	@(posedge CLK); #5	DATA =374;
	@(posedge CLK); #5	DATA =375;
	@(posedge CLK); #5	DATA =376;
	@(posedge CLK); #5	DATA =377;
	@(posedge CLK); #5	DATA =378;
	@(posedge CLK); #5	DATA =379;
	@(posedge CLK); #5	DATA =380;

	@(posedge CLK); #5	DATA =381;
	@(posedge CLK); #5	DATA =382;
	@(posedge CLK); #5	DATA =383;
	@(posedge CLK); #5	DATA =384;
	@(posedge CLK); #5	DATA =385;
	@(posedge CLK); #5	DATA =386;
	@(posedge CLK); #5	DATA =387;
	@(posedge CLK); #5	DATA =388;
	@(posedge CLK); #5	DATA =389;
	@(posedge CLK); #5	DATA =390;

	@(posedge CLK); #5	DATA =391;
	@(posedge CLK); #5	DATA =392;
	@(posedge CLK); #5	DATA =393;
	@(posedge CLK); #5	DATA =394;
	@(posedge CLK); #5	DATA =395;
	@(posedge CLK); #5	DATA =396;
	@(posedge CLK); #5	DATA =397;
	@(posedge CLK); #5	DATA =398;
	@(posedge CLK); #5	DATA =399;
	@(posedge CLK); #5	DATA =400;

	@(posedge CLK); #5	DATA =401;
	@(posedge CLK); #5	DATA =402;
	@(posedge CLK); #5	DATA =403;
	@(posedge CLK); #5	DATA =404;
	@(posedge CLK); #5	DATA =405;
	@(posedge CLK); #5	DATA =406;
	@(posedge CLK); #5	DATA =407;
	@(posedge CLK); #5	DATA =408;
	@(posedge CLK); #5	DATA =409;
	@(posedge CLK); #5	DATA =410;

	@(posedge CLK); #5	DATA =411;
	@(posedge CLK); #5	DATA =412;
	@(posedge CLK); #5	DATA =413;
	@(posedge CLK); #5	DATA =414;
	@(posedge CLK); #5	DATA =415;
	@(posedge CLK); #5	DATA =416;
	@(posedge CLK); #5	DATA =417;
	@(posedge CLK); #5	DATA =418;
	@(posedge CLK); #5	DATA =419;
	@(posedge CLK); #5	DATA =420;

	@(posedge CLK); #5	DATA =421;
	@(posedge CLK); #5	DATA =422;
	@(posedge CLK); #5	DATA =423;
	@(posedge CLK); #5	DATA =424;
	@(posedge CLK); #5	DATA =425;
	@(posedge CLK); #5	DATA =426;
	@(posedge CLK); #5	DATA =427;
	@(posedge CLK); #5	DATA =428;
	@(posedge CLK); #5	DATA =429;
	@(posedge CLK); #5	DATA =430;

	@(posedge CLK); #5	DATA =431;
	@(posedge CLK); #5	DATA =432;
	@(posedge CLK); #5	DATA =433;
	@(posedge CLK); #5	DATA =434;
	@(posedge CLK); #5	DATA =435;
	@(posedge CLK); #5	DATA =436;
	@(posedge CLK); #5	DATA =437;
	@(posedge CLK); #5	DATA =438;
	@(posedge CLK); #5	DATA =439;
	@(posedge CLK); #5	DATA =440;

	@(posedge CLK); #5	DATA =441;
	@(posedge CLK); #5	DATA =442;
	@(posedge CLK); #5	DATA =443;
	@(posedge CLK); #5	DATA =444;
	@(posedge CLK); #5	DATA =445;
	@(posedge CLK); #5	DATA =446;
	@(posedge CLK); #5	DATA =447;
	@(posedge CLK); #5	DATA =448;
	@(posedge CLK); #5	DATA =449;
	@(posedge CLK); #5	DATA =450;

	@(posedge CLK); #5	DATA =451;
	@(posedge CLK); #5	DATA =452;
	@(posedge CLK); #5	DATA =453;
	@(posedge CLK); #5	DATA =454;
	@(posedge CLK); #5	DATA =455;
	@(posedge CLK); #5	DATA =456;
	@(posedge CLK); #5	DATA =457;
	@(posedge CLK); #5	DATA =458;
	@(posedge CLK); #5	DATA =459;
	@(posedge CLK); #5	DATA =460;

	@(posedge CLK); #5	DATA =461;
	@(posedge CLK); #5	DATA =462;
	@(posedge CLK); #5	DATA =463;
	@(posedge CLK); #5	DATA =464;
	@(posedge CLK); #5	DATA =465;
	@(posedge CLK); #5	DATA =466;
	@(posedge CLK); #5	DATA =467;
	@(posedge CLK); #5	DATA =468;
	@(posedge CLK); #5	DATA =469;
	@(posedge CLK); #5	DATA =470;

	@(posedge CLK); #5	DATA =471;
	@(posedge CLK); #5	DATA =472;
	@(posedge CLK); #5	DATA =473;
	@(posedge CLK); #5	DATA =474;
	@(posedge CLK); #5	DATA =475;
	@(posedge CLK); #5	DATA =476;
	@(posedge CLK); #5	DATA =477;
	@(posedge CLK); #5	DATA =478;
	@(posedge CLK); #5	DATA =479;
	@(posedge CLK); #5	DATA =480;

	@(posedge CLK); #5	DATA =481;
	@(posedge CLK); #5	DATA =482;
	@(posedge CLK); #5	DATA =483;
	@(posedge CLK); #5	DATA =484;
	@(posedge CLK); #5	DATA =485;
	@(posedge CLK); #5	DATA =486;
	@(posedge CLK); #5	DATA =487;
	@(posedge CLK); #5	DATA =488;
	@(posedge CLK); #5	DATA =489;
	@(posedge CLK); #5	DATA =490;

	@(posedge CLK); #5	DATA =491;
	@(posedge CLK); #5	DATA =492;
	@(posedge CLK); #5	DATA =493;
	@(posedge CLK); #5	DATA =494;
	@(posedge CLK); #5	DATA =495;
	@(posedge CLK); #5	DATA =496;
	@(posedge CLK); #5	DATA =497;
	@(posedge CLK); #5	DATA =498;
	@(posedge CLK); #5	DATA =499;
	@(posedge CLK); #5	DATA =500;

	@(posedge CLK); #5	DATA =501;
	@(posedge CLK); #5	DATA =502;
	@(posedge CLK); #5	DATA =503;
	@(posedge CLK); #5	DATA =504;
	@(posedge CLK); #5	DATA =505;
	@(posedge CLK); #5	DATA =506;
	@(posedge CLK); #5	DATA =507;
	@(posedge CLK); #5	DATA =508;
	@(posedge CLK); #5	DATA =509;
	@(posedge CLK); #5	DATA =510;

	@(posedge CLK); #5	DATA =511;
	@(posedge CLK); #5	DATA =512;

end

RS520_512Encoder Encoder
(	
	.RESETb	(RESETb),
	.CLK	(CLK),
	.DATA	(DATA),
	.PARITY7(PARITY7),
	.PARITY6(PARITY6),
	.PARITY5(PARITY5),
	.PARITY4(PARITY4),
	.PARITY3(PARITY3),
	.PARITY2(PARITY2),
	.PARITY1(PARITY1),
	.PARITY0(PARITY0)
);

endmodule
