acom -2008 -O3 -e 100 -protect 0 -reorder "$dsn/src/debounce_model_beh.vhd"
acom -2002 -O3 -e 100 -protect 0 -reorder "$dsn/src/debounce_rtl.vhd"
acom -2008 -O3 -e 100 -protect 0 -reorder "$dsn/src/debounce_tb.vhd"
