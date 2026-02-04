class apb_master_monitor extends uvm_monitor;
`uvm_component_utils(apb_master_monitor);

apb_master_config apb_master_cfgh;
virtual apb3_if mon_inf;
apb_master_transaction apb_mon_txn;
uvm_analysis_port #(apb_master_transaction) apb_mon_ap;

function new(string name="apb_master_monitor", uvm_component parent);
	super.new(name,parent);
        apb_mon_ap=new("apb_mon_ap",this);
endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db#(apb_master_config)::get(this, "*", "apb_master_config", apb_master_cfgh))
`uvm_fatal(get_type_name(), "config cannot get properly") 
endfunction


function void connect_phase(uvm_phase phase);
  mon_inf=apb_master_cfgh.inf;
endfunction


task run_phase(uvm_phase phase);
forever
  begin
   collect_data();
  end
endtask

task collect_data();
    apb_mon_txn=apb_master_transaction::type_id::create("apb_mon_txn");

     @(mon_inf.apb_mon_cb);
       wait(mon_inf.apb_mon_cb.PSELx && !mon_inf.apb_mon_cb.PENABLE);
         apb_mon_txn.pselx=mon_inf.apb_mon_cb.PSELx;
         apb_mon_txn.paddr=mon_inf.apb_mon_cb.PADDR;
         apb_mon_txn.pwrite=mon_inf.apb_mon_cb.PWRITE;

    @(mon_inf.apb_mon_cb);
      wait(mon_inf.apb_mon_cb.PSELx && mon_inf.apb_mon_cb.PENABLE && mon_inf.apb_mon_cb.PREADY);
         apb_mon_txn.pready= mon_inf.apb_mon_cb.PREADY;
         apb_mon_txn.pslverr=mon_inf.apb_mon_cb.PSLVERR;
         apb_mon_txn.penable=mon_inf.apb_mon_cb.PENABLE;

           if(mon_inf.apb_mon_cb.PWRITE)
             apb_mon_txn.pwdata=mon_inf.apb_mon_cb.PWDATA;
           else
             apb_mon_txn.prdata= mon_inf.apb_mon_cb.PRDATA;
   
  `uvm_info(get_type_name(),$sformatf("Printing from APB_MASTER_MONITOR: %s",apb_mon_txn.sprint()),UVM_LOW)
  apb_mon_ap.write(apb_mon_txn);
endtask

endclass
