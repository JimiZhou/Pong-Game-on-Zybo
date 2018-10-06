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
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity image_source is
GENERIC(
    pixels_y :  INTEGER := 600;   --row that first color will persist until
    pixels_x :  INTEGER := 800);  --column that first color will persist until
  PORT(
    clk : in STD_LOGIC;              --pixel clock at frequency of VGA mode being used
    disp_en :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    X      :  IN   UNSIGNED(31 DOWNTO 0);    --row pixel coordinate
    Y   :  IN   UNSIGNED(31 DOWNTO 0);    --column pixel coordinate
    -- Position inputs
    X_BALL: IN UNSIGNED(15 DOWNTO 0); -- Ball X position
    Y_BALL: IN UNSIGNED(15 DOWNTO 0); -- Ball Y position
    Y_PADDLE_LEFT: IN UNSIGNED(15 DOWNTO 0); -- Left paddle y position
    Y_PADDLE_RIGHT: IN UNSIGNED(15 DOWNTO 0); -- Right paddle y position
    -- RGB outputs
    red      :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC

end image_source;

    architecture Behavioral of image_source is

type rom is array (0 to 319) of std_logic_vector(0 to 7);
 -- ROM definition
 type rom_ball is array (0 to 15) of std_logic_vector(0 to 15);

-- 16 X 16 pixel ball
 constant BALL: rom_ball :=
 (
 "0000011111100000", -- ****
 "0001110101011000", -- ******
 "0010000010101100", -- ********
 "0110000000010110", -- ********
 "0100000001010110", -- ********
 "1000000000010011", -- ********
 "1000000000101111", -- ******
 "1000000000010101", -- ****
 "1000000001010011", -- ****
 "1010100001010111", -- ******
 "1010101010111011", -- ********
 "0101010101001010", -- ********
 "0100000001010110", -- ********
 "0011101101011100", -- ********
 "0001111011111000", -- ******
 "0000011111100000" -- ****
 );
 
  constant FONT: rom :=
 (
 x"00",x"18",x"24",x"24",x"3C",x"24",x"24",x"00",
 x"00",x"38",x"24",x"38",x"24",x"24",x"38",x"00",
 x"00",x"18",x"24",x"20",x"20",x"24",x"18",x"00",
 x"00",x"38",x"24",x"24",x"24",x"24",x"38",x"00",
 x"00",x"3C",x"20",x"38",x"20",x"20",x"3C",x"00",
 x"00",x"3C",x"20",x"38",x"20",x"20",x"20",x"00",
 x"00",x"18",x"24",x"20",x"2C",x"24",x"18",x"00",
 x"00",x"24",x"24",x"3C",x"24",x"24",x"24",x"00",
 x"00",x"38",x"10",x"10",x"10",x"10",x"38",x"00",
 x"00",x"04",x"04",x"04",x"04",x"24",x"18",x"00",
 x"00",x"28",x"28",x"30",x"28",x"24",x"24",x"00",
 x"00",x"20",x"20",x"20",x"20",x"20",x"3C",x"00",
 x"00",x"44",x"6C",x"54",x"44",x"44",x"44",x"00",
 x"00",x"24",x"34",x"34",x"2C",x"2C",x"24",x"00",
 x"00",x"18",x"24",x"24",x"24",x"24",x"18",x"00",
 x"00",x"38",x"24",x"24",x"38",x"20",x"20",x"00",
 x"00",x"18",x"24",x"24",x"24",x"24",x"1C",x"02",
 x"00",x"38",x"24",x"24",x"38",x"24",x"24",x"00",
 x"00",x"1C",x"20",x"18",x"04",x"04",x"38",x"00",
 x"00",x"38",x"10",x"10",x"10",x"10",x"10",x"00",
 x"00",x"24",x"24",x"24",x"24",x"24",x"3C",x"00",
 x"00",x"24",x"24",x"24",x"24",x"14",x"0C",x"00",
 x"00",x"44",x"44",x"44",x"54",x"6C",x"44",x"00",
 x"00",x"24",x"24",x"10",x"08",x"24",x"24",x"00",
 x"00",x"22",x"22",x"14",x"08",x"08",x"08",x"00",
 x"00",x"3C",x"04",x"08",x"10",x"20",x"3C",x"00",
 x"00",x"18",x"24",x"2C",x"34",x"34",x"18",x"00",
 x"00",x"10",x"30",x"10",x"10",x"10",x"38",x"00",
 x"00",x"18",x"24",x"04",x"18",x"20",x"3C",x"00",
 x"00",x"38",x"04",x"18",x"04",x"04",x"38",x"00",
 x"00",x"20",x"28",x"28",x"3C",x"08",x"08",x"00",
 x"00",x"3C",x"20",x"38",x"04",x"04",x"38",x"00",
 x"00",x"1C",x"20",x"38",x"24",x"24",x"18",x"00",
 x"00",x"3C",x"04",x"08",x"10",x"10",x"10",x"00",
 x"00",x"18",x"24",x"18",x"24",x"24",x"18",x"00",
 x"00",x"18",x"24",x"24",x"1C",x"04",x"38",x"00",
 x"00",x"6C",x"FE",x"FE",x"7C",x"38",x"10",x"00",
 x"10",x"10",x"10",x"10",x"10",x"00",x"10",x"00",
 x"10",x"20",x"40",x"FF",x"40",x"20",x"10",x"00",
 x"08",x"04",x"02",x"FF",x"02",x"04",x"08",x"00"
 );

      
CONSTANT size: INTEGER := 8;
CONSTANT size_ball: INTEGER := 16;
CONSTANT factor: INTEGER :=1;
-- Paddle width
CONSTANT PADDLE_WID: INTEGER:=15;
-- Paddle length
CONSTANT PADDLE_LEN: INTEGER:= 70;
-- Wall top and bottom boundary
CONSTANT BOUND_THICK: INTEGER := 20;
-- Middle dash line
CONSTANT DASH_LEFT: INTEGER := 395;
CONSTANT DASH_RIGHT: INTEGER := 405;

BEGIN

  PROCESS(disp_en, X, Y)

  BEGIN

    IF(clk'EVENT AND clk = '1') THEN
       
        IF(disp_en = '1')THEN --display time
            
            -- Draw the ball
            IF((Y >=BOUND_THICK+Y_BALL) AND (Y < BOUND_THICK + Y_BALL + size_ball*factor) AND (X>=X_BALL) AND (X< X_BALL + size_ball*factor)) THEN
                    FOR temp_y in 0 to size_ball-1 LOOP
                        FOR temp_x in 0 to size_ball-1 LOOP
                                IF(X>=X_BALL + temp_x*factor and X< X_BALL + temp_x*factor+factor) and (Y >= BOUND_THICK+Y_BALL+temp_y*factor and Y < BOUND_THICK + Y_BALL+temp_y*factor+factor) THEN
                                            IF BALL(temp_y)(temp_x) = '1' THEN
                                                    red <= (OTHERS => '1');
                                                    green <= (OTHERS => '1');
                                                     blue <= (OTHERS => '1');
                                            ELSE                           
                                                    red <= (OTHERS => '0');
                                                    green <= (OTHERS => '0');
                                                    blue <= (OTHERS => '0');
                                            END IF;
                                END IF;
                            END LOOP;
                    END LOOP;
            ELSE                           
                                                                        red <= (OTHERS => '0');
                                                                        green <= (OTHERS => '0');
                                                                        blue <= (OTHERS => '0');
            END IF;
            
  
        -- Draw the boundary        
        IF((Y>0 AND Y<BOUND_THICK) OR (Y > pixels_y-BOUND_THICK AND Y < pixels_y))THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
        END IF;
        
        -- Draw the dash line
        IF(X > DASH_LEFT AND X < DASH_RIGHT)THEN
                FOR TEMP IN 0 TO 28 LOOP
                        IF(Y>TEMP*20 AND Y<TEMP*20+9)THEN
                                red <= (OTHERS => '1');
                                green <= (OTHERS => '1');
                                blue <= (OTHERS => '1');
                        END IF;
                END LOOP;
        END IF;
        
        -- Draw the left paddle
        IF(X>=0 AND X < PADDLE_WID AND Y>=BOUND_THICK + Y_PADDLE_LEFT AND Y <= BOUND_THICK  + Y_PADDLE_LEFT + PADDLE_LEN)THEN
                red <= (OTHERS => '1');
                green <= (OTHERS => '1');
                blue <= (OTHERS => '1');
        END IF;
        
        -- Draw the right paddle
                IF(X>pixels_x - PADDLE_WID AND X <= pixels_x AND Y>=BOUND_THICK + Y_PADDLE_RIGHT AND Y <= BOUND_THICK  + Y_PADDLE_RIGHT + PADDLE_LEN)THEN
                        red <= (OTHERS => '1');
                        green <= (OTHERS => '1');
                        blue <= (OTHERS => '1');
                END IF;
        
        ELSE
                 red <= (OTHERS => '0');
                 green <= (OTHERS => '0');
                 blue <= (OTHERS => '0');
                
        END IF;
          
    END IF;  
    
  END PROCESS;
  
END Behavioral;
