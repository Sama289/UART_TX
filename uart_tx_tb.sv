import uart_tx_enum_pkg::*;
import uart_tx_packet_pkg::*;

module uart_tx_tb(uart_tx_if.tb uart_txif);

	// Design signals
	    bit          clk;
	    bit          rst_n;
	    logic        tx_start;
	    logic [7:0]  data_in;
	    logic        parity_en;     // 1 = enable parity
	    logic        even_parity;   // 1 = even; 0 = odd

	    logic        tx;
	    logic 		 tx_busy;

   // bdl ma anzl a8erhom kolhom l uart_txif.signal :)
	    assign      	 clk = uart_txif.clk          ;
	    assign       	 uart_txif.rst_n        = rst_n;
	    assign      uart_txif.tx_start     = tx_start ;
	    assign      uart_txif.data_in      = data_in  ;
	    assign     uart_txif.parity_en    = parity_en ;    
	    assign    uart_txif.even_parity  = even_parity;

	    assign  uart_txif.tx =tx;
	    assign  uart_txif.tx_busy=tx_busy;

	// Testbench signals 
	
		// 11 bits = (1 Start bit) + (8 Data_in) + (1 Parity bit) + (1 Stop bit).
	    logic [10:0] expected_data;  
		logic [10:0] actual_data  ;
	    bit parity_bit;

	    // Testbench Counters
	    int pass_count;
	    int error_count;
	
	// There will be No need for Dut Instantiation , if we use the signals of interface with dut modport 
		uart_tx uut (.*);

/*	// Clock generator
  	initial begin
	    clk = 0;
	    forever #5ns clk = ~clk; // The design operates on frequency 100MHz. 

	end */ 

 // --------------------------------------------------------------
 // ------------------------Test scenarios------------------------
 // --------------------------------------------------------------

	initial begin
		uart_tx_packet pkt; 
			
		rst_n = 0;
		@(negedge clk);
		rst_n = 1;
		@(negedge clk);
		rst_n = 0;
		@(negedge clk);
		rst_n = 1;

		pkt = new();
			
		repeat (100) begin
/*			uart_tx_packet pkt; 
			pkt = new();*/
			generate_stimulus(pkt);
			golden_model(pkt);
			drive_stim(pkt);    // 1 cycle---> idle to start
			collect_output(pkt);// 10 or 11 cycle ----> idle
			check_result();
			@(negedge clk);


		end

		$display("\n --------------------------------------------------------------");
		$display(" Pass count :) = %0d | Error Count :( = %0d",  pass_count, error_count );
		$display("--------------------------------------------------------------");		
		$stop;	

	end

	//-------------------------------------------------------------------
	//----------------------- Tasks and Functions -----------------------
	//-------------------------------------------------------------------


	//-------------------------------
	//-- 1) Stimulus Generation -----
	//-------------------------------

	task automatic generate_stimulus(ref uart_tx_packet pkt);

		assert(pkt.randomize()) else $fatal("Randomization failed");
		pkt.post_randomize();
	`ifdef DEBUG_STIM
		pkt.print();
	`endif

	endtask 


	//-------------------------------
	//-- 2) Golden Model Checks -----
	//-------------------------------

	task automatic  golden_model(ref uart_tx_packet pkt);

	    expected_data[0] = 1'b0;               // Start bit
	    expected_data[1 +: 8] = pkt.data_in;   // Data bits 

	    // Compute parity bit only if parity is enabled
	    if (pkt.parity_en && pkt.parity_mode != NO_PARITY) begin

	      // Calculate XOR of all bits in data_in , odd parity = XOR data_in
	      parity_bit = ^pkt.data_in;

	      if (pkt.parity_mode == EVEN) begin
	        parity_bit = ~parity_bit;
		    expected_data[9] = parity_bit;       // Parity bit
		    expected_data[10] = 1'b1;            // Stop bit
	      end 
	      else begin
		      expected_data[9] = parity_bit;     // Parity bit 
		      expected_data[10] = 1'b1;          // Stop bit 
		  end

	    end

	    else begin
	    	expected_data[9] = 1'b1;  // stop bit
	    end

    	$display("Golden Model: Data = %0b, Parity Mode = %s, Calculated Parity Bit = %0b",pkt.data_in, pkt.parity_mode.name(), parity_bit);

	endtask 

	//-------------------------------
	//-- 3) Drive Stimulus ----------
	//-------------------------------

	task automatic  drive_stim(ref uart_tx_packet pkt);

		data_in      = pkt.data_in; 
		parity_en    = pkt.parity_en;
		even_parity  = pkt.parity_mode;
		
		tx_start     = 1;
		@(negedge clk);
		tx_start     = 0;
		pkt.cg.sample();

	endtask 

	//--------------------------------------
	//-- 5) Collecting the Output data -----
	//-------------------------------------- 

	task automatic collect_output(ref uart_tx_packet pkt);

	    int n_bits = (pkt.parity_en && pkt.parity_mode != NO_PARITY) ? 11 : 10;

	    for (int i = 0; i < n_bits; i++) begin
	        @(negedge clk);
        	actual_data[i] = tx;
	    end

	endtask

	//-------------------------------
	//-- 6) Checking Result ---------
	//-------------------------------
	
	task automatic  check_result();

		//$display("--------------------------------------------------------------");
		if (parity_en) begin // check data with parity

			if (expected_data !== actual_data) begin
				$error("Mismatch parity ! :: Expected = %0b :: Actual = %0b ", expected_data, actual_data);
				error_count ++;
			end else begin
				$display("[PASSED SUCESSFULLY ]  :: Expected = %0b :: Actual = %0b ", expected_data, actual_data);
				pass_count ++;
			end

		end 
		else begin // data without parity

			if (expected_data[9:0] !== actual_data[9:0]) begin
				$error("Mismatch no parity ! :: Expected = %0b :: Actual = %0b ", expected_data[9:0], actual_data[9:0]);
				error_count ++;
			end else begin
				$display("[PASSED SUCESSFULLY ]  :: Expected = %0b :: Actual = %0b ", expected_data[9:0], actual_data[9:0]);
				pass_count ++;
			end

		end
		$display("--------------------------------------------------------------");

	endtask 



endmodule