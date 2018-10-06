-- -----------------------------------------------------------------------------
-- 'pong_vga' Register Definitions
-- Revision: 12
-- -----------------------------------------------------------------------------
-- Generated on 2018-10-05 at 16:14 (UTC) by airhdl version 2018.07.2
-- -----------------------------------------------------------------------------
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
-- POSSIBILITY OF SUCH DAMAGE.
-- -----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pong_vga_regs_pkg is

    -- Type definitions
    type slv1_array_t is array(natural range <>) of std_logic_vector(0 downto 0);
    type slv2_array_t is array(natural range <>) of std_logic_vector(1 downto 0);
    type slv3_array_t is array(natural range <>) of std_logic_vector(2 downto 0);
    type slv4_array_t is array(natural range <>) of std_logic_vector(3 downto 0);
    type slv5_array_t is array(natural range <>) of std_logic_vector(4 downto 0);
    type slv6_array_t is array(natural range <>) of std_logic_vector(5 downto 0);
    type slv7_array_t is array(natural range <>) of std_logic_vector(6 downto 0);
    type slv8_array_t is array(natural range <>) of std_logic_vector(7 downto 0);
    type slv9_array_t is array(natural range <>) of std_logic_vector(8 downto 0);
    type slv10_array_t is array(natural range <>) of std_logic_vector(9 downto 0);
    type slv11_array_t is array(natural range <>) of std_logic_vector(10 downto 0);
    type slv12_array_t is array(natural range <>) of std_logic_vector(11 downto 0);
    type slv13_array_t is array(natural range <>) of std_logic_vector(12 downto 0);
    type slv14_array_t is array(natural range <>) of std_logic_vector(13 downto 0);
    type slv15_array_t is array(natural range <>) of std_logic_vector(14 downto 0);
    type slv16_array_t is array(natural range <>) of std_logic_vector(15 downto 0);
    type slv17_array_t is array(natural range <>) of std_logic_vector(16 downto 0);
    type slv18_array_t is array(natural range <>) of std_logic_vector(17 downto 0);
    type slv19_array_t is array(natural range <>) of std_logic_vector(18 downto 0);
    type slv20_array_t is array(natural range <>) of std_logic_vector(19 downto 0);
    type slv21_array_t is array(natural range <>) of std_logic_vector(20 downto 0);
    type slv22_array_t is array(natural range <>) of std_logic_vector(21 downto 0);
    type slv23_array_t is array(natural range <>) of std_logic_vector(22 downto 0);
    type slv24_array_t is array(natural range <>) of std_logic_vector(23 downto 0);
    type slv25_array_t is array(natural range <>) of std_logic_vector(24 downto 0);
    type slv26_array_t is array(natural range <>) of std_logic_vector(25 downto 0);
    type slv27_array_t is array(natural range <>) of std_logic_vector(26 downto 0);
    type slv28_array_t is array(natural range <>) of std_logic_vector(27 downto 0);
    type slv29_array_t is array(natural range <>) of std_logic_vector(28 downto 0);
    type slv30_array_t is array(natural range <>) of std_logic_vector(29 downto 0);
    type slv31_array_t is array(natural range <>) of std_logic_vector(30 downto 0);
    type slv32_array_t is array(natural range <>) of std_logic_vector(31 downto 0);


    -- Revision number of the 'pong_vga' register map
    constant PONG_VGA_REVISION : natural := 12;

    -- Default base address of the 'pong_vga' register map 
    constant PONG_VGA_DEFAULT_BASEADDR : unsigned(31 downto 0) := unsigned'(x"40000000");
    
    -- Register 'POS_BALL'
    constant POS_BALL_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000000"); -- address offset of the 'POS_BALL' register
    constant POS_BALL_X_BALL_BIT_OFFSET : natural := 0; -- bit offset of the 'X_BALL' field
    constant POS_BALL_X_BALL_BIT_WIDTH : natural := 16; -- bit width of the 'X_BALL' field
    constant POS_BALL_X_BALL_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'X_BALL' field
    constant POS_BALL_Y_BALL_BIT_OFFSET : natural := 16; -- bit offset of the 'Y_BALL' field
    constant POS_BALL_Y_BALL_BIT_WIDTH : natural := 16; -- bit width of the 'Y_BALL' field
    constant POS_BALL_Y_BALL_RESET : std_logic_vector(31 downto 16) := std_logic_vector'("0000000000000000"); -- reset value of the 'Y_BALL' field
    
    -- Register 'Y_PADDLE'
    constant Y_PADDLE_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000004"); -- address offset of the 'Y_PADDLE' register
    constant Y_PADDLE_Y_PADDLE_LEFT_BIT_OFFSET : natural := 0; -- bit offset of the 'Y_PADDLE_LEFT' field
    constant Y_PADDLE_Y_PADDLE_LEFT_BIT_WIDTH : natural := 16; -- bit width of the 'Y_PADDLE_LEFT' field
    constant Y_PADDLE_Y_PADDLE_LEFT_RESET : std_logic_vector(15 downto 0) := std_logic_vector'("0000000000000000"); -- reset value of the 'Y_PADDLE_LEFT' field
    constant Y_PADDLE_Y_PADDLE_RIGHT_BIT_OFFSET : natural := 16; -- bit offset of the 'Y_PADDLE_RIGHT' field
    constant Y_PADDLE_Y_PADDLE_RIGHT_BIT_WIDTH : natural := 16; -- bit width of the 'Y_PADDLE_RIGHT' field
    constant Y_PADDLE_Y_PADDLE_RIGHT_RESET : std_logic_vector(31 downto 16) := std_logic_vector'("0000000000000000"); -- reset value of the 'Y_PADDLE_RIGHT' field
    
    -- Register 'sync'
    constant SYNC_OFFSET : unsigned(31 downto 0) := unsigned'(x"00000008"); -- address offset of the 'sync' register
    constant SYNC_SYNC_BIT_OFFSET : natural := 0; -- bit offset of the 'sync' field
    constant SYNC_SYNC_BIT_WIDTH : natural := 1; -- bit width of the 'sync' field
    constant SYNC_SYNC_RESET : std_logic_vector(0 downto 0) := std_logic_vector'("0"); -- reset value of the 'sync' field

end pong_vga_regs_pkg;
