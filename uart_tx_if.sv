interface uart_tx_if (input bit clk);

    bit        rst_n;
    logic      tx_start;
    logic [7:0]data_in;
    logic      parity_en;     // 1 = enable parity
    logic      even_parity;   // 1 = even; 0 = odd
    logic      tx;
    logic      tx_busy;
	
	//modport dut(input clk, rst_n, tx_start, data_in, parity_en, even_parity, output tx, tx_busy);
	modport tb (output tx_start, data_in, parity_en, even_parity, input clk, rst_n, tx, tx_busy);

endinterface