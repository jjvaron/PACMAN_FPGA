-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo          : Out_Control_VGA
-- Funcionalidad   : Salidas del Pixel X y Y además del VIDEO_ON                 
-- Fecha           : D:24 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY Out_Control_VGA IS

  GENERIC(	N			:	INTEGER:= 10);
		PORT(	
				Count_Pixel_Y : IN    STD_LOGIC_VECTOR (N-1 DOWNTO 0);
				Count_Pixel_X : IN    STD_LOGIC_VECTOR (N-1 DOWNTO 0);
				v_video_on    : IN    STD_LOGIC;
				h_video_on    : IN    STD_LOGIC;
				
				video_on      : OUT   STD_LOGIC;
				pixel_x       : OUT   STD_LOGIC_VECTOR (N-1 DOWNTO 0);
				pixel_y       : OUT   STD_LOGIC_VECTOR (N-1 DOWNTO 0)
				
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF Out_Control_VGA IS

	SIGNAL   video_on_s       : STD_LOGIC;
	
BEGIN
   
	video_on_s  <= '1' WHEN (h_video_on='1' AND v_video_on='1') ELSE
	             '0';
	pixel_x <= STD_LOGIC_VECTOR(UNSIGNED(Count_Pixel_X)-144)  WHEN video_on_s='1' ELSE 
	             "0000000000";
   pixel_y <= STD_LOGIC_VECTOR(UNSIGNED(Count_Pixel_Y)-35)  WHEN video_on_s='1' ELSE 
	             "0000000000";

	video_on <= video_on_s;
END ARCHITECTURE;