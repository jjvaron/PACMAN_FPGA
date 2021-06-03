-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            DiseÃ±o en FPGA
-- 													             
-- Titulo :   Control_SFibon
-- Funcionalidad: Registro que guarda el resultado de la serie de Fibonnacci.                                        
-- Fecha  :   D:02 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Pacman_Ctrl IS

	GENERIC(	N				: INTEGER:= 10
				);
		PORT(	
				clk 			: IN		STD_LOGIC;
				rst			: IN		STD_LOGIC;
				Start			: IN		STD_LOGIC;
				up				: IN		STD_LOGIC;
				down			: IN		STD_LOGIC;
				leftt			: IN 	 	STD_LOGIC;
				rightt		: IN 	 	STD_LOGIC;
				Collision   : IN     STD_LOGIC;
				Pacman_x		: OUT		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
				Pacman_y		: OUT		STD_LOGIC_VECTOR(N-1 DOWNTO 0)
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Pacman_Ctrl IS

	SIGNAL y_pos         : INTEGER:=17;
	SIGNAL x_pos		   : INTEGER:= 43; 
	SIGNAL ena_count		: STD_LOGIC;
	SIGNAL Count			: INTEGER:=0;
	CONSTANT Max			: INTEGER:= 750000;
	
BEGIN

	ena_count <= up XOR down XOR rightt XOR leftt;
	
	Actual_Pos: PROCESS(rst,clk,up,down,collision, Start) 
		BEGIN	
	
	--	71  ---205
   --	372 ---74
	
	
			IF(rst = '1') THEN
				x_pos <= 23+20;
				y_pos <= 17;
				Count <= 0;	
			ELSE
			   IF(RISING_EDGE(clk)) THEN 
					IF (ena_count = '1' ) THEN 
						----------------------------------------------------
						IF(Count = MAX) THEN
					      -------------------------------------------------	
						   IF(up = '1') THEN 
							 Count <= 0;
							   --------------------------------------------
								IF(y_pos<= 10) THEN
									y_pos <=  y_pos;
									
								ELSIF(collision= '1') THEN
									y_pos <=  y_pos+5;
									
								ELSE 
									y_pos <= y_pos -1;
						      END IF;
							----------------------------------------------------
							ELSIF (down = '1') THEN
						      Count <= 0;	
							   -------------------------------------------------
								IF(y_pos >= 454) THEN
									y_pos <= y_pos;
									
								ELSIF(collision= '1') THEN
									y_pos <=  y_pos-5;
									
								ELSE
									y_pos <= y_pos + 1;
								END IF;
							--------------------------------------------------------
							ELSE 
									y_pos <= y_pos;
							END IF;
					      --------------------------------------------------------
							--------------------------------------------------------
							
							IF(leftt = '1') THEN 
							   Count <= 0;	 
							   -----------------------------------------------------
								IF(x_pos<= 27) THEN
									x_pos <=  x_pos;
									
								ELSIF(collision= '1') THEN
									x_pos <=  x_pos+5;
									
								ELSE 
									x_pos <= x_pos -1;
								END IF;
							--------------------------------------------------------------
							ELSIF (rightt = '1') THEN 
							   Count <= 0;	
							   -----------------------------------------------------------
								IF(x_pos >= 580 ) THEN
									x_pos <= x_pos;
									
								ELSIF(collision= '1') THEN
									x_pos <=  x_pos-5;
									
								ELSE
									x_pos <= x_pos + 1;
								END IF;
								------------------------------------------------------------
					     ELSE 
						     x_pos <= x_pos;
					     END IF;
						------------------------------------------------------------------  
						ELSE
							Count <= Count +1;						 
						END IF; -- END COUNT MAX
				----------------------------------------------------------------		
					END IF;-- END ENA COUNT	
				END IF;--END CLK
			END IF; -- END RST
		END PROCESS;
					
	Pacman_y <= STD_LOGIC_VECTOR(TO_UNSIGNED(y_pos,N));
	Pacman_x <= STD_LOGIC_VECTOR(TO_UNSIGNED(x_pos,N));
	
END ARCHITECTURE;