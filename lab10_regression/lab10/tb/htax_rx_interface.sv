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
	int 					tran_cycles_left=0;

always @(rx_vc_req) begin
	wait (tran_on==0);
		@(posedge clk);
  	rx_vc_gnt=rx_vc_req;
end

always @(posedge (|rx_sot)) begin
	tran_on=1;
	tran_cycles_left=1000;
end
   
always @(negedge rx_eot) begin
	tran_on=0;
	tran_cycles_left=0;
end
   
always @(posedge clk) begin
	if (tran_on==1) tran_cycles_left--;
end
   
//ASSERTIONS

   // ---------------------------
   // rx_eot timeout check
   // ---------------------------
   property rx_eot_timeout_check;
      @(posedge clk) disable iff(!rst_n)
      (tran_on==1) |-> (tran_cycles_left!=0);
   endproperty

   assert_eot_timeout_check : assert property(rx_eot_timeout_check)
   else
      $fatal("HTAX_RX_INF ERROR : TIMEOUT rx_eot did not occur within 1000 cycles after rx_sot");

endinterface : htax_rx_interface
