library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity timebase is
	port (  clk             : in std_logic;
        	reset           : in std_logic;
        	count_out       : out std_logic_vector (19 downto 0);
		
		--New periodic reset
		reset_out	: out std_logic
 	) ;
 end entity timebase ;

 architecture behavioural of timebase is

 	signal count, new_count : unsigned (19 downto 0);

 begin
 	process ( clk )
 	begin
 		if ( clk'event and clk ='1' ) then
			if ( (reset = '1') or (unsigned(count) >= to_unsigned(1000000, 20))) then  -- or (unsigned(count) >= to_unsigned(1000000, 20) added
 				count <= ( others => '0');
				reset_out <= '1';				-- Added reset_out signal.
 			else
				reset_out <= '0'; 
 				count <= new_count;
 			end if;
 		end if;
 	end process;


 	process ( count )
 	begin

		new_count <= count + 1;

 	end process;

 	count_out <= std_logic_vector ( count );
 end architecture behavioural;
