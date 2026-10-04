# =========================================================
# ASYNC FIFO TIMING CONSTRAINTS
# =========================================================

# Write clock = 100 MHz
create_clock -name write_clk \
    -period 10.000 \
    [get_ports write_clk]

# Read clock = 80 MHz
create_clock -name read_clk \
    -period 12.500 \
    [get_ports read_clk]

# The two clock domains are asynchronous
set_clock_groups -asynchronous \
    -group [get_clocks write_clk] \
    -group [get_clocks read_clk]