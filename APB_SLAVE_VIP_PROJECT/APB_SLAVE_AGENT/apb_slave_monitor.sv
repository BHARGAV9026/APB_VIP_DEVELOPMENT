class apb_slave_monitor extends uvm_monitor;

  `uvm_component_utils(apb_slave_monitor)

  uvm_analysis_port #(apb_slave_transaction) mon_port;
  virtual apb_interface intfh;
  apb_slave_transaction apb_slv_txn;
  apb_slave_config apb_slv_cfgh;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
    mon_port = new("mon_port",this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       apb_slv_txn = apb_slave_transaction::type_id::create("apb_slv_txn");

       apb_slv_cfgh=apb_slave_config::type_id::create("apb_slv_cfgh");
	if(!uvm_config_db #(apb_slave_config)::get(this,"","apb_slave_config",apb_slv_cfgh)) begin
	  `uvm_fatal("APB_AGT_CFG","cannot get apb_slave_config in apb_slave_monitor_cb class")
        end

      endfunction

   function void connect_phase(uvm_phase phase);
        intfh=apb_slv_cfgh.vif;
   endfunction

   task run_phase(uvm_phase phase);
    forever
           begin
              collect_data();
            end
   endtask
 
  task collect_data();
      @(posedge intfh.PCLK);
     if(intfh.monitor_cb.PSELx && intfh.monitor_cb.PENABLE && intfh.monitor_cb.PREADY) begin
       

    if(intfh.monitor_cb.PWRITE) begin
      apb_slv_txn.PRESETn  = intfh.PRESETn;
      apb_slv_txn.PADDR    = intfh.monitor_cb.PADDR;
      apb_slv_txn.PWRITE   = intfh.monitor_cb.PWRITE;
      apb_slv_txn.PSELx    = intfh.monitor_cb.PSELx;
      apb_slv_txn.PENABLE  = intfh.monitor_cb.PENABLE;
      apb_slv_txn.PREADY   = intfh.monitor_cb.PREADY;
      apb_slv_txn.PSLVERR  = intfh.monitor_cb.PSLVERR;
      apb_slv_txn.PWDATA   = intfh.monitor_cb.PWDATA;
      apb_slv_txn.PRDATA   = intfh.monitor_cb.PRDATA;

      apb_slv_txn.apb_write_paddr    = intfh.monitor_cb.apb_write_paddr;
      apb_slv_txn.apb_read_paddr     = intfh.monitor_cb.apb_read_paddr;
      apb_slv_txn.apb_write_data     = intfh.monitor_cb.apb_write_data;
      apb_slv_txn.apb_read_data_out  = intfh.monitor_cb.apb_read_data_out;
      apb_slv_txn.READ_WRITE         = intfh.monitor_cb.READ_WRITE;
      apb_slv_txn.transfer           = intfh.monitor_cb.transfer;

   end 

   else begin
      apb_slv_txn.PRESETn  = intfh.PRESETn;
      apb_slv_txn.PADDR    = intfh.monitor_cb.PADDR;
      apb_slv_txn.PWRITE   = intfh.monitor_cb.PWRITE;
      apb_slv_txn.PSELx    = intfh.monitor_cb.PSELx;
      apb_slv_txn.PENABLE  = intfh.monitor_cb.PENABLE;
      apb_slv_txn.PREADY   = intfh.monitor_cb.PREADY;
      apb_slv_txn.PSLVERR  = intfh.monitor_cb.PSLVERR;
      apb_slv_txn.PWDATA   = intfh.monitor_cb.PWDATA;
      apb_slv_txn.PRDATA   = intfh.monitor_cb.PRDATA;

      apb_slv_txn.apb_write_paddr    = intfh.monitor_cb.apb_write_paddr;
      apb_slv_txn.apb_read_paddr     = intfh.monitor_cb.apb_read_paddr;
      apb_slv_txn.apb_write_data     = intfh.monitor_cb.apb_write_data;
      apb_slv_txn.apb_read_data_out  = intfh.monitor_cb.apb_read_data_out;
      apb_slv_txn.READ_WRITE         = intfh.monitor_cb.READ_WRITE;
      apb_slv_txn.transfer           = intfh.monitor_cb.transfer;
   end
        mon_port.write(apb_slv_txn);
           `uvm_info(get_type_name(),$sformatf("Printing from APB_MONITOR: %s",apb_slv_txn.sprint()),UVM_LOW)
  end
    endtask

endclass


