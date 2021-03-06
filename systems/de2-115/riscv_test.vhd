library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
entity riscv_test is

  port(
    KEY      : in std_logic_vector(3 downto 0);
    SW       : in std_logic_vector(17 downto 0);
    clock_50 : in std_logic;

    LEDR : out std_logic_vector(17 downto 0);
    LEDG : out std_logic_vector(7 downto 0);
    HEX7 : out std_logic_vector(6 downto 0);
    HEX6 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX0 : out std_logic_vector(6 downto 0));


end entity riscv_test;

architecture rtl of riscv_test is

  component system is
    port (

      clk_clk                : in  std_logic                     := '0';  --             clk.clk
      hex0_export            : out std_logic_vector(31 downto 0);  --            hex0.export
      hex1_export            : out std_logic_vector(31 downto 0);  --            hex1.export
      hex2_export            : out std_logic_vector(31 downto 0);  --            hex2.export
      hex3_export            : out std_logic_vector(31 downto 0);  --            hex3.export
      ledg_export            : out std_logic_vector(31 downto 0);  --            ledg.export
      ledr_export            : out std_logic_vector(31 downto 0);  --            ledr.export
      reset_reset_n          : in  std_logic                     := '0'  --           reset.reset_n

      );
  end component ;


  signal hex_input   : std_logic_vector(31 downto 0);
  signal clk         : std_logic;
  signal reset       : std_logic;
  signal ledg_export : std_logic_vector(31 downto 0);
  signal ledr_export : std_logic_vector(31 downto 0);
  signal hex3_export : std_logic_vector(31 downto 0);
  signal hex2_export : std_logic_vector(31 downto 0);
  signal hex1_export : std_logic_vector(31 downto 0);
  signal hex0_export : std_logic_vector(31 downto 0);

  function seven_segment (
    signal input : std_logic_vector)
    return std_logic_vector is
    variable to_ret : std_logic_vector(6 downto 0);
  begin  -- function le2be
    case input is
      when x"0"   => to_ret := "1000000";
      when x"1"   => to_ret := "1111001";
      when x"2"   => to_ret := "0100100";
      when x"3"   => to_ret := "0110000";
      when x"4"   => to_ret := "0011001";
      when x"5"   => to_ret := "0010010";
      when x"6"   => to_ret := "0000010";
      when x"7"   => to_ret := "1111000";
      when x"8"   => to_ret := "0000000";
      when x"9"   => to_ret := "0011000";
      when x"a"   => to_ret := "0001000";
      when x"b"   => to_ret := "0000011";
      when x"c"   => to_ret := "1000110";
      when x"d"   => to_ret := "0100001";
      when x"e"   => to_ret := "0000110";
      when x"f"   => to_ret := "0001110";
      when others => null;
    end case;
    return to_ret;
  end function;
begin
  clk   <= clock_50;
  reset <= key(1);

  rv : component system
    port map (
      clk_clk                => clk,
      reset_reset_n          => reset,
      ledg_export            => ledg_export,
      ledr_export            => ledr_export,
      hex3_export            => hex3_export,
      hex2_export            => hex2_export,
      hex1_export            => hex1_export,
      hex0_export            => hex0_export);


--  hex_input(15 downto 0)  <= pc(15 downto 0);
--  hex_input(31 downto 16) <= th(15 downto 0);
  
  hex_input <=
    hex3_export when sw(3) = '1' else
    hex2_export when sw(2) = '1' else
    hex1_export when sw(1) = '1' else
    hex0_export when sw(0) = '1' else
    (others => '0');

  HEX0 <= seven_segment(hex_input(3 downto 0));
  HEX1 <= seven_segment(hex_input(7 downto 4));
  HEX2 <= seven_segment(hex_input(11 downto 8));
  HEX3 <= seven_segment(hex_input(15 downto 12));
  HEX4 <= seven_segment(hex_input(19 downto 16));
  HEX5 <= seven_segment(hex_input(23 downto 20));
  HEX6 <= seven_segment(hex_input(27 downto 24));
  HEX7 <= seven_segment(hex_input(31 downto 28));

  LEDR             <= ledr_export(17 downto 0);
  LEDG(6 downto 0) <= ledg_export(6 downto 0);
  LEDG(7)          <= reset;
end;
