-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo :   BCD_CONVERTER
-- Funcionalidad: Convierte los datos de la serie de Dato_Score para ser 
--                mostrados en los 4 displays 7 segmentos.                                         
-- Fecha  :   D:10 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY BCD_CONVERTER IS

	GENERIC(	Max			:	INTEGER:= 13);
		PORT(	
		      clk 		   : IN	STD_LOGIC;
				enable		: IN	STD_LOGIC;
				ena_display : IN  STD_LOGIC;
				fin_serie   : IN  STD_LOGIC;
				rst			: IN  STD_LOGIC;
				Dato_Score	: IN 	STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
				SevenSeg3	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				SevenSeg2	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				SevenSeg1	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
				SevenSeg0	: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF BCD_CONVERTER IS
	SIGNAL Mil_out		    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL Cent_out	    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL Dec_out		    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL Unit_out	    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL in_cent		    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL in_dec		    : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	
	SIGNAL en_count	    : STD_LOGIC;
	
	SIGNAL ena_divide_s   : STD_LOGIC_VECTOR (2 DOWNTO 0):= "111";
	SIGNAL enable7Seg_S   : STD_LOGIC_VECTOR (3 DOWNTO 0):= "1111";
   SIGNAL aclr_divide_s  : STD_LOGIC_VECTOR (2 DOWNTO 0);	
	
BEGIN
	
	------------------------------------------------
	Div_Mil:ENTITY WORK.Division 
	PORT MAP(
		clock	 	 => clk,
		denom		 => "0001111101000",
		numer		 => Dato_Score,
		quotient	 => Mil_out,
		remain	 => in_cent
	);
	------------------------------------------------
	Div_Cent:ENTITY WORK.Division 
	PORT MAP(
		clock	 	 => clk,
		denom		 => "0000001100100",
		numer		 => in_cent,
		quotient	 => Cent_out,
		remain	 => in_dec
	);

	------------------------------------------------
	Div_Dec: ENTITY WORK.Division 
	PORT MAP(
		clock	 	 => clk,
		denom		 => "0000000001010",
		numer		 => in_dec,
		quotient	 => Dec_out,
		remain	 => Unit_out
	);
	
	------------------------------------------------

	Seg_Mills: ENTITY WORK.sevenSegmentDecoder 
	PORT MAP (
				 enable	=> enable7Seg_S(3),
				 input 	=> Mil_out,
				 output	=> SevenSeg3
				 );
 ------------------------------------------------	
	Seg_Centen: ENTITY WORK.sevenSegmentDecoder 
	PORT MAP (
				 enable	=> enable7Seg_S(2),
				 input 	=> Cent_out,
				 output	=> SevenSeg2
				 );
  ------------------------------------------------	
	Seg_Decen: ENTITY WORK.sevenSegmentDecoder 
	PORT MAP (
				 enable	=> enable7Seg_S(1),
				 input 	=> Dec_out,
				 output	=> SevenSeg1
				 );
 ------------------------------------------------	
	Seg_Unidad: ENTITY WORK.sevenSegmentDecoder 
	PORT MAP (
				 enable	=> enable7Seg_S(0),
				 input 	=> Unit_out,
				 output	=> SevenSeg0
				 );
				 
END ARCHITECTURE;