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
   property no_tx_outport_req_wo_tx_vc_req;
      @(posedge clk) disable iff (!rst_n)
      tx_outport_req |-> tx_vc_req;
   endproperty
   
   assert_no_tx_outport_req_wo_tx_vc_req : assert property(no_tx_outport_req_wo_tx_vc_req)
   else
      $error("HTAX_TX_INF ERROR : tx_outport_req asserted without tx_vc_req");

   // ----------------------------------- 
   // no tx_vc_req without tx_outport_req
   // ----------------------------------- 
   property no_tx_vc_req_wo_tx_outport_req;
      @(posedge clk) disable iff (!rst_n)
      tx_vc_req |-> tx_outport_req;
   endproperty
   
   assert_no_tx_vc_req_wo_tx_outport_req : assert property(no_tx_vc_req_wo_tx_outport_req)
   else
      $error("HTAX_TX_INF ERROR : tx_vc_req asserted without tx_outport_req");

   // ----------------------------------- 
   // tx_vc_gnt is subset of vc_request
   // ----------------------------------- 
   property tx_vc_gnt_subest_tx_vc_req;
      @(posedge clk) disable iff (!rst_n)
      (|tx_vc_req) |-> (tx_vc_req | tx_vc_gnt == tx_vc_req);
   endproperty

   assert_tx_vc_gnt_subest_tx_vc_req : assert property(tx_vc_gnt_subest_tx_vc_req)
   else
      $error("HTAX_TX_INF ERROR : tx_vc_gnt is not a subset of tx_vc_req");

   // ------------------------------------ 
   // no tx_sot without previous tx_vc_gnt 
   // ------------------------------------ 
   property no_tx_sot_wo_prev_tx_vc_gnt;
      @(posedge clk) disable iff (!rst_n)
      (|tx_vc_gnt) |-> ##1 (|tx_sot);
   endproperty

   assert_no_tx_sot_wo_prev_tx_vc_gnt : assert property(no_tx_sot_wo_prev_tx_vc_gnt)
   else
      $error("HTAX_TX_INF ERROR : tx_sot asserted without previous tx_vc_gnt");
   
   // ------------------------------------ 
   // no tx_eot without previous tx_vc_gnt 
   // ------------------------------------ 
   property no_tx_eot_wo_prev_tx_vc_gnt;
      @(posedge clk) disable iff (!rst_n)
      (|tx_vc_gnt) |-> ##[2:$] tx_eot;
   endproperty

   assert_no_tx_eot_wo_prev_tx_vc_gnt : assert property(no_tx_eot_wo_prev_tx_vc_gnt)
   else
      $error("HTAX_TX_INF ERROR : tx_eot asserted without previous tx_vc_gnt");

   // ------------------------------------------- 
   // tx_eot is asserted for a single clock cycle 
   // ------------------------------------------- 
   property tx_eot_one_cycle;
      @(posedge clk) disable iff (!rst_n)
      tx_eot |-> ##1 (!tx_eot);
   endproperty

   assert_tx_eot_one_cycle : assert property(tx_eot_one_cycle)
   else
      $error("HTAX_TX_INF ERROR : tx_eot is not asserted for a single clock cycle");

   // ------------------------------------------------------------- 
   // tx_release_gnt for pkt(t) one clock cycle or same clock cycle with tx_eot of pkt(t)
   // ------------------------------------------------------------- 
   property tx_release_gnt_before_tx_eot;
      @(posedge clk) disable iff (!rst_n)
      (|tx_release_gnt) |-> ##[0:1] tx_eot;
   endproperty

   assert_tx_release_gnt_before_tx_eot : assert property(tx_release_gnt_before_tx_eot)
   else
      $error("HTAX_TX_INF ERROR : tx_release_gnt is not asserted before or during tx_eot");

   // ------------------------------------------------------------- 
   // No tx_sot of p(t+1) without tx_eot for p(t)
   // ------------------------------------------------------------- 
   property tx_sot_after_prev_tx_eot;
      @(posedge clk) disable iff (!rst_n)
      (|tx_sot) |-> ##[1:$] $past(tx_eot);
   endproperty

   assert_tx_sot_after_prev_tx_eot : assert property(tx_sot_after_prev_tx_eot)
   else
      $error("HTAX_TX_INF ERROR : tx_sot for next packet asserted before tx_eot for previous packet");

   // ------------------------------------------------------------- 
   // Valid packet transfer – rise of tx_outport_req followed by a tx_vc_gnt followed by tx_sot
	 // followed by tx_release_gnt followed by tx_eot. Consider the right timings between each event.
   // ------------------------------------------------------------- 
   property valid_pkt_transfer;
      @(posedge clk) disable iff (!rst_n)
      (|tx_outport_req) |-> ##[1:$] (|tx_vc_gnt) ##[1:$] (|tx_sot) ##[0:$] (|tx_release_gnt) ##[1:$] tx_eot;
   endproperty

   assert_valid_pkt_transfer : assert property(valid_pkt_transfer)
   else
      $error("HTAX_TX_INF ERROR : transmission does not follow the correct order of assertion: tx_outport_req + tx_vc_req, tx_vc_gnt, tx_sot, tx_release_gnt, tx_eot");

endinterface : htax_tx_interface
