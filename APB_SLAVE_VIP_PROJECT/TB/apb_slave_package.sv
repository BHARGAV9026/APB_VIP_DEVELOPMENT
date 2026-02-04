package apb_slave_package;

    import uvm_pkg::*;
   `include "uvm_macros.svh"
   `include "apb_slave_config.sv"
   `include "apb_slave_transaction.sv"
  
   `include "apb_slave_driver.sv"
   `include "apb_slave_monitor.sv"
   `include "apb_slave_sequencer.sv"
   `include "apb_slave_sequence.sv"
   `include "apb_slave_agent.sv"
  
   `include "apb_slave_scoreboard.sv"
   `include "apb_slave_environment.sv"
   `include "apb_slave_test.sv"

 endpackage
   
