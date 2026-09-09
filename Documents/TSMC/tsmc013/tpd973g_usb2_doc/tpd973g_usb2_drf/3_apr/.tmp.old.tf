/*************************************************************************/
/*                                                                       */
/* RC values have been extracted from TSMC's worst case interconnect     */
/* tables included with spice model version 1.10.                        */
/* Document No. TA-10A5-6001 (T-018-LO-SP-001) Rev1.10 Nov 23, 2001      */
/*                                                                       */
/* Resistance and Capacitance Values                                     */
/* ---------------------------------                                     */
/* The Apollo technology files included in this directory contain        */
/* resistance and capacitance (RC) values for the purpose of timing      */
/* driven place & route.  Please note that the RC values contained in    */
/* this tech file were created using the worst case interconnect models  */
/* from the foundry and assume a full metal route at every grid location */
/* on every metal layer, so the values are intentionally very            */
/* conservative. It is assumed that this technology file will be used    */
/* only as a starting point for creating initial timing driven place &   */
/* route runs during the development of your own more accurate RC        */
/* values, tailored to your specific place & route environment. AS A     */
/* RESULT, TIMING NUMBERS DERIVED FROM THESE RC VALUES MAY BE            */
/* SIGNIFICANTLY SLOWER THAN REALITY.                                    */
/*                                                                       */
/* The RC values used in the Apollo technology file are to be used only  */
/* for timing driven place and route. Due to accuracy limitations,       */
/* please do not attempt to use this file for chip-level RC extraction   */
/* in conjunction with your sign-off timing simulations. For chip-level  */
/* extraction, please use a dedicated extraction tool such as starRC,    */
/* HyperExtract or Simplex, etc.                                         */
/*                                                                       */
/*************************************************************************/
/*
   $Id: tsmc18_4lm.tf,v 1.21 2003/09/26 23:03:34 jayantht Exp $
*/

Technology	{
		name				= ""
		dielectric			= 3.714e-05
		unitTimeName			= "ns"
		timePrecision			= 1000
		unitLengthName			= "micron"
		lengthPrecision			= 1000
		gridResolution			= 5
		unitVoltageName			= "v"
		voltagePrecision		= 1000000
		unitCurrentName			= "ma"
		currentPrecision		= 1000
		unitPowerName			= "pw"
		powerPrecision			= 1000
		unitResistanceName		= "kohm"
		resistancePrecision		= 10000000
		unitCapacitanceName		= "pf"
		capacitancePrecision		= 10000000
		unitInductanceName		= "nh"
		inductancePrecision		= 100
		minBaselineTemperature		= 25
		nomBaselineTemperature		= 25
		maxBaselineTemperature		= 25
}

PrimaryColor	{
		lightRed			= 90
		mediumRed			= 180
		lightGreen			= 80
		mediumGreen			= 175
		lightBlue			= 100
		mediumBlue			= 190
}

Color		0 {
		name				= "black"
		rgbDefined		= 0
}

Color		3 {
		name				= "blue"
		rgbDefined		= 0
}

Color		12 {
		name				= "green"
		rgbDefined		= 0
}

Color		14 {
		name				= "14"
		rgbDefined			= 1
		redIntensity			= 0
		greenIntensity			= 255
		blueIntensity			= 190
}

Color		15 {
		name				= "cyan"
		rgbDefined		= 0
}

Color		19 {
		name				= "19"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 0
		blueIntensity			= 255
}

Color		20 {
		name				= "20"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 80
		blueIntensity			= 0
}

Color		21 {
		name				= "21"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 80
		blueIntensity			= 100
}

Color		22 {
		name				= "22"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 80
		blueIntensity			= 190
}

Color		24 {
		name				= "drab"
		rgbDefined		= 0
}

Color		26 {
		name				= "aqua"
		rgbDefined		= 0
}

