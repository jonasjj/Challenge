acom -2008 -O0 -e 100 -protect 0 -dbg -reorder "$dsn/src/debounce_model_beh.vhd"
acom -2002 -O0 -e 100 -protect 0 -dbg -reorder "$dsn/src/debounce_rtl.vhd"
acom -2008 -O0 -e 100 -protect 0 -dbg -reorder "$dsn/src/debounce_tb.vhd"
asim -O5 +access +r +m+debounce_tb debounce_tb sim
run