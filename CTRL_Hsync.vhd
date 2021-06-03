-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo          : CTRL_Hsync
-- Funcionalidad   : Control VGA para Vsync                 
-- Fecha           : D:23 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY CTRL_Hsync IS

		PORT(	
			Sequence_H     :  IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
			hsync          :  OUT  STD_LOGIC;
			h_video_on     :  OUT  STD_LOGIC
				
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF CTRL_Hsync IS

BEGIN
   hsync  <= '1' WHEN (sequence_H= "001" OR sequence_H="010" OR 
	                    sequence_H= "011") ELSE
	          '0';
   h_video_on <= '1' WHEN (Sequence_H="010") ELSE
	              '0';
	
END ARCHITECTURE;