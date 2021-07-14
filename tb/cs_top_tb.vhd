library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.utils_pkg.all;
entity matrix_mult_tb is
end entity;
architecture beh of matrix_mult_tb is
    constant DATA_WIDTH_c: integer := 18;
    constant SIZE_c: integer := 6;
    constant N_c: integer := 2;
    constant M_c: integer := 2;
    constant P_c: integer := 3;
    
    type mem_t is array (0 to 3 ) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_t1 is array(0 to 5 ) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_t2 is array(0 to 5 ) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_t3 is array(0 to 11) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_t4 is array(0 to 2 ) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    type mem_t5 is array(0 to 3 ) of std_logic_vector(DATA_WIDTH_c-1 downto 0);
    
    constant MEM_A_CONTENT_c: mem_t :=(conv_std_logic_vector(4, DATA_WIDTH_c),
                                       conv_std_logic_vector(2, DATA_WIDTH_c),
                                       conv_std_logic_vector(5, DATA_WIDTH_c),
                                       conv_std_logic_vector(6, DATA_WIDTH_c));
                                       
    constant MEM_B_CONTENT_c: mem_t1 := (conv_std_logic_vector(4, DATA_WIDTH_c),
                                        conv_std_logic_vector(5, DATA_WIDTH_c),
                                        conv_std_logic_vector(4, DATA_WIDTH_c),
                                        conv_std_logic_vector(8, DATA_WIDTH_c),
                                        conv_std_logic_vector(9, DATA_WIDTH_c),
                                        conv_std_logic_vector(9, DATA_WIDTH_c));
                                        
    constant MEM_RG_CONTENT_c: mem_t2 := (conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c));
                                                                              
                                        
    constant MEM_CG_CONTENT_c: mem_t3 := (conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(0, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c));
                                        
    constant MEM_CC_CONTENT_c: mem_t4 := (conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(-1, DATA_WIDTH_c));
                                        
    constant MEM_CR_CONTENT_c: mem_t5 := (conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(1, DATA_WIDTH_c),
                                        conv_std_logic_vector(-1, DATA_WIDTH_c));
                                         
    signal clk_s: std_logic;
    signal reset_s: std_logic;
    signal n_in_s: std_logic_vector(log2c(SIZE_c)-1 downto 0);
    signal m_in_s: std_logic_vector(log2c(SIZE_c)-1 downto 0);
    signal p_in_s: std_logic_vector(log2c(SIZE_c)-1 downto 0);
    
    -- Matrix A memory interface
    signal mem_a_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_a_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_a_wr_s: std_logic;
    signal a_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal a_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal a_wr_s: std_logic;
    
    -- Matrix B memory interface
    signal mem_b_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_b_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_b_wr_s: std_logic;
    signal b_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal b_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal b_wr_s: std_logic;
    
    signal mem_rg_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_rg_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_rg_wr_s: std_logic;
    signal rg_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal rg_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal rg_wr_s: std_logic;
    
    signal mem_cg_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_cg_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_cg_wr_s: std_logic;
    signal cg_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal cg_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal cg_wr_s: std_logic;
    
    signal mem_biga_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_biga_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal mem_biga_wr_s: std_logic;
    signal biga_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal biga_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal biga_data_out_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal biga_wr_s: std_logic;
    
    signal mem_bigb_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_bigb_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal mem_bigb_wr_s: std_logic;
    signal bigb_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal bigb_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal bigb_data_out_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal bigb_wr_s: std_logic;
    
    signal mem_cc_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_cc_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_cc_wr_s: std_logic;
    signal cc_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal cc_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal cc_wr_s: std_logic;
    
    signal mem_cr_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_cr_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_cr_wr_s: std_logic;
    signal cr_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal cr_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal cr_wr_s: std_logic;
    
    signal mem_cctmp_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_cctmp_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal mem_cctmp_wr_s: std_logic;
    signal cctmp_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal cctmp_data_out_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal cctmp_wr_s: std_logic;
    
    signal mem_crtmp_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_crtmp_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal mem_crtmp_wr_s: std_logic;
    signal crtmp_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal crtmp_data_out_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c - 1 downto 0);
    signal crtmp_wr_s: std_logic;
    
    
    -- Matrix C memory interface
    signal mem_c_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal mem_c_data_in_s: std_logic_vector(DATA_WIDTH_c-1 downto 0);
    signal mem_c_wr_s: std_logic;
    signal c_addr_s: std_logic_vector(log2c(SIZE_c*SIZE_c)-1 downto 0);
    signal c_data_out_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c-1 downto 0);
    signal c_data_in_s: std_logic_vector(2*DATA_WIDTH_c+SIZE_c-1 downto 0);
    signal c_wr_s: std_logic;
    signal start_s: std_logic := '0';
    signal ready_s: std_logic;
    
    begin
        clk_gen: process
        begin
            clk_s <= '0', '1' after 100 ns;
            wait for 200 ns;
        end process;
        
        stim_gen: process
        begin
        -- Apply system level reset
        reset_s <= '1';
        wait for 500 ns;
        reset_s <= '0';
        wait until falling_edge(clk_s);
        -- Load the data into the matrix A memory
        mem_a_wr_s <= '1';
        for i in 0 to N_c-1 loop
            for j in 0 to M_c-1 loop
                mem_a_addr_s <= conv_std_logic_vector(i*M_c+j, mem_a_addr_s'length);
                mem_a_data_in_s <= MEM_A_CONTENT_c(i*M_c+j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_a_wr_s <= '0';
 
        -- Load the data into the matrix B memory
        mem_rg_wr_s <= '1';
        for i in 0 to N_c loop
            for j in 0 to N_c-1 loop --?
                mem_rg_addr_s <= conv_std_logic_vector(i*N_c+j, mem_rg_addr_s'length);
                mem_rg_data_in_s <= MEM_RG_CONTENT_c(i*N_c+j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_rg_wr_s <= '0';

        mem_cg_wr_s <= '1';
        for i in 0 to P_c-1 loop
            for j in 0 to P_c loop
                mem_cg_addr_s <= conv_std_logic_vector(i*(P_c + 1)+j, mem_cg_addr_s'length);
                mem_cg_data_in_s <= MEM_CG_CONTENT_c(i*(P_c + 1)+j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_cg_wr_s <= '0';

        mem_b_wr_s <= '1';
        for i in 0 to M_c-1 loop
            for j in 0 to P_c-1 loop
                mem_b_addr_s <= conv_std_logic_vector(i*P_c+j, mem_b_addr_s'length);
                mem_b_data_in_s <= MEM_B_CONTENT_c(i*P_c+j);
                wait until falling_edge(clk_s);
            end loop;
        end loop;
        mem_b_wr_s <= '0';

        mem_cc_wr_s <= '1';
        for i in 0 to N_c loop
            mem_cc_addr_s <= conv_std_logic_vector(i, mem_cc_addr_s'length);
            mem_cc_data_in_s <= MEM_CC_CONTENT_c(i);
            wait until falling_edge(clk_s);
        end loop;
        mem_b_wr_s <= '0';

        mem_cr_wr_s <= '1';
        for i in 0 to P_c loop
        mem_cr_addr_s <= conv_std_logic_vector(i, mem_cr_addr_s'length);
        mem_cr_data_in_s <= MEM_CR_CONTENT_c(i);
        wait until falling_edge(clk_s);
        end loop;
        mem_cr_wr_s <= '0';

        -- Start the multiplication process
        start_s <= '1';
        wait until falling_edge(clk_s);
        start_s <= '0';

        -- Wait until matrix multiplication module signals operation has been complted
        wait until ready_s = '1';

        -- End stimulus generation
        wait;
    end process;
 -- Matrix A memory
    matrix_a_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_a_addr_s,
            p1_data_i => mem_a_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_a_wr_s,
            p2_addr_i => a_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => a_data_in_s,
            p2_wr_i => a_wr_s);
    -- Matrix B memory
    matrix_b_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_b_addr_s,
            p1_data_i => mem_b_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_b_wr_s,
            p2_addr_i => b_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => b_data_in_s,
            p2_wr_i => b_wr_s);
      
   matrix_rg_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_rg_addr_s,
            p1_data_i => mem_rg_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_rg_wr_s,
            p2_addr_i => rg_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => rg_data_in_s,
            p2_wr_i => '0');
      
   matrix_cg_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_cg_addr_s,
            p1_data_i => mem_cg_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_cg_wr_s,
            p2_addr_i => cg_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => cg_data_in_s,
            p2_wr_i => '0');
      
   matrix_biga_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => 2*DATA_WIDTH_c+SIZE_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_biga_addr_s,
            p1_data_i => mem_biga_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_biga_wr_s,
            p2_addr_i => biga_addr_s,
            p2_data_i => biga_data_out_s,
            p2_data_o => biga_data_in_s,
            p2_wr_i => biga_wr_s);
      
   matrix_bigb_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => 2*DATA_WIDTH_c+SIZE_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_bigb_addr_s,
            p1_data_i => mem_bigb_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_bigb_wr_s,
            p2_addr_i => bigb_addr_s,
            p2_data_i => bigb_data_out_s,
            p2_data_o => bigb_data_in_s,
            p2_wr_i => bigb_wr_s);
      
   matrix_cc_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_cc_addr_s,
            p1_data_i => mem_cc_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_cc_wr_s,
            p2_addr_i => cc_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => cc_data_in_s,
            p2_wr_i => '0');
      
   matrix_cr_mem: entity work.dp_memory(beh)
        generic map (
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map (
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => mem_cr_addr_s,
            p1_data_i => mem_cr_data_in_s,
            p1_data_o => open,
            p1_wr_i => mem_cr_wr_s,
            p2_addr_i => cr_addr_s,
            p2_data_i => (others => '0'),
            p2_data_o => cr_data_in_s,
            p2_wr_i => '0');
      
            
    -- Matrix C memory
    matrix_c_mem: entity work.dp_memory(beh)
        generic map(
            WIDTH => 2*DATA_WIDTH_c+SIZE_c,
            SIZE => SIZE_c)
        port map(
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => (others => '0'),
            p1_data_i => (others => '0'),
            p1_data_o => open,
            p1_wr_i => '0',
            p2_addr_i => c_addr_s,
            p2_data_i => c_data_out_s,
            p2_data_o => c_data_in_s,
            p2_wr_i => c_wr_s);
            
    matrix_cctmp_mem: entity work.dp_memory(beh)
        generic map(
            WIDTH => 2*DATA_WIDTH_c+SIZE_c,
            SIZE => SIZE_c)
        port map(
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => (others => '0'),
            p1_data_i => (others => '0'),
            p1_data_o => open,
            p1_wr_i => '0',
            p2_addr_i => cctmp_addr_s,
            p2_data_i => cctmp_data_out_s,
            p2_data_o => open,
            p2_wr_i => cctmp_wr_s);
            
    matrix_crtmp_mem: entity work.dp_memory(beh)
        generic map(
            WIDTH => 2*DATA_WIDTH_c+SIZE_c,
            SIZE => SIZE_c)
        port map(
            clk => clk_s,
            reset => reset_s,
            p1_addr_i => (others => '0'),
            p1_data_i => (others => '0'),
            p1_data_o => open,
            p1_wr_i => '0',
            p2_addr_i => crtmp_addr_s,
            p2_data_i => crtmp_data_out_s,
            p2_data_o => open,
            p2_wr_i => crtmp_wr_s);
            
    
    -- DUT
    n_in_s <= conv_std_logic_vector(N_c, log2c(SIZE_c));
    p_in_s <= conv_std_logic_vector(P_c, log2c(SIZE_c));
    m_in_s <= conv_std_logic_vector(M_c, log2c(SIZE_c));
        
    matrix_multiplication_core: entity work.csm_top(Behavioral)
        generic map(
            WIDTH => DATA_WIDTH_c,
            SIZE => SIZE_c)
        port map(
 --------------- Clocking and reset interface ---------------
            clk => clk_s,
            reset => reset_s,
 ------------------- Input data interface -------------------
            -- Matrix A memory interface
            a_addr_o => a_addr_s,
            a_data_i => a_data_in_s,
            a_wr_o => a_wr_s,
            -- Matrix B memory interface
            b_addr_o => b_addr_s,
            b_data_i => b_data_in_s,
            b_wr_o => b_wr_s,
            -- Matrix dimensions definition interface
            n_in => n_in_s,
            p_in => p_in_s,
            m_in => m_in_s,
            ------------------- Output data interface ------------------
            -- Matrix C memory interface
            c_addr_o => c_addr_s,
            c_data_o => c_data_out_s,
            c_data_i => c_data_in_s,
            c_wr_o => c_wr_s,
            
            biga_data_i => biga_data_in_s,
            biga_data_o => biga_data_out_s,
            biga_wr_o   => biga_wr_s,
            
            bigb_data_i => bigb_data_in_s,
            bigb_data_o => bigb_data_out_s,
            bigb_wr_o   => bigb_wr_s,
            
            rg_data_i => rg_data_in_s,
            cg_data_i => cg_data_in_s,
            
            ccc_data_i => cc_data_in_s,
            ccr_data_i => cr_data_in_s,
            
            cctmp_data_o => cctmp_data_out_s,
            cctmp_wr_o => cctmp_wr_s,
            
            crtmp_data_o => crtmp_data_out_s,
            crtmp_wr_o => crtmp_wr_s,
            
            rg_addr_o => rg_addr_s,
            cg_addr_o => cg_addr_s,
            biga_addr_o => biga_addr_s,
            bigb_addr_o => bigb_addr_s,
            ccr_addr_o => cr_addr_s,
            ccc_addr_o => cc_addr_s,
            cctmp_addr_o => cctmp_addr_s,
            crtmp_addr_o => crtmp_addr_s,

            --------------------- Command interface --------------------
            top_start => start_s,
            --------------------- Status interface ---------------------
            top_ready => ready_s);
end architecture beh;