-- -----------------------------------------------------------------------------
-- 'pong_vga' Register Component
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

use work.pong_vga_regs_pkg.all;

entity pong_vga_regs is
    generic(
        AXI_ADDR_WIDTH : integer := 32;  -- width of the AXI address bus
        BASEADDR : std_logic_vector(31 downto 0) := x"40000000" -- the register file's system base address		
    );
    port(
        -- Clock and Reset
        axi_aclk    : in  std_logic;
        axi_aresetn : in  std_logic;
        -- AXI Write Address Channel
        s_axi_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_awprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        -- AXI Write Data Channel
        s_axi_wdata   : in  std_logic_vector(31 downto 0);
        s_axi_wstrb   : in  std_logic_vector(3 downto 0);
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        -- AXI Read Address Channel
        s_axi_araddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
        s_axi_arprot  : in  std_logic_vector(2 downto 0); -- sigasi @suppress "Unused port"
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        -- AXI Read Data Channel
        s_axi_rdata   : out std_logic_vector(31 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        -- AXI Write Response Channel
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        -- User Ports
        pos_ball_strobe : out std_logic; -- Strobe signal for register 'POS_BALL' (pulsed when the register is written from the bus)
        pos_ball_x_ball : out std_logic_vector(15 downto 0); -- Value of register 'POS_BALL', field 'X_BALL'
        pos_ball_y_ball : out std_logic_vector(15 downto 0); -- Value of register 'POS_BALL', field 'Y_BALL'
        y_paddle_strobe : out std_logic; -- Strobe signal for register 'Y_PADDLE' (pulsed when the register is written from the bus)
        y_paddle_y_paddle_left : out std_logic_vector(15 downto 0); -- Value of register 'Y_PADDLE', field 'Y_PADDLE_LEFT'
        y_paddle_y_paddle_right : out std_logic_vector(15 downto 0); -- Value of register 'Y_PADDLE', field 'Y_PADDLE_RIGHT'
        sync_strobe : out std_logic; -- Strobe signal for register 'sync' (pulsed when the register is read from the bus)
        sync_sync : in std_logic_vector(0 downto 0) -- Value of register 'sync', field 'sync'
    );
end entity pong_vga_regs;

architecture RTL of pong_vga_regs is

    -- Constants
    constant AXI_OKAY           : std_logic_vector(1 downto 0) := "00";
    constant AXI_DECERR         : std_logic_vector(1 downto 0) := "11";

    -- Registered signals
    signal s_axi_awready_r    : std_logic;
    signal s_axi_wready_r     : std_logic;
    signal s_axi_awaddr_reg_r : unsigned(s_axi_awaddr'range);
    signal s_axi_bvalid_r     : std_logic;
    signal s_axi_bresp_r      : std_logic_vector(s_axi_bresp'range);
    signal s_axi_arready_r    : std_logic;
    signal s_axi_araddr_reg_r : unsigned(s_axi_araddr'range);
    signal s_axi_rvalid_r     : std_logic;
    signal s_axi_rresp_r      : std_logic_vector(s_axi_rresp'range);
    signal s_axi_wdata_reg_r  : std_logic_vector(s_axi_wdata'range);
    signal s_axi_wstrb_reg_r  : std_logic_vector(s_axi_wstrb'range);
    signal s_axi_rdata_r      : std_logic_vector(s_axi_rdata'range);
    
    -- User-defined registers
    signal s_pos_ball_strobe_r : std_logic;
    signal s_reg_pos_ball_x_ball_r : std_logic_vector(15 downto 0);
    signal s_reg_pos_ball_y_ball_r : std_logic_vector(15 downto 0);
    signal s_y_paddle_strobe_r : std_logic;
    signal s_reg_y_paddle_y_paddle_left_r : std_logic_vector(15 downto 0);
    signal s_reg_y_paddle_y_paddle_right_r : std_logic_vector(15 downto 0);
    signal s_sync_strobe_r : std_logic;
    signal s_reg_sync_sync : std_logic_vector(0 downto 0);

begin

    ----------------------------------------------------------------------------
    -- Inputs
    --
    s_reg_sync_sync <= sync_sync;

    ----------------------------------------------------------------------------
    -- Read-transaction FSM
    --    
    read_fsm : process(axi_aclk, axi_aresetn) is
        constant MEM_WAIT_COUNT : natural := 2;
        type t_state is (IDLE, READ_REGISTER, WAIT_MEMORY_RDATA, READ_RESPONSE, DONE);
        -- registered state variables
        variable v_state_r          : t_state;
        variable v_rdata_r          : std_logic_vector(31 downto 0);
        variable v_rresp_r          : std_logic_vector(s_axi_rresp'range);
        variable v_mem_wait_count_r : natural range 0 to MEM_WAIT_COUNT - 1;
        -- combinatorial helper variables
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            v_rdata_r          := (others => '0');
            v_rresp_r          := (others => '0');
            v_mem_wait_count_r := 0;
            s_axi_arready_r    <= '0';
            s_axi_rvalid_r     <= '0';
            s_axi_rresp_r      <= (others => '0');
            s_axi_araddr_reg_r <= (others => '0');
            s_axi_rdata_r      <= (others => '0');
            s_sync_strobe_r <= '0';
 
        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_arready_r <= '0';
            s_sync_strobe_r <= '0';

            case v_state_r is

                -- Wait for the start of a read transaction, which is 
                -- initiated by the assertion of ARVALID
                when IDLE =>
                    v_mem_wait_count_r := 0;
                    --
                    if s_axi_arvalid = '1' then
                        s_axi_araddr_reg_r <= unsigned(s_axi_araddr); -- save the read address
                        s_axi_arready_r    <= '1'; -- acknowledge the read-address
                        v_state_r          := READ_REGISTER;
                    end if;

                -- Read from the actual storage element
                when READ_REGISTER =>
                    -- defaults:
                    v_addr_hit := false;
                    v_rdata_r  := (others => '0');
                    
                    -- register 'POS_BALL' at address offset 0x0 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + POS_BALL_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_pos_ball_x_ball_r;
                        v_rdata_r(31 downto 16) := s_reg_pos_ball_y_ball_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'Y_PADDLE' at address offset 0x4 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + Y_PADDLE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(15 downto 0) := s_reg_y_paddle_y_paddle_left_r;
                        v_rdata_r(31 downto 16) := s_reg_y_paddle_y_paddle_right_r;
                        v_state_r := READ_RESPONSE;
                    end if;
                    -- register 'sync' at address offset 0x8 
                    if s_axi_araddr_reg_r = resize(unsigned(BASEADDR) + SYNC_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;
                        v_rdata_r(0 downto 0) := s_reg_sync_sync;
                        s_sync_strobe_r <= '1';
                        v_state_r := READ_RESPONSE;
                    end if;
                    --
                    if v_addr_hit then
                        v_rresp_r := AXI_OKAY;
                    else
                        v_rresp_r := AXI_DECERR;
                        -- pragma translate_off
                        report "ARADDR decode error" severity warning;
                        -- pragma translate_on
                        v_state_r := READ_RESPONSE;
                    end if;

                -- Wait for memory read data
                when WAIT_MEMORY_RDATA =>
                    if v_mem_wait_count_r = MEM_WAIT_COUNT-1 then
                        v_state_r      := READ_RESPONSE;
                    else
                        v_mem_wait_count_r := v_mem_wait_count_r + 1;
                    end if;

                -- Generate read response
                when READ_RESPONSE =>
                    s_axi_rvalid_r <= '1';
                    s_axi_rresp_r  <= v_rresp_r;
                    s_axi_rdata_r  <= v_rdata_r;
                    --
                    v_state_r      := DONE;

                -- Write transaction completed, wait for master RREADY to proceed
                when DONE =>
                    if s_axi_rready = '1' then
                        s_axi_rvalid_r <= '0';
                        s_axi_rdata_r   <= (others => '0');
                        v_state_r      := IDLE;
                    end if;
            end case;
        end if;
    end process read_fsm;

    ----------------------------------------------------------------------------
    -- Write-transaction FSM
    --    
    write_fsm : process(axi_aclk, axi_aresetn) is
        type t_state is (IDLE, ADDR_FIRST, DATA_FIRST, UPDATE_REGISTER, DONE);
        variable v_state_r  : t_state;
        variable v_addr_hit : boolean;
        variable v_mem_addr : unsigned(AXI_ADDR_WIDTH-1 downto 0);
    begin
        if axi_aresetn = '0' then
            v_state_r          := IDLE;
            s_axi_awready_r    <= '0';
            s_axi_wready_r     <= '0';
            s_axi_awaddr_reg_r <= (others => '0');
            s_axi_wdata_reg_r  <= (others => '0');
            s_axi_wstrb_reg_r  <= (others => '0');
            s_axi_bvalid_r     <= '0';
            s_axi_bresp_r      <= (others => '0');
            --            
            s_pos_ball_strobe_r <= '0';
            s_reg_pos_ball_x_ball_r <= std_logic_vector'("0000000000000000");
            s_reg_pos_ball_y_ball_r <= std_logic_vector'("0000000000000000");
            s_y_paddle_strobe_r <= '0';
            s_reg_y_paddle_y_paddle_left_r <= std_logic_vector'("0000000000000000");
            s_reg_y_paddle_y_paddle_right_r <= std_logic_vector'("0000000000000000");

        elsif rising_edge(axi_aclk) then
            -- Default values:
            s_axi_awready_r <= '0';
            s_axi_wready_r  <= '0';
            s_pos_ball_strobe_r <= '0';
            s_y_paddle_strobe_r <= '0';

            case v_state_r is

                -- Wait for the start of a write transaction, which may be 
                -- initiated by either of the following conditions:
                --   * assertion of both AWVALID and WVALID
                --   * assertion of AWVALID
                --   * assertion of WVALID
                when IDLE =>
                    if s_axi_awvalid = '1' and s_axi_wvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        s_axi_wdata_reg_r  <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r  <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r     <= '1'; -- acknowledge the write-data
                        v_state_r          := UPDATE_REGISTER;
                    elsif s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := ADDR_FIRST;
                    elsif s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := DATA_FIRST;
                    end if;

                -- Address-first write transaction: wait for the write-data
                when ADDR_FIRST =>
                    if s_axi_wvalid = '1' then
                        s_axi_wdata_reg_r <= s_axi_wdata; -- save the write-data
                        s_axi_wstrb_reg_r <= s_axi_wstrb; -- save the write-strobe
                        s_axi_wready_r    <= '1'; -- acknowledge the write-data
                        v_state_r         := UPDATE_REGISTER;
                    end if;

                -- Data-first write transaction: wait for the write-address
                when DATA_FIRST =>
                    if s_axi_awvalid = '1' then
                        s_axi_awaddr_reg_r <= unsigned(s_axi_awaddr); -- save the write-address 
                        s_axi_awready_r    <= '1'; -- acknowledge the write-address
                        v_state_r          := UPDATE_REGISTER;
                    end if;

                -- Update the actual storage element
                when UPDATE_REGISTER =>
                    s_axi_bresp_r               <= AXI_OKAY; -- default value, may be overriden in case of decode error
                    s_axi_bvalid_r              <= '1';
                    --
                    v_addr_hit := false;
                    -- register 'POS_BALL' at address offset 0x0
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + POS_BALL_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_pos_ball_strobe_r <= '1';
                        -- field 'X_BALL':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(0) <= s_axi_wdata_reg_r(0); -- X_BALL(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(1) <= s_axi_wdata_reg_r(1); -- X_BALL(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(2) <= s_axi_wdata_reg_r(2); -- X_BALL(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(3) <= s_axi_wdata_reg_r(3); -- X_BALL(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(4) <= s_axi_wdata_reg_r(4); -- X_BALL(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(5) <= s_axi_wdata_reg_r(5); -- X_BALL(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(6) <= s_axi_wdata_reg_r(6); -- X_BALL(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_pos_ball_x_ball_r(7) <= s_axi_wdata_reg_r(7); -- X_BALL(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(8) <= s_axi_wdata_reg_r(8); -- X_BALL(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(9) <= s_axi_wdata_reg_r(9); -- X_BALL(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(10) <= s_axi_wdata_reg_r(10); -- X_BALL(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(11) <= s_axi_wdata_reg_r(11); -- X_BALL(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(12) <= s_axi_wdata_reg_r(12); -- X_BALL(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(13) <= s_axi_wdata_reg_r(13); -- X_BALL(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(14) <= s_axi_wdata_reg_r(14); -- X_BALL(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_pos_ball_x_ball_r(15) <= s_axi_wdata_reg_r(15); -- X_BALL(15)
                        end if;
                        -- field 'Y_BALL':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(0) <= s_axi_wdata_reg_r(16); -- Y_BALL(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(1) <= s_axi_wdata_reg_r(17); -- Y_BALL(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(2) <= s_axi_wdata_reg_r(18); -- Y_BALL(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(3) <= s_axi_wdata_reg_r(19); -- Y_BALL(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(4) <= s_axi_wdata_reg_r(20); -- Y_BALL(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(5) <= s_axi_wdata_reg_r(21); -- Y_BALL(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(6) <= s_axi_wdata_reg_r(22); -- Y_BALL(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_pos_ball_y_ball_r(7) <= s_axi_wdata_reg_r(23); -- Y_BALL(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(8) <= s_axi_wdata_reg_r(24); -- Y_BALL(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(9) <= s_axi_wdata_reg_r(25); -- Y_BALL(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(10) <= s_axi_wdata_reg_r(26); -- Y_BALL(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(11) <= s_axi_wdata_reg_r(27); -- Y_BALL(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(12) <= s_axi_wdata_reg_r(28); -- Y_BALL(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(13) <= s_axi_wdata_reg_r(29); -- Y_BALL(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(14) <= s_axi_wdata_reg_r(30); -- Y_BALL(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_pos_ball_y_ball_r(15) <= s_axi_wdata_reg_r(31); -- Y_BALL(15)
                        end if;
                    end if;
                    -- register 'Y_PADDLE' at address offset 0x4
                    if s_axi_awaddr_reg_r = resize(unsigned(BASEADDR) + Y_PADDLE_OFFSET, AXI_ADDR_WIDTH) then
                        v_addr_hit := true;                        
                        s_y_paddle_strobe_r <= '1';
                        -- field 'Y_PADDLE_LEFT':
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(0) <= s_axi_wdata_reg_r(0); -- Y_PADDLE_LEFT(0)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(1) <= s_axi_wdata_reg_r(1); -- Y_PADDLE_LEFT(1)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(2) <= s_axi_wdata_reg_r(2); -- Y_PADDLE_LEFT(2)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(3) <= s_axi_wdata_reg_r(3); -- Y_PADDLE_LEFT(3)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(4) <= s_axi_wdata_reg_r(4); -- Y_PADDLE_LEFT(4)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(5) <= s_axi_wdata_reg_r(5); -- Y_PADDLE_LEFT(5)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(6) <= s_axi_wdata_reg_r(6); -- Y_PADDLE_LEFT(6)
                        end if;
                        if s_axi_wstrb_reg_r(0) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(7) <= s_axi_wdata_reg_r(7); -- Y_PADDLE_LEFT(7)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(8) <= s_axi_wdata_reg_r(8); -- Y_PADDLE_LEFT(8)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(9) <= s_axi_wdata_reg_r(9); -- Y_PADDLE_LEFT(9)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(10) <= s_axi_wdata_reg_r(10); -- Y_PADDLE_LEFT(10)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(11) <= s_axi_wdata_reg_r(11); -- Y_PADDLE_LEFT(11)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(12) <= s_axi_wdata_reg_r(12); -- Y_PADDLE_LEFT(12)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(13) <= s_axi_wdata_reg_r(13); -- Y_PADDLE_LEFT(13)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(14) <= s_axi_wdata_reg_r(14); -- Y_PADDLE_LEFT(14)
                        end if;
                        if s_axi_wstrb_reg_r(1) = '1' then
                            s_reg_y_paddle_y_paddle_left_r(15) <= s_axi_wdata_reg_r(15); -- Y_PADDLE_LEFT(15)
                        end if;
                        -- field 'Y_PADDLE_RIGHT':
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(0) <= s_axi_wdata_reg_r(16); -- Y_PADDLE_RIGHT(0)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(1) <= s_axi_wdata_reg_r(17); -- Y_PADDLE_RIGHT(1)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(2) <= s_axi_wdata_reg_r(18); -- Y_PADDLE_RIGHT(2)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(3) <= s_axi_wdata_reg_r(19); -- Y_PADDLE_RIGHT(3)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(4) <= s_axi_wdata_reg_r(20); -- Y_PADDLE_RIGHT(4)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(5) <= s_axi_wdata_reg_r(21); -- Y_PADDLE_RIGHT(5)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(6) <= s_axi_wdata_reg_r(22); -- Y_PADDLE_RIGHT(6)
                        end if;
                        if s_axi_wstrb_reg_r(2) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(7) <= s_axi_wdata_reg_r(23); -- Y_PADDLE_RIGHT(7)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(8) <= s_axi_wdata_reg_r(24); -- Y_PADDLE_RIGHT(8)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(9) <= s_axi_wdata_reg_r(25); -- Y_PADDLE_RIGHT(9)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(10) <= s_axi_wdata_reg_r(26); -- Y_PADDLE_RIGHT(10)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(11) <= s_axi_wdata_reg_r(27); -- Y_PADDLE_RIGHT(11)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(12) <= s_axi_wdata_reg_r(28); -- Y_PADDLE_RIGHT(12)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(13) <= s_axi_wdata_reg_r(29); -- Y_PADDLE_RIGHT(13)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(14) <= s_axi_wdata_reg_r(30); -- Y_PADDLE_RIGHT(14)
                        end if;
                        if s_axi_wstrb_reg_r(3) = '1' then
                            s_reg_y_paddle_y_paddle_right_r(15) <= s_axi_wdata_reg_r(31); -- Y_PADDLE_RIGHT(15)
                        end if;
                    end if;
                    --
                    if not v_addr_hit then
                        s_axi_bresp_r <= AXI_DECERR;
                        -- pragma translate_off
                        report "AWADDR decode error" severity warning;
                        -- pragma translate_on
                    end if;
                    --
                    v_state_r := DONE;

                -- Write transaction completed, wait for master BREADY to proceed
                when DONE =>
                    if s_axi_bready = '1' then
                        s_axi_bvalid_r <= '0';
                        v_state_r      := IDLE;
                    end if;

            end case;


        end if;
    end process write_fsm;

    ----------------------------------------------------------------------------
    -- Outputs
    --
    s_axi_awready <= s_axi_awready_r;
    s_axi_wready  <= s_axi_wready_r;
    s_axi_bvalid  <= s_axi_bvalid_r;
    s_axi_bresp   <= s_axi_bresp_r;
    s_axi_arready <= s_axi_arready_r;
    s_axi_rvalid  <= s_axi_rvalid_r;
    s_axi_rresp   <= s_axi_rresp_r;
    s_axi_rdata   <= s_axi_rdata_r;

    pos_ball_strobe <= s_pos_ball_strobe_r;
    pos_ball_x_ball <= s_reg_pos_ball_x_ball_r;
    pos_ball_y_ball <= s_reg_pos_ball_y_ball_r;
    y_paddle_strobe <= s_y_paddle_strobe_r;
    y_paddle_y_paddle_left <= s_reg_y_paddle_y_paddle_left_r;
    y_paddle_y_paddle_right <= s_reg_y_paddle_y_paddle_right_r;
    sync_strobe <= s_sync_strobe_r;

end architecture RTL;
