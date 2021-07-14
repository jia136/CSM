library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils_pkg.all;

entity csm_top is
    generic (
        WIDTH: integer := 18;
        SIZE: integer := 3
    );
    Port ( 
        --------------- Clocking and reset interface ---------------
        clk: in std_logic;
        reset: in std_logic;
        ------------------- Input data interface -------------------
        
        -- Matrix A memory interface
        a_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        a_data_i: in std_logic_vector(WIDTH-1 downto 0);
        a_wr_o: out std_logic;
        
        rg_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        rg_data_i: in std_logic_vector(WIDTH-1 downto 0);
        --rg_wr_o: out std_logic;
        
        -- Matrix B memory interface
        b_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        b_data_i: in std_logic_vector(WIDTH-1 downto 0);
        b_wr_o: out std_logic;
        
        cg_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        cg_data_i: in std_logic_vector(WIDTH-1 downto 0);
        --cg_wr_o: out std_logic;
        
        -- Matrix dimensions definition interface
        n_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
        p_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
        m_in: in std_logic_vector(log2c(SIZE)-1 downto 0);
        
        ------------------- Output data interface ------------------
        -- Matrix C memory interface
        c_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        c_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        c_data_i: in std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        c_wr_o: out std_logic;
        
        ccr_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        ccr_data_i: in std_logic_vector(WIDTH-1 downto 0);
        --ccr_wr_o: out std_logic;
        
        ccc_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        ccc_data_i: in std_logic_vector(WIDTH-1 downto 0);
        --ccc_wr_o: out std_logic;
        
        cctmp_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        cctmp_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        cctmp_wr_o: out std_logic;
        
        crtmp_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        crtmp_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        crtmp_wr_o: out std_logic;
                
        biga_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        biga_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        biga_data_i: in std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        biga_wr_o: out std_logic;
        
        bigb_addr_o: out std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
        bigb_data_o: out std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        bigb_data_i: in std_logic_vector(2*WIDTH+SIZE-1 downto 0);
        bigb_wr_o: out std_logic;
        
        --------------------- Command interface --------------------
        top_start: in std_logic;
        --------------------- Status interface ---------------------
        top_ready: out std_logic);
end csm_top;

architecture Behavioral of csm_top is
    signal mm_rdy_s: std_logic;
    signal mm_start_s: std_logic;
    signal sel_s: std_logic_vector(2 downto 0);
    signal a_data_s: std_logic_vector(WIDTH-1 downto 0);
    signal b_data_s: std_logic_vector(WIDTH-1 downto 0);
    signal mm_c_data_s: std_logic_vector(2*WIDTH+SIZE-1 downto 0);
    signal n1_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    signal n_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    --signal m1_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    signal m_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    signal p1_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    signal p_s: std_logic_vector(log2c(SIZE)-1 downto 0);
    signal c_wr_s: std_logic;
    --signal a_wr_s: std_logic;
    --signal b_wr_s: std_logic;
    --signal y2a,y0c,y2b,y1c,y4a,y3b,y2c: std_logic;
    signal a_addr_s: std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    signal b_addr_s: std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    signal c_addr_s: std_logic_vector(log2c(SIZE*SIZE)-1 downto 0);
    
