///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : top.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "htax_defines.sv"
	`include "htax_packet_c.sv"

	htax_packet_c pkt, fac_pkt; //handle for class objects
 	
	bit clk=0;
	
	//Create variables to store port (4-bit) and one data packet (64-bit) 
	logic [3:0] port;
	logic [63:0] data;
	int i;
//clock definition 
initial forever #5 clk = ~clk;

initial begin
//TO-DO create two instance with above handles with instructions provided below
	pkt = new();               //system verilog instance
    fac_pkt = new();

	$display("%s", pkt.randomize() ?
					"pkt randomization succeeded!" :
					"pkt randomization failed");		//randomize pkt
	pkt.print();             						//print pkt
	drive_packet(pkt);            					//drive pkt 
    
	fac_pkt = htax_packet_c :: type_id :: create(); // UVM factory instantiation
	$display("%s", fac_pkt.randomize() ?
					"fac_pkt randomization succeeded!" :
					"fac_pkt randomization failed");        //randomize fac_pkt
	fac_pkt.print();                          		//print fac_pkt
	drive_packet(fac_pkt);                    		//drive fac_pkt

	factory.print();
	#10 $finish;
end

//TO DO complete the below task
task drive_packet (htax_packet_c pkt);
	for (i=0; i < pkt.length; i++) begin
		@(posedge clk);
		data = pkt.data[i];				//At every posedge of clk load each data packet from pkt.data to variable data
		port = 1 << pkt.dest_port;		//The whole time the bit of variable port equal to pkt.dest_port is 1 and rest bits are 0
	end

	@(posedge clk);
    port = 4'bx; 
	data = 64'bx;    //Assign port = 4'bx and data = 64'bx after the last data packet
endtask : drive_packet
endmodule
