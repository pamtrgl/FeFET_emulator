----------------------------------------------------------------------------------
-- Company: ECL - Institut des Nanontechnologies de Lyon
-- Engineer: MATRANGOLO Paul-Antoine
-- 
-- Create Date: 09.03.2021 15:36:56
-- Design Name: FeFET Emulator 
-- Module Name: FeFET - Behavioral
-- Project Name: SECRET
-- Target Devices: ARTY Z7
-- Tool Versions: 2020.2
-- Description: This desing aim to describe and emulate a FeFET to get electrical
-- caracterizations
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.2 - 12/04/21
-- Additional Comments: This revision add a logical port to check behavioral aspect.
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

--import fixed point packages as project sources in a new library
library ieee_proposed;
use ieee_proposed.fixed_float_types.all;
use ieee_proposed.fixed_pkg.all;

entity FeFET is 
    Port (  Vi      : in std_logic_vector(23 downto 0);         -- 24 bits precision
            Vo      : out std_logic_vector(23 downto 0);       -- 24 bits precision
            Qo      : out std_logic:= '0' );                    -- logic output
                
            
end FeFET;

architecture Behavioral of FeFET is 
    signal A: std_logic := '0';                     -- in bit (pulse)
    signal B: std_logic := '0';                     -- stored bit
    signal P: std_logic := '0';                     -- polarization signal (0=HIGH; 1=LOW)
    signal ViR: sfixed(8 downto -15):= X"000000";   -- 24 bits precision
    signal VoR: sfixed(8 downto -15):= X"000000";   -- 24 bits precision
    
    --constant Rmin: sfixed(8 downto -15):= X"008000";    -- Rmin = 1ohm
    --constant Rmax: sfixed(8 downto -15):= X"050000";    -- Rmax = 10ohm
    

begin 
    
    ViR <= resize(to_sfixed(Vi, 8, -15) * to_sfixed(0.015625, 8, -15), 8, -15); --Conversion of Vi to real value --ViR E [-4; +4]
    Vo <= to_slv(resize(VoR, 8, -15));
    Qo <= not(A and B);
    
    pls: process(ViR)     -- pulse
    begin
        if(ViR >= to_sfixed(1.2, ViR)) then
            A <= '1';
        else
            A <= '0';
        end if;
    end process pls;
    
    pol: process(ViR, VoR, P)
    begin
    --Updating polarization
    --If ViR E [-2; 2], Vo is arbitrary
        if(ViR < to_sfixed(-2.0, ViR)) then 
            if (ViR < to_sfixed(-2.5, ViR))  then 
                P <= '0'; -- high polarity
                B <= '1';
            end if;
            VoR <= to_sfixed(1.2, VoR);
            
        elsif(ViR > to_sfixed(2.0, ViR))  then 
            if (ViR > to_sfixed(2.5, ViR))  then 
                P <= '1'; -- low polarity
                B <= '0';
            end if;
            VoR <= to_sfixed(0.03, VoR);
            
        elsif(P = '0') then
            ---- -4V polarization 
            if (ViR < to_sfixed(0.0, ViR)) then
            --VoR <= 1.2;
                VoR <= to_sfixed(1.2, VoR);
                 
            elsif(ViR >= to_sfixed(0.0, ViR) and ViR < to_sfixed(0.44, ViR)) then
            --VoR <= 1.2-4.0*ViR**4;
                VoR <= resize(to_sfixed(1.2, 8, -15) - (to_sfixed(4.0, 8, -15)
                 * ViR * ViR * ViR * ViR), 8, -15);
                
            elsif(ViR >= to_sfixed(0.44, ViR) and ViR < to_sfixed(0.75, ViR)) then
            --VoR <= -2.9*(ViR-0.6)+0.6;
                VoR <= resize(to_sfixed(-2.9, 8, -15) * (ViR - to_sfixed(0.6, 8, -15))
                 + to_sfixed(0.6, 8, -15), 8, -15);
                
            elsif(ViR >= to_sfixed(0.75, ViR) and ViR < to_sfixed(1.2, ViR)) then
            --VoR <= 3.0*(ViR-1.2)**4+0.045;
                VoR <= resize(to_sfixed(3.0, 8, -15) 
                 * (ViR - to_sfixed(1.2, 8, -15))
                 * (ViR - to_sfixed(1.2, 8, -15))
                 * (ViR - to_sfixed(1.2, 8, -15))
                 * (ViR - to_sfixed(1.2, 8, -15))
                 + to_sfixed(0.045, 8, -15), 8, -15);
                
            else
            --VoR <= -0.014*(ViR-1.42)+0.04;
                VoR <= resize(to_sfixed(-0.014, 8, -15) * (ViR - to_sfixed(1.42, 8, -15))
                 + to_sfixed(0.04, 8, -15), 8, -15);
            end if;
        
        elsif(P = '1') then
            ---- +4V polarization 
            if(ViR < to_sfixed(-0.7, ViR)) then
            --VoR <= 1.17-0.1*(ViR+0.1)-0.1*(ViR+0.1)**2;
                VoR <= resize(to_sfixed(1.17, 8, -15)
                 - to_sfixed(0.1, 8, -15) * (ViR + to_sfixed(0.1, 8, -15)) 
                 - to_sfixed(0.1, 8, -15) * (ViR + to_sfixed(0.1, 8, -15)) * (ViR + to_sfixed(0.1, 8, -15)), 8, -15);
                
                            
            elsif(ViR >= to_sfixed(-0.7, ViR) and ViR < to_sfixed(1.7, ViR)) then
            --VoR <= 1.2;
                VoR <= to_sfixed(1.2, VoR);
                
            elsif(ViR >= to_sfixed(1.7, ViR) and ViR < to_sfixed(1.9, ViR)) then
            --VoR <= 1.2-10.0*(ViR-1.7)**2;
                VoR <= resize(to_sfixed(1.2, 8, -15)
                 - to_sfixed(10.0, 8, -15) * (ViR - to_sfixed(1.7, 8, -15))
                 * (ViR - to_sfixed(1.7, 8, -15)), 8, -15);
                
            else
            --VoR <= 0.03-8.0*(ViR-2.0);
                VoR <= resize(to_sfixed(0.03, 16, -46)
                - to_sfixed(8.0, 8, -15) * (ViR - to_sfixed(2.0, 8, -15)), 8, -15);
                
            end if;            
        end if;
    end process pol;
    
end Behavioral;