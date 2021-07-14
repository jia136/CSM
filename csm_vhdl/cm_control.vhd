library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cm_control is
    Port ( clk        : in STD_LOGIC;
           reset      : in STD_LOGIC;
           mm_rdy     : in STD_LOGIC;
           start      : in STD_LOGIC;
           mm_start_o : out STD_LOGIC;
           ready      : out STD_LOGIC;
           sel_o      : out STD_LOGIC_VECTOR (2 downto 0));
end cm_control;

architecture Behavioral of cm_control is
    type state_type is (idle, l1, l0);--, l0, l2);
    signal state_reg, state_next: state_type;
    signal sel_reg, sel_next: unsigned(2 downto 0);
    signal start_reg, start_next: std_logic;--razmisli!!
begin
    process (clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
            sel_reg <= "111";
            start_reg <= '0';
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
            sel_reg <= sel_next;
            start_reg <= start_next;
        end if;
    end process;

    process (state_reg, mm_rdy, start, sel_reg, sel_next, start_reg, start_next)
    begin
        sel_next <= sel_reg;
        start_next <= start_reg;
        ready <= '0';
        case state_reg is
            when idle =>
                start_next <= '0';
                ready <= '1'; 
                if start = '1' then
                    start_next <= '1';
                    sel_next <= to_unsigned(0, sel_next'length);
                    state_next <= l0;
                else
                    state_next <= idle;
                end if;
            when l0 =>
                start_next <= '0';
                state_next <= l1;
            when l1 =>
                start_next <= '0';
                if mm_rdy = '1' then
                    start_next <= '1';
                    sel_next <= sel_reg + 1;
                    state_next <= l0;
                --else
                    --state_next <= l1;
                end if;
                if(sel_next = 6)then
                    state_next <= idle;
                --else
                    --state_next <= l1;
                end if;
            --when l2 =>
                --mm_start_o <= '0';
                --if(sel_reg = 6)then
                    --state_next <= idle;
                --else
                    --state_next <= l1;
                --end if;
        end case;
    end process;
    sel_o <= std_logic_vector(sel_reg);
    mm_start_o <= start_reg;
end Behavioral;
