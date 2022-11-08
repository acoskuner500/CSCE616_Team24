class htax_tx_monitor_c extends uvm_monitor;
	
	parameter PORTS = `PORTS;	

	`uvm_component_utils(htax_tx_monitor_c)

	uvm_analysis_port #(htax_tx_mon_packet_c)	tx_collect_port;
	
	virtual interface htax_tx_interface htax_tx_intf;
	htax_tx_mon_packet_c tx_mon_packet;
	int pkt_len;

	covergroup cover_htax_packet;
		option.per_instance = 1;
		option.name = "cover_htax_packet";


		// Coverpoint for htax packet field : destination port
		DEST_PORT : coverpoint tx_mon_packet.dest_port  {bins dest_port[] = {[0:3]};}

		// TO DO : Coverpoint for htax packet field : vc (include vc=0 in illegal bin)   
		VC: coverpoint tx_mon_packet.vc {illegal_bins b1= {0}; bins vc = {[0:$]};}
		
		// TO DO : Coverpoint for htax packet field : length (Divide range [3:63] into 16 bins)
		LENGTH: coverpoint tx_mon_packet.length { bins b7[16]= {[3:63]};}    //Change it to [] if it does not work

		// Coverpoints for Crosses

		// TO DO : DEST_PORT cross VC
		cross_DEST_PORT_VC : cross DEST_PORT, VC;

		// TO DO : DEST_PORT cross LENGTH
		cross_DEST_PORT_LENGTH : cross DEST_PORT, LENGTH;

		// TO DO : VC cross LENGTH
		cross_VC_LENGTH : cross VC, LENGTH;

	endgroup

	covergroup cover_htax_tx_intf;
    option.per_instance = 1;
    option.name = "cover_htax_tx_intf";

		// TO DO : Coverpoint for tx_outport_req: covered all the values 0001,0010,0100,1000
		c1: coverpoint htax_tx_intf.tx_outport_req{bins b1 = {1,2,4,8}; ignore_bins b2 = {0};} 
		
		// TO DO : Coverpoint for tx_vc_req: All the VCs are requested atleast once. Ignore what is not allowed, or put it as illegal
		c2: coverpoint htax_tx_intf.tx_vc_req {bins b3 = {1,2,3}; illegal_bins b4 = {0};}
                 
		// TO DO : Coverpoint for tx_vc_gnt: All the virtual channels are granted atleast once.
		c3: coverpoint htax_tx_intf.tx_vc_gnt {bins b5 = {1,2,3}; illegal_bins b6 = {0};}

	endgroup

	//constructor
	function new (string name, uvm_component parent);
		super.new(name,parent);
		tx_collect_port = new("tx_collect_port",this);
		tx_mon_packet 	= new();

		//Instance for the covergroup cover_htax_packet
		this.cover_htax_packet = new();
		//Instance for the covergroup cover_htax_tx_intf
		this.cover_htax_tx_intf = new();
	endfunction : new

  //UVM build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
		if(!uvm_config_db#(virtual htax_tx_interface)::get(this,"","tx_vif",htax_tx_intf))
			`uvm_fatal("NO_TX_VIF",{"Virtual Interface needs to be set for ", get_full_name(),".tx_vif"})
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pkt_len=0;
			
			//Assign tx_mon_packet.dest_port from htax_tx_intf.tx_outport_req
			@(posedge |htax_tx_intf.tx_vc_gnt) begin
				
				for(int i=0; i < PORTS; i++)
					if(htax_tx_intf.tx_outport_req[i]==1'b1)
						tx_mon_packet.dest_port = i;
				
				//Assign tx_vc_req to tx_mon_packet.vc
				tx_mon_packet.vc = htax_tx_intf.tx_vc_req;

				cover_htax_tx_intf.sample();       //Sample Coverage on htax_tx_intf  
			end		
					
			@(posedge htax_tx_intf.clk)
			//On consequtive cycles append htax_tx_intf.tx_data to tx_mon_packet.data[] till htax_tx_intf.tx_eot pulse
			while(htax_tx_intf.tx_eot==0) begin
					@(posedge htax_tx_intf.clk)
					tx_mon_packet.data = new[++pkt_len] (tx_mon_packet.data);
					tx_mon_packet.data[pkt_len-1]=htax_tx_intf.tx_data;
			end
			//Assign pkt_len to tx_mon_packet.length
			tx_mon_packet.length = pkt_len;
			tx_collect_port.write(tx_mon_packet);
			cover_htax_packet.sample();       //Sample Coverage on tx_mon_packet
		end
	endtask : run_phase

endclass : htax_tx_monitor_c
