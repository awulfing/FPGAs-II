library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity lzc is
    port (
        clk        : in  std_logic;
        lzc_vector : in  std_logic_vector (23 downto 0);
        lzc_count  : out std_logic_vector ( 4 downto 0)
    );
end lzc;

architecture behavioral of lzc is

    signal b0 : std_logic;
    signal b1 : std_logic;
    signal b2 : std_logic;
    signal b3 : std_logic;
    signal b4 : std_logic;
    signal b5 : std_logic;
    signal b6 : std_logic;
    signal b7 : std_logic;
    signal b8 : std_logic;
    signal b9 : std_logic;
    signal b10 : std_logic;
    signal b11 : std_logic;
    signal b12 : std_logic;
    signal b13 : std_logic;
    signal b14 : std_logic;
    signal b15 : std_logic;
    signal b16 : std_logic;
    signal b17 : std_logic;
    signal b18 : std_logic;
    signal b19 : std_logic;
    signal b20 : std_logic;
    signal b21 : std_logic;
    signal b22 : std_logic;
    signal b23 : std_logic;

begin

    process (clk)
    begin
        if rising_edge(clk) then
            b0 <= lzc_vector(0);
            b1 <= lzc_vector(1);
            b2 <= lzc_vector(2);
            b3 <= lzc_vector(3);
            b4 <= lzc_vector(4);
            b5 <= lzc_vector(5);
            b6 <= lzc_vector(6);
            b7 <= lzc_vector(7);
            b8 <= lzc_vector(8);
            b9 <= lzc_vector(9);
            b10 <= lzc_vector(10);
            b11 <= lzc_vector(11);
            b12 <= lzc_vector(12);
            b13 <= lzc_vector(13);
            b14 <= lzc_vector(14);
            b15 <= lzc_vector(15);
            b16 <= lzc_vector(16);
            b17 <= lzc_vector(17);
            b18 <= lzc_vector(18);
            b19 <= lzc_vector(19);
            b20 <= lzc_vector(20);
            b21 <= lzc_vector(21);
            b22 <= lzc_vector(22);
            b23 <= lzc_vector(23);
        end if;
    end process;
 
    process (b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23 )
    begin

        if ((b23 or b22 or b21 or b20 or b19 or b18 or b17 or b16 or b15 or b14 or b13 or b12) = '1') then   -- [23  12]
            if ((b23 or b22 or b21 or b20 or b19 or b18) = '1') then   -- [23  18]
                if ((b23 or b22 or b21) = '1') then   -- [23  21]
                    if ((b23 or b22) = '1') then   -- [23  22]
                        if (b23 = '1') then   -- [23]
                            lzc_count <= "00000";  -- lzc = 0
                        else  -- [22]
                            lzc_count <= "00001";  -- lzc = 1
                        end if;
                    else  -- [21]
                        lzc_count <= "00010";  -- lzc = 2
                    end if;
                else  -- [20  18]
                    if ((b20 or b19) = '1') then   -- [20  19]
                        if (b20 = '1') then   -- [20]
                            lzc_count <= "00011";  -- lzc = 3
                        else  -- [19]
                            lzc_count <= "00100";  -- lzc = 4
                        end if;
                    else  -- [18]
                        lzc_count <= "00101";  -- lzc = 5
                    end if;
                end if; 
            else  -- [17  12]
                if ((b17 or b16 or b15) = '1') then   -- [17  15]
                    if ((b17 or b16) = '1') then   -- [17  16]
                        if (b17 = '1') then   -- [17]
                            lzc_count <= "00110";  -- lzc = 6
                        else  -- [16]
                            lzc_count <= "00111";  -- lzc = 7
                        end if;
                    else  -- [15]
                        lzc_count <= "01000";  -- lzc = 8
                    end if;
                else  -- [14  12]
                    if ((b14 or b13) = '1') then   -- [14  13]
                        if (b14 = '1') then   -- [14]
                            lzc_count <= "01001";  -- lzc = 9
                        else  -- [13]
                            lzc_count <= "01010";  -- lzc = 10
                        end if;
                    else  -- [12]
                        lzc_count <= "01011";  -- lzc = 11
                    end if;
                end if; 
            end if; 
        else  -- [11   0]
            if ((b11 or b10 or b9 or b8 or b7 or b6) = '1') then   -- [11   6]
                if ((b11 or b10 or b9) = '1') then   -- [11   9]
                    if ((b11 or b10) = '1') then   -- [11  10]
                        if (b11 = '1') then   -- [11]
                            lzc_count <= "01100";  -- lzc = 12
                        else  -- [10]
                            lzc_count <= "01101";  -- lzc = 13
                        end if;
                    else  -- [9]
                        lzc_count <= "01110";  -- lzc = 14
                    end if;
                else  -- [8  6]
                    if ((b8 or b7) = '1') then   -- [8  7]
                        if (b8 = '1') then   -- [8]
                            lzc_count <= "01111";  -- lzc = 15
                        else  -- [7]
                            lzc_count <= "10000";  -- lzc = 16
                        end if;
                    else  -- [6]
                        lzc_count <= "10001";  -- lzc = 17
                    end if;
                end if; 
            else  -- [5  0]
                if ((b5 or b4 or b3) = '1') then   -- [5  3]
                    if ((b5 or b4) = '1') then   -- [5  4]
                        if (b5 = '1') then   -- [5]
                            lzc_count <= "10010";  -- lzc = 18
                        else  -- [4]
                            lzc_count <= "10011";  -- lzc = 19
                        end if;
                    else  -- [3]
                        lzc_count <= "10100";  -- lzc = 20
                    end if;
                else  -- [2  0]
                    if ((b2 or b1) = '1') then   -- [2  1]
                        if (b2 = '1') then   -- [2]
                            lzc_count <= "10101";  -- lzc = 21
                        else  -- [1]
                            lzc_count <= "10110";  -- lzc = 22
                        end if;
                    else  -- [0]
                        lzc_count <= "10111";  -- lzc = 23
                    end if;
                end if; 
            end if; 
        end if; 

    end process;

end behavioral;
