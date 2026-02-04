class apb_master_agent extends uvm_agent;
`uvm_component_utils(apb_master_agent);

apb_master_driver apb_master_drv;
apb_master_monitor apb_master_mon;
apb_master_sequencer apb_master_seqr;
 apb_master_config apb_master_cfgh;


function new(string name="apb_master_agent", uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 	super.build_phase(phase);
           apb_master_mon=apb_master_monitor::type_id::create("apb_master_mon", this);

           if(!uvm_config_db #(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))begin
               `uvm_fatal(get_full_name, "configuration not get properly in APB_AGENT")
           end

 if(apb_master_cfgh.is_active) 
   begin
      apb_master_drv=apb_master_driver::type_id::create("apb_master_drv",this);
      apb_master_seqr=apb_master_sequencer::type_id::create("apb_master_seqr", this);
   end
endfunction


function void connect_phase(uvm_phase phase);
  if(apb_master_cfgh.is_active) 
     begin
        apb_master_drv.seq_item_port.connect(apb_master_seqr.seq_item_export);
     end
endfunction

endclass

