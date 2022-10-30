///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

interface htax_rx_interface(input clk, input rst_n);
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	parameter PORTS = `PORTS;
	parameter VC		= `VC;
	parameter WIDTH	=	`WIDTH;

	logic [VC-1:0] 	rx_vc_req;
	logic [VC-1:0] 	rx_vc_gnt;
	logic [WIDTH-1:0] rx_data;
	logic [VC-1:0] 	rx_sot;
	logic 					rx_eot;
	logic 					tran_on=0;

always @(|rx_vc_req) begin
	wait (tran_on==0);
		@(posedge clk);
  	rx_vc_gnt=rx_vc_req;
end

always @(posedge (|rx_sot))
	tran_on=1;

always @(negedge rx_eot)
	tran_on=0;

//ASSERTIONS

endinterface : htax_rx_interface
