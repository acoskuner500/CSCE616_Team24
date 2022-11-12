interface htax_tx_interface (input clk, rst_n);

  import uvm_pkg::*;
  `include "uvm_macros.svh"

	parameter PORTS = `PORTS;
	parameter VC = `VC;
	parameter WIDTH = `WIDTH;
	
	logic [PORTS-1:0] tx_outport_req;
	logic [VC-1:0] 		tx_vc_req;
	logic [VC-1:0] 		tx_vc_gnt;
	logic [WIDTH-1:0]	tx_data;
	logic [VC-1:0]		tx_sot;
	logic							tx_eot;
	logic 						tx_release_gnt;

//ASSERTIONS
endinterface : htax_tx_interface
