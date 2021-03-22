----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.03.2021 12:53:22
-- Design Name: 
-- Module Name: FeFET_real - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FeFET1 is
    Port (  Vi : in STD_LOGIC_VECTOR(15 downto 0);
            Vo : out STD_LOGIC_VECTOR(15 downto 0)); 
end FeFET1;

architecture Behavioral of FeFET1 is 
    signal A:std_logic := '0'; 
    signal ViR:real; 
    signal VoR:real; 

begin 
    --Conversions et mises jour 
    ViR <= (real(to_integer(unsigned(Vi)))-real(32767))*0.00009; 
    Vo <= std_logic_vector(to_unsigned(integer(VoR*real(32767)), 16));
    
    process (ViR, A)
    --Mise jour de la polarisation et VoR 
    begin 
    --Mise jour de la polarisation 
    --Si Vi est en dehors de l'intervalle [-2; 2], la valeur de Vo est arbitraire 
        if ViR < -2.0 then 
            if ViR < -2.5 then -- On ajoute une petite marge 
                A <= '0';
            end if; 
                VoR <= 1.2; 
        elsif ViR > 2.0 then 
            if ViR > 2.5 then -- On ajoute une petite marge 
                A <= '1'; 
            end if; 
            VoR <= 0.03;
        --Cas normal, 
        ----polarisation -4V 
        elsif A = '0' then 
            if ViR < 0.0 then 
                VoR <= 1.2; 
            elsif ViR < 0.44 then 
                VoR <= 1.2-4.0*ViR**4; 
            elsif ViR < 0.75 then 
                VoR <= -2.9*(ViR-0.6)+0.6; 
            elsif Vir < 1.2 then 
                VoR <= 3.0*(ViR-1.2)**4+0.045; 
            else 
                VoR <= -0.014*(ViR-1.42)+0.04; 
        end if;
        
        ----polarisation +4V 
        elsif A = '1' then
            if ViR < -0.7 then
                VoR <= 1.17-0.1*(ViR+0.1)-0.1*(ViR+0.1)**2; 
            elsif ViR < 1.7 then 
                VoR <= 1.2;
             elsif ViR < 1.9 then 
                VoR <= 1.2-10.0*(ViR-1.7)**2; 
             else 
                VoR <= 0.03-8.0*(ViR-2.0); 
             end if; 
        end if;
    end process;
    
end Behavioral;
