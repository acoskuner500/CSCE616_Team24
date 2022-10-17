///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

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

//TO DO : ASSERTIONS

   // --------------------------- 
   // tx_outport_req is one-hot 
   // --------------------------- 
   property tx_outport_req_one_hot;
      @(posedge clk) disable iff(!rst_n)
      (|tx_outport_req) |-> $onehot(tx_outport_req);
   endproperty

   assert_tx_outport_req_one_hot : assert property(tx_outport_req_one_hot)
   else
      $error("HTAX_TX_INF ERROR : tx_outport request is not one hot encoded");

   // ----------------------------------- 
   // no tx_outport_req without tx_vc_req
   // ----------------------------------- 
   


   // ----------------------------------- 
   // no tx_vc_req without tx_outport_req
   // ----------------------------------- 



   // ----------------------------------- 
   // tx_vc_gnt is subset of vc_request
   // ----------------------------------- 



   // ------------------------------------ 
   // no tx_sot without previous tx_vc_gnt 
   // ------------------------------------ 



   // ------------------------------------ 
   // no tx_eot without previous tx_vc_gnt 
   // ------------------------------------ 



   // ------------------------------------------- 
   // tx_eot is asserted for a single clock cycle 
   // ------------------------------------------- 



   // ------------------------------------------------------------- 
   // tx_release_gnt for pkt(t) one clock cycle or same clock cycle with tx_eot of pkt(t)
   // ------------------------------------------------------------- 



   // ------------------------------------------------------------- 
   // No tx_sot of p(t+1) without tx_eot for p(t)
   // ------------------------------------------------------------- 



   // ------------------------------------------------------------- 
   // Valid packet transfer – rise of tx_outport_req followed by a tx_vc_gnt followed by tx_sot
	 // followed by tx_release_gnt followed by tx_eot. Consider the right timings between each event.
   // ------------------------------------------------------------- 



endinterface : htax_tx_interface
