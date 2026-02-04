class apb_slave_config extends uvm_object;
  `uvm_object_utils(apb_slave_config)
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  virtual apb_interface vif;

  bit enable_slave_vip      = 1;

  bit enable_scoreboard      = 1;
  
  bit enable_coverage        = 1;

  bit inject_addr_error      = 0;

  bit enable_wait_states     = 1;
     
  bit[`ADDR_WIDTH-1:0]legal_addr=255;

  rand bit[`ADDR_WIDTH-1:0]illegal_addr;
  constraint illegal_addr_c{ illegal_addr >= 256;}

  rand bit[2:0]MAX_WAIT;
  constraint max_wait_c{MAX_WAIT inside{[0:5]};}

      
 function new(string name="apb_slave_config");
  super.new(name);
 endfunction

  function void agt_cfg_randomize();
    if (!this.randomize())
      `uvm_fatal("SLAVE_VIP_CFG", "Failed to randomize max_wait")
 endfunction

endclass
