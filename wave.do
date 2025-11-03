onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color {Spring Green} /uart_tx_top/tb/clk
add wave -noupdate /uart_tx_top/tb/rst_n
add wave -noupdate -height 30 -expand -group Transmission -color Magenta /uart_tx_top/tb/tx_start
add wave -noupdate -height 30 -expand -group Transmission -color Cyan /uart_tx_top/tb/tx_busy
add wave -noupdate -height 25 -expand -group DATA -radix binary /uart_tx_top/tb/data_in
add wave -noupdate -height 25 -expand -group DATA /uart_tx_top/tb/tx
add wave -noupdate -height 25 -expand -group Parity /uart_tx_top/tb/parity_en
add wave -noupdate -height 25 -expand -group Parity -color Goldenrod /uart_tx_top/tb/even_parity
add wave -noupdate -height 25 -expand -group Parity -color Yellow /uart_tx_top/tb/parity_bit
add wave -noupdate -height 25 -expand -group Checkers -radix binary /uart_tx_top/tb/expected_data
add wave -noupdate -height 25 -expand -group Checkers -radix binary /uart_tx_top/tb/actual_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19629 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {19580 ns} {19890 ns}
