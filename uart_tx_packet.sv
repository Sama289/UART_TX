package uart_tx_packet_pkg;
	import uart_tx_enum_pkg::*;

	class uart_tx_packet;

		static int total_count = 0; // to total_count created objects of this class 
		int id;

		// for stimulus 
		rand bit rst_n ;
		rand bit [7:0] data_in;
		rand parity_e  parity_mode; 
		rand logic 	   parity_en, even_parity;
	    rand logic     tx_start;

		//rand states_e state;
		
		//-------------------------------
		//--------- Constrain -----------
		//-------------------------------


		// 1) Data :: 
		constraint data_in_c {
			data_in dist {8'h00:= 5 , 8'hff:= 5, [8'd1 : (8'hff -1)]:/ 90 };
		}

		// 2) Parity :: 
		constraint partity_c {
			parity_en dist { 1:= 80 , 0:= 30};
			parity_mode dist  {
				NO_PARITY := 40,
        		EVEN      := 30,
        		ODD       := 10
        	};
		}

		// 3) Reset :: 
		constraint rst_c {
        	rst_n dist {1:/ 95 , 0:/ 5};
    	}

		// 4) Start Flag :: 
    	constraint tx_start_c {
        	tx_start dist{1:/ 50 ,0:/ 50};
    	}

		function void post_randomize();
			if (parity_mode == NO_PARITY)  begin
				parity_en = 0 ;
				even_parity = 0 ;
			
			end
			else if (parity_mode == EVEN) begin
				parity_en = 1 ; 
				even_parity = 1 ;
			end
			else if (parity_mode == ODD) begin
				parity_en = 1 ; 
				even_parity = 0 ;
			end

		endfunction

		//-----------------------------------------
		//-------------- Covergroups --------------
		//-----------------------------------------

		covergroup cg;
			
			cp_normal_data_in : coverpoint data_in {
				bins Normal_vals_odd  = {[1:255]} with (item % 2 == 1);
				bins Normal_vals_even = {[0:254]} with (item % 2 == 0);
			}

			cp_corner_data_in :coverpoint data_in {
				bins all_ONES  = {8'hff};
				bins all_ZEROS = {8'h00};
			}

			cp_rst : coverpoint rst_n {
				bins rst_n_active 	  = (1 => 0);
				bins rst_n_NOT_active = (0 => 1);

			}

			cp_tx_start : coverpoint tx_start {
				bins one_to_zero = (1=>0);
			}

			cp_parity : coverpoint parity_mode {
				bins no_parity   = {NO_PARITY};
				bins even_parity = {EVEN};
				bins odd_parity  = {ODD};

			}

		endgroup : cg
			
		//-----------------------------------------
		//--------- Tasks and Functions -----------
		//-----------------------------------------

		// to keep count and tracking the number of objects created from this class :)
		function new();
			id = total_count++;
			$display(" Created Object ID = %0d ; Obj_total_counts = %0d", id, total_count);
			cg = new();
		endfunction 

		// The Recommended Print task, should help in displaying the stimulus values in the packet
		function void  print();
    		$display("Sending Data in : %0b | Parity Enable mode : %0d Parity: %s", data_in, parity_en, parity_mode.name());
  		endfunction

	endclass

endpackage