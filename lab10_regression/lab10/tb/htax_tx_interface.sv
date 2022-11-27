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

	int tran_on=0;
	always @(posedge (|tx_vc_gnt))
		tran_on=1;
	always @(negedge tx_eot)
		tran_on=0;

//ASSERTIONS
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
	property tx_outport_req_vc_req_assert;
		@(posedge clk) disable iff(!rst_n)
		$rose(|tx_outport_req) |-> ((|tx_vc_req) && (|tx_vc_req));
	endproperty

	assert_tx_outport_req_vc_req_assert : assert property(tx_outport_req_vc_req_assert)
	else
		$error("HTAX_TX_INF ERROR : tx_outport_req high without tx_vc_req");

	// ----------------------------------- 
	// no tx_vc_req without tx_outport_req
	// ----------------------------------- 
	property tx_vc_req_outport_req_assert;  
		@(posedge clk) disable iff(!rst_n)
		$rose(tx_vc_req) |-> $rose(|tx_outport_req); 
	endproperty

	assert_tx_vc_req_outport_req_assert : assert property(tx_vc_req_outport_req_assert)
	else
		$error("HTAX_TX_INF ERROR : tx_vc_req high without tx_outport_req");
		
	// ----------------------------------- 
	// tx_outport_req and tx_vc_req deasserted simultaneously
	// ----------------------------------- 
	property tx_outport_req_vc_req_deassert;
		@(posedge clk) disable iff(!rst_n)
		$fell(|tx_outport_req) |-> !((|tx_vc_req) && (|tx_vc_req));
	endproperty

	assert_tx_outport_req_vc_req_deassert : assert property(tx_outport_req_vc_req_deassert)
	else
		$error("HTAX_TX_INF ERROR : tx_outport_req fell without tx_vc_req");

	// ----------------------------------- 
	// tx_vc_req and tx_outport_req deasserted simultaneously
	// ----------------------------------- 
	property tx_vc_req_outport_req_deassert;  
		@(posedge clk) disable iff(!rst_n)
		$fell(tx_vc_req) |-> $fell(|tx_outport_req); 
	endproperty

	assert_tx_vc_req_outport_req_deassert : assert property(tx_vc_req_outport_req_deassert)
	else
		$error("HTAX_TX_INF ERROR : tx_vc_req fell without tx_outport_req");

	// ----------------------------------- 
	// tx_vc_gnt is subset of vc_request
	// ----------------------------------- 
	property tx_vc_gnt_within_tx_vc_req;
		@(posedge clk) disable iff(!rst_n)
		$rose(|tx_vc_req) |-> $rose(|tx_vc_gnt) ##[0:$] $fell(|tx_vc_gnt) within $rose(|tx_vc_req) ##[0:$] $fell(tx_vc_req);
	endproperty

	assert_tx_vc_gnt_within_tx_vc_req : assert property(tx_vc_gnt_within_tx_vc_req)
	else
		$error("HTAX_TX_INF ERROR : tx_vc_gnt is not within tx_vc_req");


	// ------------------------------------ 
	// no tx_sot without previous tx_vc_gnt 
	// ------------------------------------ 
	property tx_vc_sot_vc_gnt(int i);
		@(posedge clk) disable iff(!rst_n)
		$rose(tx_sot[i]) |-> $past(tx_vc_gnt[i]);
	endproperty 

	assert_tx_vc_sot_vc_gnt_0 : assert property(tx_vc_sot_vc_gnt(0))
	else
		$error("HTAX_TX_INF ERROR : tx_sot[0] raised without previous vc_gnt[0]");

	assert_tx_vc_sot_vc_gnt_1 : assert property(tx_vc_sot_vc_gnt(1))
	else
		$error("HTAX_TX_INF ERROR : tx_sot[1] raised without previous vc_gnt[1]");

	// ------------------------------------ 
	// no tx_eot without previous tx_vc_gnt 
	// ------------------------------------ 
	property tx_vc_eot_vc_gnt;
		@(posedge clk) disable iff(!rst_n)
		$rose(tx_eot) |-> (tran_on);
	endproperty 

	assert_tx_vc_eot_vc_gnt : assert property(tx_vc_eot_vc_gnt)
	else
		$error("HTAX_TX_INF ERROR : tx_eot raised without previous vc_gnt[0]");

	// ------------------------------------------- 
	// tx_eot is asserted for a single clock cycle 
	// ------------------------------------------- 
	property tx_eot_single_cycle;
		@(posedge clk) disable iff(!rst_n)
		$rose(tx_eot) |=> $fell(tx_eot);
	endproperty 

	assert_tx_eot_single_cycle : assert property(tx_eot_single_cycle)
	else
		$error("HTAX_TX_INF ERROR : tx_eot is not high for exactly one clock cycle");

	// ------------------------------------------------------------- 
	// tx_release_gnt one clock cycle before or same cycle as tx_eot 
	// ------------------------------------------------------------- 
	property tx_rel_gnt_tx_eot;
		@(posedge clk) disable iff(!rst_n)
		$rose(tx_release_gnt) |-> ##[0:1]  $rose(tx_eot);
	endproperty

	assert_tx_rel_gnt_tx_eot : assert property(tx_rel_gnt_tx_eot)
	else
		$error("HTAX_TX_INF ERROR : tx_release_gnt raised before transfer completes");

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

	// --------------------------- 
	// tx_sot is one-hot 
	// --------------------------- 
	property tx_sot_one_hot;
		@(posedge clk) disable iff(!rst_n)
		(|tx_sot) |-> $onehot(tx_sot);
	endproperty

	assert_tx_sot_one_hot : assert property(tx_sot_one_hot)
	else
		$error("HTAX_TX_INF ERROR : tx_sot is not one hot encoded");
endinterface : htax_tx_interface
