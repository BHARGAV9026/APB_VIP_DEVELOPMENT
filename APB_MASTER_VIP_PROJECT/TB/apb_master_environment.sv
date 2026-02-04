class apb_master_environment extends uvm_env;
`uvm_component_utils(apb_master_environment)

 apb_master_scoreboard apb_master_sb;
apb_master_agent apb_master_agt;
apb_master_config apb_master_cfgh;

function new(string name="apb_master_environment", uvm_component parent);
	super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
   super.build_phase(phase);
       if(!uvm_config_db #(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))begin
           `uvm_fatal(get_full_name, "configuration not get properly in APB_ENV")
       end

      if(apb_master_cfgh.enable_master_vip)begin
         apb_master_agt= apb_master_agent::type_id::create("apb_master_agt", this);
      end
     
     if(apb_master_cfgh.enable_scoreboard)begin
      apb_master_sb=apb_master_scoreboard::type_id::create("apb_master_sb",this);
     end

endfunction

function void connect_phase(uvm_phase phase);
     super.connect_phase(phase);
        if(apb_master_cfgh.enable_scoreboard)begin
            //apb_master_agt.apb_drv.apb_drv_port.connect(apb_master_sb.apb_drv_fifo.analysis_export);
              apb_master_agt.apb_master_mon.apb_mon_ap.connect(apb_master_sb.apb_mon_fifo.analysis_export);
        end
endfunction


endclass
