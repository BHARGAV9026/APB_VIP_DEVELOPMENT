class apb_slave_environment extends uvm_env;
		`uvm_component_utils(apb_slave_environment);
		
	        apb_slave_agent apb_slv_agt;
		apb_slave_scoreboard apb_slv_scrb;
	//	apb_coverage cov;
		 apb_slave_config apb_slv_cfgh;

		function new(string name="apb_slave_environment",uvm_component parent);
			super.new(name,parent);
		endfunction

		function void build_phase(uvm_phase phase);
			      super.build_phase(phase);
                              apb_slv_cfgh=apb_slave_config::type_id::create("apb_slv_cfgh");

                              if(!uvm_config_db#(apb_slave_config)::get(this,"*","apb_slave_config",apb_slv_cfgh))
                                `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_slave_agent class")

                              if(apb_slv_cfgh.enable_scoreboard)begin
				apb_slv_scrb = apb_slave_scoreboard::type_id::create("apb_slv_scrb",this);
                              end
                               
                              if(apb_slv_cfgh.enable_slave_vip)begin
				apb_slv_agt = apb_slave_agent::type_id::create("apb_slv_agt",this);
                              end
                endfunction

		function void connect_phase(uvm_phase phase);
				super.connect_phase(phase);
		apb_slv_agt.apb_slv_mon.mon_port.connect(apb_slv_scrb.scb_imp.analysis_export);
               // apb_slv_agt.mon.mon_port.connect(cov.analysis_export);    
		endfunction

endclass


