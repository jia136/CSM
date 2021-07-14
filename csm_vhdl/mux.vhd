----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/13/2021 10:08:53 PM
-- Design Name: 
-- Module Name: mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
    generic( WIDTH: integer:=8);
    Port (x0: in std_logic_vector(WIDTH-1 downto 0);
          x1: in std_logic_vector(WIDTH-1 downto 0);
          x2: in std_logic_vector(WIDTH-1 downto 0);
          x3: in std_logic_vector(WIDTH-1 downto 0);
          x4: in std_logic_vector(WIDTH-1 downto 0);
          sel: in std_logic_vector(2 downto 0);
          y: out std_logic_vector(WIDTH-1 downto 0)
          );
end mux;

architecture Behavioral of mux is

begin
    mux: process(x0, x1, x2, x3, x4, sel)
    begin
        case sel is
            when "000" => y <= x0;
            when "001" => y <= x1;
            when "010" => y <= x2;
            when "011" => y <= x3;
            when "100" => y <= x4;
            when others => y <= (others => '0');
        end case;
    end process;

end Behavioral;