Color		27 {
		name				= "27"
		rgbDefined			= 1
		redIntensity			= 90
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		32 {
		name				= "32"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 0
		blueIntensity			= 0
}

Color		33 {
		name				= "33"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 0
		blueIntensity			= 100
}

Color		34 {
		name				= "34"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 0
		blueIntensity			= 190
}

Color		35 {
		name				= "35"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 0
		blueIntensity			= 255
}

Color		37 {
		name				= "brown"
		rgbDefined		= 0
}

Color		39 {
		name				= "purple"
		rgbDefined		= 0
}

Color		42 {
		name				= "lead"
		rgbDefined		= 0
}

Color		43 {
		name				= "43"
		rgbDefined			= 1
		redIntensity			= 180
		greenIntensity			= 175
		blueIntensity			= 255
}

Color		48 {
		name				= "red"
		rgbDefined		= 0
}

Color		49 {
		name				= "49"
		rgbDefined			= 1
		redIntensity			= 255
		greenIntensity			= 0
		blueIntensity			= 100
}

Color		51 {
		name				= "magenta"
		rgbDefined		= 0
}

Color		53 {
		name				= "salmon"
		rgbDefined		= 0
}

Color		56 {
		name				= "orange"
		rgbDefined		= 0
}

Color		60 {
		name				= "yellow"
		rgbDefined		= 0
}

Color		63 {
		name				= "white"
		rgbDefined		= 0
}

Stipple		"blank" {
		width			= 2
		height			= 2
		pattern			= (0, 0, 
					   0, 0) 
}

Stipple		"solid" {
		width			= 2
		height			= 2
		pattern			= (1, 1, 
					   1, 1) 
}

Stipple		"backSlash" {
		width			= 8
		height			= 8
		pattern			= (1, 0, 0, 0, 0, 0, 0, 0, 
					   0, 1, 0, 0, 0, 0, 0, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 0, 0, 0, 0, 0, 1) 
}

Stipple		"slash" {
		width			= 8
		height			= 8
		pattern			= (0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 1, 0, 0, 0, 0, 0, 0, 
					   1, 0, 0, 0, 0, 0, 0, 0) 
}

Stipple		"dot" {
		width			= 8
		height			= 8
		pattern			= (1, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   1, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0) 
}

Stipple		"wave" {
		width			= 16
		height			= 16
		pattern			= (1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 
					   1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0) 
}

Stipple		"zigzag" {
		width			= 16
		height			= 16
		pattern			= (1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
					   0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
					   1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0) 
}

Stipple		"brick" {
		width			= 16
		height			= 16
		pattern			= (1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1) 
}

Stipple		"enter" {
		width			= 16
		height			= 16
		pattern			= (0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 
					   0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 
					   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0) 
}

Stipple		"horizontal" {
		width			= 8
		height			= 8
		pattern			= (1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 0, 0, 0, 0, 0, 
					   1, 1, 1, 1, 1, 1, 1, 1, 
					   0, 0, 0, 0, 0, 0, 0, 0) 
}

Stipple		"vertical" {
		width			= 8
		height			= 8
		pattern			= (1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0, 
					   1, 0, 1, 0, 1, 0, 1, 0) 
}

Stipple		"rectangleX" {
		width			= 1
		height			= 1
		pattern			= (0) 
}

LineStyle	"solid" {
		width			= 8
		height			= 1
		pattern			= (1, 1, 1, 1, 1, 1, 1, 1) 
}

LineStyle	"dot" {
		width			= 8
		height			= 1
		pattern			= (1, 0, 1, 0, 1, 0, 1, 0) 
}

LineStyle	"dash" {
		width			= 8
		height			= 1
		pattern			= (1, 1, 1, 0, 1, 1, 1, 0) 
}

LineStyle	"boundary" {
		width			= 10
		height			= 1
		pattern			= (1, 1, 1, 1, 1, 0, 0, 1, 0, 0) 
}

LineStyle	"none" {
		width			= 2
		height			= 1
		pattern			= (0, 0) 
}

Tile		"unit" {
		width				= 0.66
		height				= 5.04
}

Layer		"NWELL" {
		layerNumber			= 2
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"DIFF" {
		layerNumber			= 3
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "20"
		lineStyle			= "solid"
		pattern				= "zigzag"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"OD2" {
		layerNumber			= 4
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "22"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"PIMP" {
		layerNumber			= 7
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "14"
		lineStyle			= "dash"
		pattern				= "slash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"NIMP" {
		layerNumber			= 8
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "lead"
		lineStyle			= "dash"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"PDIFF" {
		layerNumber			= 11
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "19"
		lineStyle			= "solid"
		pattern				= "enter"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"NDIFF" {
		layerNumber			= 12
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "solid"
		pattern				= "zigzag"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"POLY1" {
		layerNumber			= 13
		maskName			= "poly"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "49"
		lineStyle			= "solid"
		pattern				= "solid"
		pitch				= 0
		defaultWidth			= 0.18
		minWidth			= 0.18
		minSpacing			= 0.25
}

Layer		"CONT" {
		layerNumber			= 15
		maskName			= "polyCont"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "27"
		lineStyle			= "solid"
		pattern				= "solid"
		pitch				= 0
		defaultWidth			= 0.22
		minWidth			= 0.22
		minSpacing			= 0.25
}

Layer		"METAL1" {
		layerNumber			= 16
		maskName			= "metal1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "cyan"
		lineStyle			= "solid"
		pattern				= "dot"
		pitch				= 0.56
		defaultWidth			= 0.23
		minWidth			= 0.23
		minSpacing			= 0.23
		fatWireThreshold		= 10
		fatThinMinSpacing		= 0.6
		fatFatMinSpacing		= 0.6
		maxSegLenForRC			= 2000
		maxCurrDensity			= 10
		unitMinResistance		= 0.000101
		unitNomResistance		= 0.000101
		unitMaxResistance		= 0.000101
		unitMinCapacitance		= 8.17e-05
		unitNomCapacitance		= 8.17e-05
		unitMaxCapacitance		= 8.17e-05
		unitMinSideWallCap		= 2.94e-05
		unitNomSideWallCap		= 2.94e-05
		unitMaxSideWallCap		= 2.94e-05
		unitMinChannelCap		= 3.78e-05
		unitNomChannelCap		= 3.78e-05
		unitMaxChannelCap		= 3.78e-05
		unitMinChannelSideCap		= 1.73e-05
		unitNomChannelSideCap		= 1.73e-05
		unitMaxChannelSideCap		= 1.73e-05
		unitMinHeightFromSub		= 0.88
		unitNomHeightFromSub		= 0.88
		unitMaxHeightFromSub		= 0.88
		unitMinThickness		= 0.53
		unitNomThickness		= 0.53
		unitMaxThickness		= 0.53
		minArea				= 0.202
}

Layer		"VIA12" {
		layerNumber			= 17
		maskName			= "via1"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "43"
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0.26
		minWidth			= 0.26
		minSpacing			= 0.26
		maxCurrDensity			= 414200
}

Layer		"METAL2" {
		layerNumber			= 18
		maskName			= "metal2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0.66
		defaultWidth			= 0.28
		minWidth			= 0.28
		minSpacing			= 0.28
		fatWireThreshold		= 10
		fatThinMinSpacing		= 0.6
		fatFatMinSpacing		= 0.6
		maxSegLenForRC			= 2000
		maxCurrDensity			= 10
		unitMinResistance		= 0.000101
		unitNomResistance		= 0.000101
		unitMaxResistance		= 0.000101
		unitMinCapacitance		= 2.04e-05
		unitNomCapacitance		= 2.04e-05
		unitMaxCapacitance		= 2.04e-05
		unitMinSideWallCap		= 1.29e-05
		unitNomSideWallCap		= 1.29e-05
		unitMaxSideWallCap		= 1.29e-05
		unitMinChannelCap		= 1.56e-05
		unitNomChannelCap		= 1.56e-05
		unitMaxChannelCap		= 1.56e-05
		unitMinChannelSideCap		= 1.12e-05
		unitNomChannelSideCap		= 1.12e-05
		unitMaxChannelSideCap		= 1.12e-05
		unitMinHeightFromSub		= 1.984
		unitNomHeightFromSub		= 1.984
		unitMaxHeightFromSub		= 1.984
		unitMinThickness		= 0.53
		unitNomThickness		= 0.53
		unitMaxThickness		= 0.53
		minArea				= 0.202
}

Layer		"PAD" {
		layerNumber			= 19
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "solid"
		pattern				= "zigzag"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"VIA23" {
		layerNumber			= 27
		maskName			= "via2"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.26
		minWidth			= 0.26
		minSpacing			= 0.26
		maxCurrDensity			= 414200
}

Layer		"METAL3" {
		layerNumber			= 28
		maskName			= "metal3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0.61
		defaultWidth			= 0.28
		minWidth			= 0.28
		minSpacing			= 0.28
		fatWireThreshold		= 10
		fatThinMinSpacing		= 0.6
		fatFatMinSpacing		= 0.6
		maxSegLenForRC			= 2000
		maxCurrDensity			= 10
		unitMinResistance		= 0.000101
		unitNomResistance		= 0.000101
		unitMaxResistance		= 0.000101
		unitMinCapacitance		= 1.14e-05
		unitNomCapacitance		= 1.14e-05
		unitMaxCapacitance		= 1.14e-05
		unitMinSideWallCap		= 8.5e-06
		unitNomSideWallCap		= 8.5e-06
		unitMaxSideWallCap		= 8.5e-06
		unitMinChannelCap		= 9.7e-06
		unitNomChannelCap		= 9.7e-06
		unitMaxChannelCap		= 9.7e-06
		unitMinChannelSideCap		= 8e-06
		unitNomChannelSideCap		= 8e-06
		unitMaxChannelSideCap		= 8e-06
		unitMinHeightFromSub		= 3.088
		unitNomHeightFromSub		= 3.088
		unitMaxHeightFromSub		= 3.088
		unitMinThickness		= 0.53
		unitNomThickness		= 0.53
		unitMaxThickness		= 0.53
		minArea				= 0.202
}

Layer		"VIA34" {
		layerNumber			= 29
		maskName			= "via3"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0.36
		minWidth			= 0.36
		minSpacing			= 0.35
		maxCurrDensity			= 414200
}

Layer		"METAL4" {
		layerNumber			= 31
		maskName			= "metal4"
		isDefaultLayer			= 1
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0.95
		defaultWidth			= 0.44
		minWidth			= 0.44
		minSpacing			= 0.46
		fatWireThreshold		= 10
		fatThinMinSpacing		= 0.6
		fatFatMinSpacing		= 0.6
		maxSegLenForRC			= 2000
		maxCurrDensity			= 16
		unitMinResistance		= 4.5e-05
		unitNomResistance		= 4.5e-05
		unitMaxResistance		= 4.5e-05
		unitMinCapacitance		= 7.9e-06
		unitNomCapacitance		= 7.9e-06
		unitMaxCapacitance		= 7.9e-06
		unitMinChannelCap		= 7e-06
		unitNomChannelCap		= 7e-06
		unitMaxChannelCap		= 7e-06
		unitMinHeightFromSub		= 4.192
		unitNomHeightFromSub		= 4.192
		unitMaxHeightFromSub		= 4.192
		unitMinThickness		= 0.99
		unitNomThickness		= 0.99
		unitMaxThickness		= 0.99
		minArea				= 0.562
}

Layer		"RPO" {
		layerNumber			= 34
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "21"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"TEXT1" {
		layerNumber			= 40
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "cyan"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"TEXT2" {
		layerNumber			= 41
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"TEXT3" {
		layerNumber			= 42
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"TEXT4" {
		layerNumber			= 43
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"PSUB2" {
		layerNumber			= 50
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "solid"
		pattern				= "zigzag"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"RPDMY" {
		layerNumber			= 54
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "33"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"DIODE" {
		layerNumber			= 56
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"SDI" {
		layerNumber			= 58
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		lineStyle			= "solid"
		pattern				= "zigzag"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"artiscanTEXT" {
		layerNumber			= 63
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "35"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"ESD2DMY" {
		layerNumber			= 137
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "32"
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"DMP2V" {
		layerNumber			= 149
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "35"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"DMN2V" {
		layerNumber			= 150
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "brown"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"ESD3DMY" {
		layerNumber			= 155
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "34"
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"RegionBlockage" {
		layerNumber			= 188
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"IGRPath" {
		layerNumber			= 189
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"routeGuide" {
		layerNumber			= 190
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "cyan"
		panelNumber			= 2
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"placeGuide" {
		layerNumber			= 191
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		panelNumber			= 2
		lineStyle			= "dash"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"OverlapCheck" {
		layerNumber			= 192
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"placeSRConst" {
		layerNumber			= 193
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"polyContOvrSize" {
		layerNumber			= 194
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via1OvrSize" {
		layerNumber			= 195
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via2OvrSize" {
		layerNumber			= 196
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via3OvrSize" {
		layerNumber			= 197
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "cyan"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via4OvrSize" {
		layerNumber			= 198
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "cyan"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via5OvrSize" {
		layerNumber			= 199
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "blue"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via11Blockage" {
		layerNumber			= 200
		maskName			= "via11Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal12Blockage" {
		layerNumber			= 201
		maskName			= "metal12Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"polyOvrSize" {
		layerNumber			= 202
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal1OvrSize" {
		layerNumber			= 203
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "blue"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal2OvrSize" {
		layerNumber			= 204
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "green"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal3OvrSize" {
		layerNumber			= 205
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal4OvrSize" {
		layerNumber			= 206
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"PRboundary" {
		layerNumber			= 207
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal7Blockage" {
		layerNumber			= 208
		maskName			= "metal7Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via7Blockage" {
		layerNumber			= 209
		maskName			= "via7Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal8Blockage" {
		layerNumber			= 210
		maskName			= "metal8Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via8Blockage" {
		layerNumber			= 211
		maskName			= "via8Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"polyBlockage" {
		layerNumber			= 212
		maskName			= "polyBlockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"Barrier" {
		layerNumber			= 213
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal9Blockage" {
		layerNumber			= 214
		maskName			= "metal9Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via9Blockage" {
		layerNumber			= 215
		maskName			= "via9Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal4Blockage" {
		layerNumber			= 216
		maskName			= "metal4Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via3Blockage" {
		layerNumber			= 217
		maskName			= "via3Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal1Blockage" {
		layerNumber			= 218
		maskName			= "metal1Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal2Blockage" {
		layerNumber			= 219
		maskName			= "metal2Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal3Blockage" {
		layerNumber			= 220
		maskName			= "metal3Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"PlaceBlockage" {
		layerNumber			= 221
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "rectangleX"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"SoftPlaceBlk" {
		layerNumber			= 222
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 2
		lineStyle			= "dash"
		pattern				= "enter"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"polyContBlockage" {
		layerNumber			= 223
		maskName			= "polyContBlockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via1Blockage" {
		layerNumber			= 224
		maskName			= "via1Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via2Blockage" {
		layerNumber			= 225
		maskName			= "via2Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "slash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"horChannel" {
		layerNumber			= 226
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"verChannel" {
		layerNumber			= 227
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"pinBlockage" {
		layerNumber			= 228
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "purple"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"hardFence" {
		layerNumber			= 229
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"polyContRegion" {
		layerNumber			= 230
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via1Region" {
		layerNumber			= 231
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via2Region" {
		layerNumber			= 232
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "green"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via3Region" {
		layerNumber			= 233
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "blue"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via4Region" {
		layerNumber			= 234
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "magenta"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"hilite" {
		layerNumber			= 235
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "white"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal10Blockage" {
		layerNumber			= 236
		maskName			= "metal10Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via10Blockage" {
		layerNumber			= 237
		maskName			= "via10Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal11Blockage" {
		layerNumber			= 238
		maskName			= "metal11Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal5Blockage" {
		layerNumber			= 239
		maskName			= "metal5Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"metal6Blockage" {
		layerNumber			= 240
		maskName			= "metal6Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via4Blockage" {
		layerNumber			= 241
		maskName			= "via4Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via5Blockage" {
		layerNumber			= 242
		maskName			= "via5Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"via6Blockage" {
		layerNumber			= 243
		maskName			= "via6Blockage"
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 3
		lineStyle			= "solid"
		pattern				= "backSlash"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"chanGate" {
		layerNumber			= 244
		maskName			= ""
		visible				= 0
		selectable			= 1
		blink				= 0
		color				= "cyan"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"coreRegion" {
		layerNumber			= 252
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"stdCellRow" {
		layerNumber			= 253
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "orange"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"stdCellRegion" {
		layerNumber			= 254
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "red"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

Layer		"boundary" {
		layerNumber			= 255
		maskName			= ""
		visible				= 1
		selectable			= 1
		blink				= 0
		color				= "yellow"
		panelNumber			= 2
		lineStyle			= "solid"
		pattern				= "blank"
		pitch				= 0
		defaultWidth			= 0
		minWidth			= 0
		minSpacing			= 0
}

ContactCode	"CONT1" {
		contactCodeNumber		= 1
		cutLayer			= "CONT"
		lowerLayer			= "POLY1"
		upperLayer			= "METAL1"
		isDefaultContact		= 1
		cutWidth			= 0.22
		cutHeight			= 0.22
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.01
		lowerLayerEncWidth		= 0.1
		lowerLayerEncHeight		= 0.1
		minCutSpacing			= 0.25
}

ContactCode	"via1" {
		contactCodeNumber		= 2
		cutLayer			= "VIA12"
		lowerLayer			= "METAL1"
		upperLayer			= "METAL2"
		isDefaultContact		= 1
		cutWidth			= 0.26
		cutHeight			= 0.26
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.01
		lowerLayerEncWidth		= 0.06
		lowerLayerEncHeight		= 0.01
		minCutSpacing			= 0.26
		unitMinResistance		= 0.0064
		unitNomResistance		= 0.0064
		unitMaxResistance		= 0.0064
}

ContactCode	"via2" {
		contactCodeNumber		= 3
		cutLayer			= "VIA23"
		lowerLayer			= "METAL2"
		upperLayer			= "METAL3"
		isDefaultContact		= 1
		cutWidth			= 0.26
		cutHeight			= 0.26
		upperLayerEncWidth		= 0.06
		upperLayerEncHeight		= 0.01
		lowerLayerEncWidth		= 0.06
		lowerLayerEncHeight		= 0.01
		minCutSpacing			= 0.26
		unitMinResistance		= 0.0064
		unitNomResistance		= 0.0064
		unitMaxResistance		= 0.0064
}

ContactCode	"via3" {
		contactCodeNumber		= 4
		cutLayer			= "VIA34"
		lowerLayer			= "METAL3"
		upperLayer			= "METAL4"
		isDefaultContact		= 1
		cutWidth			= 0.36
		cutHeight			= 0.36
		upperLayerEncWidth		= 0.09
		upperLayerEncHeight		= 0.09
		lowerLayerEncWidth		= 0.06
		lowerLayerEncHeight		= 0.01
		minCutSpacing			= 0.35
		unitMinResistance		= 0.00254
		unitNomResistance		= 0.00254
		unitMaxResistance		= 0.00254
}

FringeCap	1 {
		layer1				= "METAL4"
		layer2				= "METAL3"
		minFringeCap			= 8.2e-05
		nomFringeCap			= 8.2e-05
		maxFringeCap			= 8.2e-05
}

FringeCap	2 {
		layer1				= "METAL4"
		layer2				= "METAL2"
		minFringeCap			= 3.68e-05
		nomFringeCap			= 3.68e-05
		maxFringeCap			= 3.68e-05
}

FringeCap	3 {
		layer1				= "METAL4"
		layer2				= "METAL1"
		minFringeCap			= 2.52e-05
		nomFringeCap			= 2.52e-05
		maxFringeCap			= 2.52e-05
}

FringeCap	4 {
		layer1				= "METAL3"
		layer2				= "METAL2"
		minFringeCap			= 0.00011
		nomFringeCap			= 0.00011
		maxFringeCap			= 0.00011
}

FringeCap	5 {
		layer1				= "METAL3"
		layer2				= "METAL1"
		minFringeCap			= 5.29e-05
		nomFringeCap			= 5.29e-05
		maxFringeCap			= 5.29e-05
}

FringeCap	6 {
		layer1				= "METAL2"
		layer2				= "METAL1"
		minFringeCap			= 0.0001254
		nomFringeCap			= 0.0001254
		maxFringeCap			= 0.0001254
}

FringeCap	7 {
		layer1				= "METAL4"
		layer2				= "METAL4"
		minFringeCap			= 0.000116
		nomFringeCap			= 0.000116
		maxFringeCap			= 0.000116
}

FringeCap	8 {
		layer1				= "METAL3"
		layer2				= "METAL3"
		minFringeCap			= 9.31e-05
		nomFringeCap			= 9.31e-05
		maxFringeCap			= 9.31e-05
}

FringeCap	9 {
		layer1				= "METAL2"
		layer2				= "METAL2"
		minFringeCap			= 9.26e-05
		nomFringeCap			= 9.26e-05
		maxFringeCap			= 9.26e-05
}

FringeCap	10 {
		layer1				= "METAL1"
		layer2				= "METAL1"
		minFringeCap			= 0.000104
		nomFringeCap			= 0.000104
		maxFringeCap			= 0.000104
}

DesignRule	{
		layer1				= "VIA23"
		layer2				= "VIA12"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "VIA34"
		layer2				= "VIA23"
		minSpacing			= 0
		stackable			= 1
}

DesignRule	{
		layer1				= "via1Blockage"
		layer2				= "VIA12"
		minSpacing			= 0.26
}

DesignRule	{
		layer1				= "via2Blockage"
		layer2				= "VIA23"
		minSpacing			= 0.26
}

DesignRule	{
		layer1				= "via3Blockage"
		layer2				= "VIA34"
		minSpacing			= 0.35
}

PRRule		{
		rowSpacingTopTop		= 0
		rowSpacingTopBot		= 1.03
		rowSpacingBotBot		= 0
		abuttableTopTop			= 1
		abuttableTopBot			= 0
		abuttableBotBot			= 1
}
