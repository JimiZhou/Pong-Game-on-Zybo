# Pong Game on Xilinx Zybo
### Block Diagram
![Block Diagram](https://github.com/JimiZhou/Pong-Game-on-Zybo/blob/master/Block-Diagram.jpg)

### Introduction
This is a VHDL project using: 
- [Zynq Zybo 7000](https://store.digilentinc.com/zybo-zynq-7000-arm-fpga-soc-trainer-board/) 
- Xilinx Vivado 2018.2
- Xilinx SDK 2018.2

### Features
- 800x600@60Hz VGA Display. VGA controller referenced from [Digi-Key](https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278#VGAController(VHDL)-Contact)
 - AXI register map created using [airhdl](https://airhdl.com/app/registerMaps.jsp).
 -  Characters saved in ROM in vectors(8*8 pixels format).
 ```
 constant FONT: rom :=
(
x"00",x"18",x"24",x"24",x"3C",x"24",x"24",x"00",      ---- Character A
x"00",x"38",x"24",x"38",x"24",x"24",x"38",x"00",      ---- Character B
x"00",x"18",x"24",x"20",x"20",x"24",x"18",x"00",      ---- Character C
x"00",x"38",x"24",x"24",x"24",x"24",x"38",x"00",      ---- Character D
......
);
 ```
 - 8*8 pixels ball stored in ROM:
 ```
 -- 16 X 16 pixel ball
constant BALL: rom_ball :=
(
"0000011111100000", --      ******     
"0001110101011000", --    *** * * **   
"0010000010101100", --   *    * * **  
"0110000000010110", --  **       * ** 
"0100000001010110", --  *       * * ** 
"1000000000010011", -- *          *  **
"1000000000101111", -- *          * ****
"1000000000010101", -- *           * * *
"1000000001010011", -- *         * *  **
"1010100001010111", -- * * *    * * ***
"1010101010111011", -- * * * * * *** **
"0101010101001010", --  * * * * *  * * 
"0100000001010110", --  *       * * **  
"0011101101011100", --  *** ** * ***
"0001111011111000", --   **** *****   
"0000011111100000" --      ******   
);
 ```
 - Two players: *Left* and *Right*. Controlled by GPIO buttons.
- Score board available. When one of the player gots 10 scores, the game ends.

### Demo
![Demo](https://github.com/JimiZhou/Pong-Game-on-Zybo/blob/master/pong-game-test.gif)

### Notes
This is my first time writing VHDL and develop software-controlled design in Xilinx SDK. The code in VGA image source is not well organized, especially if user wants to add certain character in the game, it needs to be re-written and generate the bitstream again for SDK to work, and also the register map should be updated.

### License

- MIT
