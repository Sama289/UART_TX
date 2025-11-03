module uart_tx_top;

	bit CLK;
	// Clock Period
	 parameter  clk_period  = 10 ;
	 parameter  High_period = 0.5 * clk_period ;
	 parameter  Low_period  = 0.5 * clk_period ;

	// Clock Frequency 100 MHz 
	always  
	   begin
	    #Low_period  CLK = ~ CLK ;
	    #High_period CLK = ~ CLK ;
	end

	uart_tx_if uart_txif(CLK);
	//uart_tx    dut (uart_txif.dut);
	uart_tx_tb tb(uart_txif.tb);

endmodule