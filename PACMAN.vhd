 --Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo          : Counter_Count_Pixel_X
-- Funcionalidad   : Contador para generar el PIXEL X                  
-- Fecha           : D:21 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
	ENTITY PACMAN IS
		GENERIC(	Max		:	INTEGER:= 10;
				   PIXEL 	: 	INTEGER:= 12);
		PORT(	
				clk 			: IN	 STD_LOGIC;
				rst			: IN	 STD_LOGIC;
				start			: IN	 STD_LOGIC;
				up				: IN 	 STD_LOGIC;
				down			: IN 	 STD_LOGIC;
				leftt			: IN 	 STD_LOGIC;
				rightt		: IN 	 STD_LOGIC;
				up1			: IN 	 STD_LOGIC;
				down1			: IN 	 STD_LOGIC;
				leftt1		: IN 	 STD_LOGIC;
				rightt1		: IN 	 STD_LOGIC;
				hsync     	: OUT  STD_LOGIC;
            vsync     	: OUT  STD_LOGIC;
            RGB       	: OUT  STD_LOGIC_VECTOR(PIXEL-1 DOWNTO 0);
				Hex0        : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
				Hex1        : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
				Hex2        : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
				Hex3        : OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
			 );
END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF PACMAN IS
--********************************************************
 --
 --*******************************************************

SIGNAL 	up_s 			: STD_LOGIC;
SIGNAL 	down_s   	: STD_LOGIC;
SIGNAL 	leftt_s   	: STD_LOGIC;
SIGNAL 	rightt_s   	: STD_LOGIC;
SIGNAL 	up1_s 		: STD_LOGIC;
SIGNAL 	down1_s   	: STD_LOGIC;
SIGNAL 	leftt1_s   	: STD_LOGIC;
SIGNAL 	rightt1_s   : STD_LOGIC;

SIGNAL 	video_on_s	: STD_LOGIC;

SIGNAL   Collision_s : STD_LOGIC;
SIGNAL   Collision1_s : STD_LOGIC;

SIGNAL  pixel_x_s1	 :  INTEGER;
SIGNAL  pixel_y_s1	 :  INTEGER;
SIGNAL  pixel_x_s     :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
SIGNAL  pixel_y_s     :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
SIGNAL  RGB_s         :  STD_LOGIC_VECTOR(PIXEL-1 DOWNTO 0);

SIGNAL pacman_x_s     : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
SIGNAL pacman_y_s     : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);

SIGNAL ghost_x_s     : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
SIGNAL ghost_y_s     : STD_LOGIC_VECTOR(Max-1 DOWNTO 0);

SIGNAL Dato_Score_s   : STD_LOGIC_VECTOR(12 DOWNTO 0);

SIGNAL Hex0_s, Hex1_s, Hex2_s, Hex3_s  :  STD_LOGIC_VECTOR(6 DOWNTO 0);

SIGNAL Conteo_s       : STD_LOGIC;
 

BEGIN


----------------------------------------------------------
----------------------------------------------------------
VGA_Sync:ENTITY WORK.VGA_Controller
		GENERIC MAP(Max	 => Max)
		PORT MAP(
			Clk             => clk,
			Rst             => rst,
			video_on        => video_on_s,
			hsync		       => hsync,
			vsync	   	    => vsync,
			pixel_x			 => pixel_x_s,
			pixel_y  		 => pixel_y_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce1:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => up,
			led		       => up_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce2:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => down,
			led		       => down_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce3:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => leftt,
			led		       => leftt_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce4:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => rightt,
			led		       => rightt_s
		);
----------------------------------------------------------		
Debounce5:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => up1,
			led		       => up1_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce6:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => down1,
			led		       => down1_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce7:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => leftt1,
			led		       => leftt1_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Debounce8:ENTITY WORK.Debouncer
		GENERIC MAP(N 	 => 16, 
						Max => 25)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			InputPulse      => rightt1,
			led		       => rightt1_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Pacmann:ENTITY WORK.Pacman_Ctrl
		GENERIC MAP(N => Max)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			Start           => start,
			up 		       => up_s,
			down		       => down_s,
			leftt		       => leftt_s,
			rightt			 => rightt_s,
			Collision       => Collision_s,
			Pacman_x        => Pacman_x_s,
			Pacman_y        => Pacman_y_s
		);
----------------------------------------------------------
----------------------------------------------------------		
Fantasmita:ENTITY WORK.Ghost_Ctrl
		GENERIC MAP(N => Max)
		PORT MAP(
			clk             => clk,
			rst             => rst,
			Start           => start,
			up 		       => up1_s,
			down		       => down1_s,
			leftt		       => leftt1_s,
			rightt			 => rightt1_s,
			Collision       => Collision1_s,
			Ghost_x         => ghost_x_s,
			Ghost_y         => ghost_y_s
		);
----------------------------------------------------------			
	Pixel_Gen:ENTITY WORK.Pixel_Generator
	   GENERIC MAP (Max    	 => Max,
						 PIXEL 	 => PIXEL,
						 PAC_Q 	 => 20,
						 ADDR_PAC => 5)
		PORT MAP(
			clk   			 =>  clk, 
			rst             =>  rst,
			Start           =>  start,
			pixel_x   		 =>  pixel_x_s,
			pixel_y      	 =>  pixel_y_s,
			Pacmanx			 =>  Pacman_x_s,
			PacmanY			 =>  Pacman_y_s,
			Ghost_x_IN			 =>  ghost_x_s,
			Ghost_y_IN			 =>  ghost_y_s,
			RGB      		 =>  RGB_s,
			Score_Pac       =>  Dato_Score_s
		);
		
----------------------------------------------------------			
	Collis_Ctrl:ENTITY WORK.Collision_Ctrl
	   GENERIC MAP (N    	 => 10)
		PORT MAP(
		   clk   			 =>  clk, 
			rst             =>  rst,
			Pacman_x   		 =>  Pacman_x_s,
			Pacman_y      	 =>  Pacman_y_s,
			Collision	    =>  Collision_s
		);
	----------------------------------------------------------			
	Collis_Ctrl2:ENTITY WORK.Collision_Ctrl
	   GENERIC MAP (N    	 => 10)
		PORT MAP(
		   clk   			 =>  clk, 
			rst             =>  rst,
			Pacman_x   		 =>  ghost_x_s,
			Pacman_y      	 =>  ghost_y_s,
			Collision	    =>  Collision1_s
		);
			
	--------------------------------------------------------
	Seven_Seg: ENTITY WORK.BCD_CONVERTER
	  GENERIC MAP(	Max  => 13)
		PORT MAP(	
		      clk 		    =>  clk, 
				enable		 =>  '1',
				ena_display  =>  '1',
				fin_serie    =>  '0',
				rst			 =>  rst,
				Dato_Score	 => Dato_Score_s,
				SevenSeg3	 => Hex3_s,
				SevenSeg2	 => Hex2_s,
				SevenSeg1	 => Hex1_s,
				SevenSeg0	 => Hex0_s
			 );
	
	
	--==========================================================================
	-- Output Logic
	--==========================================================================
	
 WITH video_on_s SELECT 
       RGB <= RGB_s WHEN '1',
		        "000000000000" WHEN OTHERS;   
  Hex0 <= Hex0_s;
  Hex1 <= Hex1_s;
  Hex2 <= Hex2_s;
  Hex3 <= Hex3_s;

END ARCHITECTURE;