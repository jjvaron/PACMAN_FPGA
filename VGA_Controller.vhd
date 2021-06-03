-- Ruler 1         2         3         4         5         6         7        --
--****************************************************************************--
--                     PONTIFICIA UNIVERSIDAD JAVERIANA              
--                            Diseño en FPGA
-- 													             
-- Titulo         : VGA_Controller
-- Funcionalidad  : Controlador del VGA.                                         
-- Fecha          : D:21 M:04 Y:2021                       
--****************************************************************************--


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ENTITY VGA_Controller IS

	GENERIC(	Max			:	INTEGER:= 10);
		PORT(	
		      clk 		     : IN	STD_LOGIC;
				rst           : IN   STD_LOGIC;
				 
				pixel_x       : OUT  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
            pixel_y       : OUT  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
            video_on      : OUT  STD_LOGIC;
            hsync         : OUT  STD_LOGIC;
            vsync         : OUT  STD_LOGIC		
			 );

END ENTITY;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
ARCHITECTURE Behaviour OF VGA_Controller IS

   SIGNAL  pixel_clk_s   :  STD_LOGIC;
	
	SIGNAL  pixel_x_s     :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL  Count_Pixel_X_s :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL  pixel_y_s     :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL  Count_Pixel_Y_s :  STD_LOGIC_VECTOR(Max-1 DOWNTO 0);
	SIGNAL  h_video_on_s  :  STD_LOGIC;
	SIGNAL  v_video_on_s  :  STD_LOGIC;
	SIGNAL  hsync_s       :  STD_LOGIC;
	SIGNAL  vsync_s       :  STD_LOGIC;
	SIGNAL  end_H_s       :  STD_LOGIC; 
	SIGNAL  video_on_s    :  STD_LOGIC;

	SIGNAL  Sequence_V_s  :  STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL  Sequence_H_s  :  STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL  ena_X_s       :  STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL  synClr_X_s    :  STD_LOGIC;
	
	
BEGIN


 PROCESS(clk)
    BEGIN
        IF(clk'EVENT AND clk='1') THEN
            pixel_clk_s    <= NOT pixel_clk_s;
        END IF;
    END PROCESS;
	 
	 

	-----------------------------------------------------------------------------
	C_PIXELx:ENTITY WORK.Counter_Pixel_X
		GENERIC MAP(N => Max)
		PORT MAP(
			Clk             => pixel_clk_s,
			Rst             => rst,
			Sequence_H	    => Sequence_H_s,
			end_H           => end_H_s,
			Count_Pixel_X   => Count_Pixel_X_s
		);
	-----------------------------------------------------------------------------
	Control_X:ENTITY WORK.CTRL_Hsync
		PORT MAP(
			Sequence_H     =>  Sequence_H_s,
			hsync          =>  hsync_s,
			h_video_on     =>  h_video_on_s
		);
	-----------------------------------------------------------------------------
	C_PIXELy:ENTITY WORK.Counter_Pixel_Y
		GENERIC MAP(N => Max)
		PORT MAP(
			Clk             => pixel_clk_s,
			Rst             => rst,
			Ena    	       => end_H_s,
			Sequence_V	    => Sequence_V_s,
			Count_Pixel_Y   => Count_Pixel_Y_s
		);
	-----------------------------------------------------------------------------
	Control_Y:ENTITY WORK.CTRL_Vsync
		PORT MAP(
		   Sequence_V     =>  Sequence_V_s,
			vsync          =>  vsync_s,
			v_video_on     =>  v_video_on_s
		);	
	
	-----------------------------------------------------------------------------
	Out_VGA:ENTITY WORK.Out_Control_VGA
	   GENERIC MAP (N => Max)
		PORT MAP(
			Count_Pixel_Y   =>  Count_Pixel_Y_s, 
			Count_Pixel_X   =>  Count_Pixel_X_s,
			v_video_on      =>  v_video_on_s,
			h_video_on      =>  h_video_on_s,
			video_on        =>  video_on_s,
			pixel_x         =>  pixel_x_s,
			pixel_y         =>  pixel_y_s
		);
	
	-----------------------------------------------------------------------------
	
	--==========================================================================
	-- Output Logic
	--==========================================================================				 
	pixel_x   <=  pixel_x_s;
	pixel_y   <=  pixel_y_s;
	hsync     <=  hsync_s;
	vsync     <=  vsync_s;
	video_on  <=  video_on_s;
	

END ARCHITECTURE;