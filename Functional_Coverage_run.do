#vlib work
vlog *.*v +define+DEBUG_STIM +cover=f -covercells

vsim work.uart_tx_top -cover
coverage save -onexit cov.ucdb

run -all

vcover report -cvg cov.ucdb -details -all -annotate -output Functional_Coverage_Report.txt