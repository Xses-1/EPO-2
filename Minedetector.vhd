library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timebase is
    port(clk   : in std_logic;
         reset : in std_logic;
	 input : in std_logic;
         mine     : out std_logic
	);
end entity timebase;

architecture behavioural of timebase is

	signal count, new_count : unsigned (19 downto 0) ;

begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (reset = '1' or input = '1') then
                count <= (others => '0');

            else
                count <= new_count;
            end if;
        end if;
    end process;

    process (count,reset)
    begin
	if (reset = '0' and input = '0') then
		new_count <= count + 1;
	else
		new_count <= count;
	end if;
    end process;


	process (count)
		begin
			if (count > to_unsigned(1800,20)) then
				mine <= '1';
			else
				mine <= '0';
			end if;
	end process;

			
	
end architecture behavioural;
