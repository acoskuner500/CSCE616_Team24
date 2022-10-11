///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


`timescale 1ns/1ps
module top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "htax_defines.sv"
	`include "htax_packet_c.sv"
	`include "htax_seqs.sv"
	`include "htax_tx_driver_c.sv"
	`include "htax_sequencer_c.sv"
	`include "test_lib.svh"


initial begin
    `uvm_info("TOP", "Starting test", UVM_NONE)
    run_test();
    `uvm_info("TOP", "Test done", UVM_NONE)
end

endmodule