begin

    mux_mm_a_int: entity work.mux(Behavioral)
        generic map(
            WIDTH => WIDTH)
        port map(
            x0 => rg_data_i,
            x1 => b_data_i,
            x2 => biga_data_i(WIDTH-1 downto 0),
            x3 => ccc_data_i,
            x4 => c_data_i (WIDTH-1 downto 0),
            sel => sel_s,
            y => a_data_s
        );
        
    mux_mm_b_int: entity work.mux(Behavioral)
        generic map(
            WIDTH => WIDTH)
        port map(
            x0 => a_data_i,
            x1 => cg_data_i,
            x2 => bigb_data_i(WIDTH-1 downto 0),
            x3 => c_data_i (WIDTH-1 downto 0),
            x4 => ccr_data_i,
            sel => sel_s,
            y => b_data_s
        );
     
     n1_s <= std_logic_vector(unsigned(n_in) + to_unsigned(1,log2c(SIZE)));
     --m1_s <= std_logic_vector(unsigned(m_in) + to_unsigned(1,log2c(SIZE)));
     p1_s <= std_logic_vector(unsigned(p_in) + to_unsigned(1,log2c(SIZE)));
     
    mux_mm_n: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE))
       port map(
           x0 => n1_s ,
           x1 => m_in,
           x2 => n1_s,
           x3 => std_logic_vector(to_unsigned(1,log2c(SIZE))),
           x4 => n1_s,
           sel => sel_s,
           y => n_s
       );
     mux_mm_m: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE))
       port map(
           x0 => n_in ,
           x1 => p_in,
           x2 => m_in,
           x3 => n1_s,
           x4 => p1_s,
           sel => sel_s,
           y => m_s
       );
     mux_mm_p: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE))
       port map(
           x0 => m_in ,
           x1 => p1_s,
           x2 => p1_s,
           x3 => p1_s,
           x4 => std_logic_vector(to_unsigned(1,log2c(SIZE))),
           sel => sel_s,
           y => p_s
       );
       
    mux_a_addr: entity work.mux(Behavioral)
       generic map(
       WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => b_addr_s ,
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => a_addr_o
       ); 
       
    mux_b_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => a_addr_s,
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => b_addr_o
       ); 
       
    mux_cg_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => b_addr_s,
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => cg_addr_o
       ); 
       
    mux_rg_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => a_addr_s,
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => rg_addr_o
       ); 
       
    mux_c_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => (others => '0'),
           x2 => c_addr_s,
           x3 => b_addr_s,
           x4 => a_addr_s,
           sel => sel_s,
           y => c_addr_o
       ); 
       
    mux_ccr_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => b_addr_s,
           sel => sel_s,
           y => ccr_addr_o
       ); 
       
    mux_ccc_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => a_addr_s,
           x4 => (others => '0'),
           sel => sel_s,
           y => ccc_addr_o
       ); 
       
    mux_cctmp_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => c_addr_s,
           x4 => (others => '0'),
           sel => sel_s,
           y => cctmp_addr_o
       ); 
       
    mux_crtmp_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => (others => '0'),
           x2 => (others => '0'),
           x3 => (others => '0'),
           x4 => c_addr_s,
           sel => sel_s,
           y => crtmp_addr_o
       ); 
       
    mux_biga_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => c_addr_s,
           x1 => (others => '0'),
           x2 => a_addr_s,
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => biga_addr_o
       ); 
       
    mux_bigb_addr: entity work.mux(Behavioral)
       generic map(
           WIDTH => log2c(SIZE*SIZE))
       port map(
           x0 => (others => '0'),
           x1 => c_addr_s,
           x2 => b_addr_s,
           x3 => (others => '0'),
           x4 => (others => '0'),
           sel => sel_s,
           y => bigb_addr_o
       ); 
       
       
    demux_mm_c_int: entity work.demux(Behavioral)
        generic map(
            WIDTH => 2*WIDTH+SIZE)
        port map(
            y0  => biga_data_o,
            y1  => bigb_data_o,
            y2  => c_data_o,
            y3  => cctmp_data_o,
            y4  => crtmp_data_o,
            sel => sel_s,
            x   => mm_c_data_s
        );

    demux_mm_c_wr_s: entity work.demux(Behavioral)
        generic map(
            WIDTH => 1)
        port map(
            y0(0) => biga_wr_o,
            y1(0) => bigb_wr_o,
            y2(0) => c_wr_o,
            y3(0) => cctmp_wr_o,
            y4(0) => crtmp_wr_o,
            sel => sel_s,
            x(0) => c_wr_s
        );
    
        
    ctrl: entity work.cm_control(Behavioral)
        port map(
            clk         => clk,
            reset       => reset,
            mm_rdy      => mm_rdy_s,
            start       => top_start,
            mm_start_o  => mm_start_s,
            ready       => top_ready,
            sel_o       => sel_s);
    mm: entity work.matrix_mult(two_seg_arch)
        generic map(
            WIDTH => WIDTH,
            SIZE => SIZE)
        port map(
 --------------- Clocking and reset interface ---------------
            clk => clk,
            reset => reset,
            -- Matrix A memory interface
            a_addr_o => a_addr_s,
            a_data_i => a_data_s,
            a_wr_o => a_wr_o,
            -- Matrix B memory interface
            b_addr_o => b_addr_s,
            b_data_i => b_data_s,
            b_wr_o => b_wr_o,
            -- Matrix dimensions definition interface
            n_in => n_s,
            p_in => p_s,
            m_in => m_s,
            ------------------- Output data interface ------------------
            -- Matrix C memory interface
            c_addr_o => c_addr_s,
            c_data_o => mm_c_data_s,
            c_wr_o => c_wr_s,
            --------------------- Command interface --------------------
            start => mm_start_s,
            --------------------- Status interface ---------------------
            ready => mm_rdy_s);
            
end Behavioral;
