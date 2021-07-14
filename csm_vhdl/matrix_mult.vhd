library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.utils_pkg.all;

entity matrix_mult is
    generic (
    WIDTH: integer := 8;
    SIZE: integer := 3
    );
    port (
    --------------- Clocking and reset interface ---------------
    clk: in std_logic;
    reset: in std_logic;
    ------------------- Input data interface -------------------
    
    -- Matrix A memory interface
    a_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    a_data_i: in std_logic_vector(WIDTH-1 downto 0);
    a_wr_o: out std_logic;
    
    -- Matrix B memory interface
    b_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    b_data_i: in std_logic_vector(WIDTH-1 downto 0);
    b_wr_o: out std_logic;
    
    -- Matrix dimensions definition interface
    n_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
    p_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
    m_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
    
    ------------------- Output data interface ------------------
    -- Matrix C memory interface
    c_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    c_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
    c_wr_o: out std_logic;
    
    --------------------- Command interface --------------------
    start: in std_logic;
    --------------------- Status interface ---------------------
    ready: out std_logic);
end entity;

architecture two_seg_arch of matrix_mult is
    attribute use_dsp : string;
    attribute use_dsp of two_seg_arch : architecture is "yes";
    
    type state_type is (idle, l1, l2, l3, l4, l5, l6,l7);
    signal state_reg, state_next: state_type;
    
    signal i_reg, i_next: unsigned(log2c(SIZE)-1 downto 0);
    signal j_reg, j_next: unsigned(log2c(SIZE)-1 downto 0);
    signal k_reg, k_next: unsigned(log2c(SIZE)-1 downto 0);
    signal temp_reg, temp_next: signed(2*WIDTH+SIZE-1 downto 0);
begin
    
    -- State and data registers
    process (clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
            i_reg <= (others => '0');
            j_reg <= (others => '0');
            k_reg <= (others => '0');
            temp_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
            i_reg <= i_next;
            j_reg <= j_next;
            k_reg <= k_next;
            temp_reg <= temp_next;
        end if;
    end process;
    
    -- Combinatorial circuits
    process (state_reg, start, a_data_i, b_data_i, i_reg, j_reg, k_reg, temp_reg, i_next, j_next, k_next,temp_next)
    begin
    -- Default assignments
    i_next <= i_reg;
    j_next <= j_reg;
    k_next <= k_reg;
    temp_next <= temp_reg;
    a_addr_o <= (others => '0');
    a_wr_o <= '0';
    b_addr_o <= (others => '0');
    b_wr_o <= '0';
    c_addr_o <= (others => '0');
    c_data_o <= (others => '0');
    c_wr_o <= '0';
    ready <= '0';
           
    case state_reg is
        when idle =>
            ready <= '1'; 
            if start = '1' then
                i_next <= to_unsigned(0, log2c(SIZE));
                state_next <= l1;  
            else
                state_next <= idle;
            end if;
  
        when l1 =>
            j_next <= to_unsigned(0, log2c(SIZE));
            state_next <= l2;
  
        when l2 =>
            temp_next <= to_signed(0, 2*WIDTH+SIZE);
            k_next <= to_unsigned(0, log2c(SIZE));
            state_next <= l7;
        when l7 =>
            --a_addr_o <= std_logic_vector(i_reg*unsigned(n_in)+k_reg);
            a_addr_o <= std_logic_vector(i_reg*unsigned(m_in)+k_reg);
            --b_addr_o <= std_logic_vector(k_reg*unsigned(m_in)+j_reg);
            b_addr_o <= std_logic_vector(k_reg*unsigned(p_in)+j_reg);
            
            state_next <= l3;
            
        when l3 =>
            temp_next <= temp_reg + signed(a_data_i)*signed(b_data_i);
            k_next <= k_reg + 1;
            
            state_next <= l4;
            
        when l4 =>
            if (k_reg = unsigned(m_in)) then
                --c_addr_o <= std_logic_vector(i_reg*unsigned(n_in)+j_reg);
                c_addr_o <= std_logic_vector(i_reg*unsigned(p_in)+j_reg);
                c_data_o <= std_logic_vector(temp_reg);
                c_wr_o <= '1';
                j_next <= j_reg + 1;
                state_next <= l5;
            else
                --a_addr_o <= std_logic_vector(i_reg*unsigned(n_in)+k_reg);
                a_addr_o <= std_logic_vector(i_reg*unsigned(m_in)+k_reg);
                --b_addr_o <= std_logic_vector(k_reg*unsigned(m_in)+j_reg);
                b_addr_o <= std_logic_vector(k_reg*unsigned(p_in)+j_reg);
                state_next <= l3;
            end if;
            
        when l5 =>   
            if (j_reg = unsigned(p_in)) then
                i_next <= i_reg + 1;
                state_next <= l6;
            else
                state_next <= l2;
            end if;
            
        when l6 =>
            if (i_reg = unsigned(n_in)) then
                state_next <= idle;
            else
                state_next <= l1;
            end if;    
        end case;
    end process;
end two_seg_arch;