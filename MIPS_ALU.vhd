---------------------------------------------------------------------------------- 
-- Engineer: Serkan Kavak
-- Create Date: 01.03.2019 03:11:46
-- Module Name: top - Behavioral
-- Project Name: 32-bit MIPS ALU DESIGN
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
    Port ( A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           OP : in STD_LOGIC_VECTOR (5 downto 0);
           Result : out STD_LOGIC_VECTOR (31 downto 0));
end top;

architecture Behavioral of top is

signal reg0, reg1, reg2, reg3 : std_logic_vector (31 downto 0);
signal temp10: std_logic_vector (31 downto 0) := X"0000_0000";
signal tempx, tempy, tempz : std_logic_vector (31 downto 0);
signal temp100, temp110, temp120, temp130 : std_logic;
signal reg30, reg31 : bit_vector (31 downto 0);
signal reg32 : integer;

begin

with OP (5 downto 4) select
    Result <= reg0 when "00",
              reg1 when "01",
              reg2 when "10",
              reg3 when others;
              
with OP (3) select
    reg0 <= std_logic_vector( unsigned(A) + unsigned(B) ) when '0',
            std_logic_vector( unsigned(A) - unsigned(B) ) when others;

with OP (2 downto 0) select
    temp130 <= temp100 when "001",
               not temp100 when "010",
               temp110 when "011",
               not temp110 when "100",
               temp120 when "101",
               not temp120 when "110",
               '0' when others;

with OP (1 downto 0) select
    reg2 <= A NOR B when "00",
            A AND B when "01",
            A OR B when "10",
            A XOR B when others;

with OP (2 downto 0) select
    reg30 <= reg31 ROL reg32 when "000",
             reg31 ROR reg32 when "001",
             reg31 SLL reg32 when "010",
             reg31 SRL reg32 when "011",
             reg31 SRA reg32 when "111",
             (others => '0') when others;

reg3 <= to_stdlogicvector(reg30);
reg31 <= to_bitvector(A);
reg32 <= to_integer(unsigned(B(5 downto 0)));

temp100 <= '0' when signed(A) < signed(B) else
           '1';
temp110 <= '0' when A = B else
           '1';
temp120 <= '0' when unsigned(A) < unsigned(B) else
           '1';
           
reg1 <= temp10(31 downto 1) & temp130;

end Behavioral;
