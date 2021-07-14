library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demux is
generic( WIDTH: integer:=8);
Port (y0 : out std_logic_vector(WIDTH-1 downto 0);
      y1 : out std_logic_vector(WIDTH-1 downto 0);
      y2 : out std_logic_vector(WIDTH-1 downto 0);
      y3 : out std_logic_vector(WIDTH-1 downto 0);
      y4 : out std_logic_vector(WIDTH-1 downto 0);
      sel: in std_logic_vector(2 downto 0);
      x  : in std_logic_vector(WIDTH-1 downto 0)
      );
end demux;

architecture Behavioral of demux is

begin

    mux: process(x, sel)
    begin
        case sel is
            when "000" =>
                y0 <= x;
                y1 <= (others => '0');
                y2 <= (others => '0');
                y3 <= (others => '0');
                y4 <= (others => '0');
            when "001" =>
                y0 <= (others => '0');
                y1 <= x;
                y2 <= (others => '0');
                y3 <= (others => '0');
                y4 <= (others => '0');
            when "010" =>
                y0 <= (others => '0');
                y1 <= (others => '0');
                y2 <= x;
                y3 <= (others => '0');
                y4 <= (others => '0');
            when "011" =>
                y0 <= (others => '0');
                y1 <= (others => '0');
                y2 <= (others => '0');
                y3 <= x;
                y4 <= (others => '0');
            when "100" =>
                y0 <= (others => '0');
                y1 <= (others => '0');
                y2 <= (others => '0');
                y3 <= (others => '0');
                y4 <= x;
            when others =>
                y0 <= (others => '0');
                y1 <= (others => '0');
                y2 <= (others => '0');
                y3 <= (others => '0');
                y4 <= (others => '0');
            end case;
    end process;

end Behavioral;
