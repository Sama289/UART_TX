vlib work

vlog *.*v +define +DEBUG_STIM +cover -covercells
vsim -voptargs=+acc work.uart_tx_top -cover

coverage exclude -src uart_tx.v -line 77 -code s
coverage exclude -src uart_tx.v -line 78 -code s
coverage exclude -src uart_tx.v -line 79 -code s
coverage exclude -src uart_tx.v -line 76 -code b
coverage exclude -du uart_tx -ftrans state START->IDLE
coverage exclude -du uart_tx -ftrans state DATA->IDLE
coverage exclude -du uart_tx -ftrans state PARITY->IDLE



coverage save cov.ucdb -onexit 

do wave.do
run -all 

vcover report cov.ucdb -details -all -annotate -output Code_Coverage_Report.txt


