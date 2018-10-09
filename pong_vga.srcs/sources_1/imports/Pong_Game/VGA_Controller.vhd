----------------------------------------------------------------------------------
-- Company: KU Leuven Campus Group T
-- Engineer: Yujie Zhou
-- 
-- Create Date: 2018/10/01 21:45:59
-- Design Name: VGA Controller
-- Module Name: vga_controller - Behavioral
-- Project Name: Pong Arcade Game
-- Target Devices: Zybo
-- Tool Versions: Vivado 2017.4
-- Description:
-- VGA Controller  800 x 600 @ 60Hz
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- Refrenced VGA Controller from: https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278#VGAController(VHDL)-VGAController
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is

GENERIC(
        -- VGA Signal 800x600 @ 60Hz timing
		h_pulse 	:	INTEGER := 128;    	--horiztonal sync pulse width in pixels
		h_bp	 	:	INTEGER := 88;		--horiztonal back porch width in pixels
		h_pixels	:	INTEGER := 800;		--horiztonal display width in pixels
		h_fp	 	:	INTEGER := 40;		--horiztonal front porch width in pixels

		v_pulse 	:	INTEGER := 4;			--vertical sync pulse width in rows
		v_bp	 	:	INTEGER := 23;			--vertical back porch width in rows
		v_pixels	:	INTEGER := 600;		--vertical display width in rows
		v_fp	 	:	INTEGER := 1);			--vertical front porch width in rows

    -- I/O Definition
    Port ( clk : in STD_LOGIC;              --pixel clock at frequency of VGA mode being used
           reset : in STD_LOGIC;             --active low asycnchronous reset
           X : out UNSIGNED(31 DOWNTO 0);                     --horizontal pixel coordinate
           Y : out UNSIGNED(31 DOWNTO 0);                     --vertical pixel coordinate
           hsync : out STD_LOGIC;          --horiztonal sync pulse
           vsync : out STD_LOGIC;          --vertical sync pulse
           disp_en : out STD_LOGIC);      --display enable ('1' = display time, '0' = blanking time)
end vga_controller;

    architecture Behavioral of vga_controller is

CONSTANT	h_period	:	INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
CONSTANT	v_period	:	INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column

BEGIN

    process(clk, reset)
		VARIABLE h_count	:	INTEGER RANGE 0 TO h_period -  1 := 0;  --horizontal counter (counts the columns)
		VARIABLE v_count	:	INTEGER RANGE 0 TO v_period - 1 := 0;  --vertical counter (counts the rows)
	BEGIN
		IF(reset = '0') THEN		--reset asserted
			h_count := 0;				--reset horizontal counter
			v_count := 0;				--reset vertical counter
			hsync <= '1';		--deassert horizontal sync
			vsync <= '1';		--deassert vertical sync
			disp_en <= '0';			--disable display
			X <= "00000000000000000000000000000000";				--reset column pixel coordinate
			Y <= "00000000000000000000000000000000";					--reset row pixel coordinate
			
		ELSIF(clk'EVENT AND clk = '1') THEN

			--counters
			IF(h_count < h_period - 1) THEN		--horizontal counter (pixels)
				h_count := h_count + 1;
			ELSE
				h_count := 0;
				IF(v_count < v_period - 1) THEN	--veritcal counter (rows)
					v_count := v_count + 1;
				ELSE
					v_count := 0;
				END IF;
			END IF;

			--horizontal sync signal
			IF(h_count < h_pixels + h_fp OR h_count >= h_pixels + h_fp + h_pulse) THEN
				hsync <= '1';		--deassert horiztonal sync pulse
			ELSE
				hsync <= '0';			--assert horiztonal sync pulse
			END IF;
			
			--vertical sync signal
			IF(v_count < v_pixels + v_fp OR v_count >= v_pixels + v_fp + v_pulse) THEN
				vsync <= '1';		--deassert vertical sync pulse
			ELSE
				vsync <= '0';			--assert vertical sync pulse
			END IF;
			
			--set pixel coordinates
			IF(h_count < h_pixels) THEN  	--horiztonal display time
				X <= TO_UNSIGNED(h_count,32);			--set horiztonal pixel coordinate
			END IF;
			IF(v_count < v_pixels) THEN	--vertical display time
				Y <=  TO_UNSIGNED(v_count,32);				--set vertical pixel coordinate
			END IF;

			--set display enable output
			IF(h_count < h_pixels AND v_count < v_pixels) THEN  	--display time
				disp_en <= '1';											 	--enable display
			ELSE																	--blanking time
				disp_en <= '0';												--disable display
			END IF;

		END IF;
	END PROCESS;

END Behavioral;