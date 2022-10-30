///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////
	
	//Declasing analysis TX port
	`uvm_analysis_imp_decl(_tx0_export)	
	`uvm_analysis_imp_decl(_tx1_export)	
	`uvm_analysis_imp_decl(_tx2_export)	
	`uvm_analysis_imp_decl(_tx3_export)	

	//Declasing analysis RX port
	`uvm_analysis_imp_decl(_rx0_export)
	`uvm_analysis_imp_decl(_rx1_export)
	`uvm_analysis_imp_decl(_rx2_export)
	`uvm_analysis_imp_decl(_rx3_export)

class htax_scoreboard_c extends uvm_scoreboard;

	`uvm_component_utils(htax_scoreboard_c)
	
	//Registering with Factory
	uvm_analysis_imp_tx0_export #(htax_tx_mon_packet_c, htax_scoreboard_c) tx0_export;
	uvm_analysis_imp_tx1_export #(htax_tx_mon_packet_c, htax_scoreboard_c) tx1_export;
	uvm_analysis_imp_tx2_export #(htax_tx_mon_packet_c, htax_scoreboard_c) tx2_export;
	uvm_analysis_imp_tx3_export #(htax_tx_mon_packet_c, htax_scoreboard_c) tx3_export;

	uvm_analysis_imp_rx0_export #(htax_rx_mon_packet_c, htax_scoreboard_c) rx0_export;
	uvm_analysis_imp_rx1_export #(htax_rx_mon_packet_c, htax_scoreboard_c) rx1_export;
	uvm_analysis_imp_rx2_export #(htax_rx_mon_packet_c, htax_scoreboard_c) rx2_export;
	uvm_analysis_imp_rx3_export #(htax_rx_mon_packet_c, htax_scoreboard_c) rx3_export;

	//Creating queue to store the incoming TX transactions
	htax_tx_mon_packet_c port0_queue[$], port1_queue[$], port2_queue[$], port3_queue[$], cmp_pkt[4];	

	function new (string name, uvm_component parent);
		super.new(name,parent);
		tx0_export=new("tx0_export",this);
		tx1_export=new("tx1_export",this);
		tx2_export=new("tx2_export",this);
		tx3_export=new("tx3_export",this);
	
		rx0_export=new("rx0_export",this);
		rx1_export=new("rx1_export",this);
		rx2_export=new("rx2_export",this);
		rx3_export=new("rx3_export",this);
	endfunction : new

	//Write Method - TX[0] Monitor
	function void write_tx0_export(htax_tx_mon_packet_c tx_mon_packet);
		tx_mon_packet.print();
		push_to_queue(tx_mon_packet);
	endfunction : write_tx0_export

	//Write Method - TX[1] Monitor
	function void write_tx1_export(htax_tx_mon_packet_c tx_mon_packet);
		tx_mon_packet.print();
		push_to_queue(tx_mon_packet);
	endfunction : write_tx1_export

	//Write Method - TX[2] Monitor
	function void write_tx2_export(htax_tx_mon_packet_c tx_mon_packet);
		tx_mon_packet.print();
		push_to_queue(tx_mon_packet);
	endfunction : write_tx2_export

	//Write Method - TX[3] Monitor
	function void write_tx3_export(htax_tx_mon_packet_c tx_mon_packet);
		tx_mon_packet.print();
		push_to_queue(tx_mon_packet);
	endfunction : write_tx3_export

	//TO DO : Complete the code for push_to_queue function -- preferably use the SV-Case statement
	//Add incoming TX Monitor packet to corresponding queue from mon_pkt.dest_port
	function void push_to_queue(htax_tx_mon_packet_c mon_pkt);















	endfunction : push_to_queue

	//Write Method - RX[0] Monitor
	function void write_rx0_export(htax_rx_mon_packet_c rx_mon_packet);
		`uvm_info("SCOREBOARD",$sformatf("Received Data Packet on Port0:"), UVM_NONE)
		rx_mon_packet.print();
		cmp_pkt[0] = new ();
		cmp_pkt[0] = port0_queue.pop_back();
		if(cmp_pkt[0].data==rx_mon_packet.data)
			`uvm_info("SCOREBOARD","Data matches for received pkt on port 0", UVM_NONE)
		else
			`uvm_fatal("SCOREBOARD","Data mismatch for received pkt on port 0")
		`uvm_info("SCOREBOARD","Dropping pkt from queue 0", UVM_NONE)
	endfunction : write_rx0_export

	//TO DO : Write Method - RX[1] Monitor
	function void write_rx1_export(htax_rx_mon_packet_c rx_mon_packet);
		//TO DO : Create a new cmp_pkt[i]
		//				Pop the last element from queue i assign it to cmp_pkt[i]
		//				Compare the data field of cmp_pkt[i] and rx_mon_packet; Mismatch results into fatal error 






	endfunction : write_rx1_export

	//TO DO : Write Method - RX[2] Monitor
	function void write_rx2_export(htax_rx_mon_packet_c rx_mon_packet);
		//TO DO : Create a new cmp_pkt[i]
		//				Pop the last element from queue i assign it to cmp_pkt[i]
		//				Compare the data field of cmp_pkt[i] and rx_mon_packet; Mismatch results into fatal error 





	endfunction : write_rx2_export

	//TO DO : Write Method - RX[3] Monitor
	function void write_rx3_export(htax_rx_mon_packet_c rx_mon_packet);
		//TO DO : Create a new cmp_pkt[i]
		//				Pop the last element from queue i assign it to cmp_pkt[i]
		//				Compare the data field of cmp_pkt[i] and rx_mon_packet; Mismatch results into fatal error 





	endfunction : write_rx3_export

	function void check();
		`uvm_info("SCOREBOARD", "End of Simulation Checking", UVM_NONE)
		if(port0_queue.size()==0)
      `uvm_info("SCOREBOARD","Port 0 Queue is empty", UVM_NONE)
    else
      `uvm_fatal("SCOREBOARD","Port 0 Queue is non-empty at end of simulation")
		if(port1_queue.size()==0)
      `uvm_info("SCOREBOARD","Port 1 Queue is empty", UVM_NONE)
    else
      `uvm_fatal("SCOREBOARD","Port 1 Queue is non-empty at end of simulation")
		if(port2_queue.size()==0)
      `uvm_info("SCOREBOARD","Port 2 Queue is empty", UVM_NONE)
    else
      `uvm_fatal("SCOREBOARD","Port 2 Queue is non-empty at end of simulation")
		if(port3_queue.size()==0)
      `uvm_info("SCOREBOARD","Port 3 Queue is empty", UVM_NONE)
    else
      `uvm_fatal("SCOREBOARD","Port 3 Queue is non-empty at end of simulation")
	endfunction : check

endclass : htax_scoreboard_c
