package uart_tx_enum_pkg;
	
// Parity type 
  typedef enum logic [1:0] {
    NO_PARITY = 2'd0,
    EVEN      = 2'd1,
    ODD       = 2'd2
  } parity_e;
	
endpackage : uart_tx_enum_pkg