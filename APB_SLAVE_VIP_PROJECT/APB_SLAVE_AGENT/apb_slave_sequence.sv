class apb_slave_sequence extends uvm_sequence#(apb_slave_transaction);
		`uvm_object_utils(apb_slave_sequence)

//class apb_sequence extends uvm_sequence #(master_txn);
 // `uvm_object_utils(apb_slave_sequence)
   bit [`ADDR_WIDTH-1:0]w_addr;
   bit [`ADDR_WIDTH-1:0]r_addr;
   bit [`DATA_WIDTH-1:0]wdata,rdata;
  
  function new(string name="apb_slave_sequence");
     super.new(name);
  endfunction
  
 endclass  
 
// ************************************  SINGLE WRITE *********************************************************************************************
 
 class master_wr_seq extends apb_slave_sequence;
   `uvm_object_utils(master_wr_seq)
    apb_slave_transaction req;

   function new(string name="master_wr_seq");
      super.new(name);
   endfunction
   
  task body();
  //`uvm_do_with(req,{req.READ_WRITE==1;req.transfer==1;req.apb_write_paddr==w_addr;req.apb_write_data==wdata;});
      req=apb_slave_transaction::type_id::create("req");

       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==1;
                                   });
       finish_item(req);

   endtask

 
 endclass


//********************************* SINGLE READ ********************************************************************************************************

 class master_rd_seq extends apb_slave_sequence;
   `uvm_object_utils(master_rd_seq)
    apb_slave_transaction req;

   function new(string name="master_rd_seq");
      super.new(name);
   endfunction
   
  task body();  
      //`uvm_do_with(req,{req.READ_WRITE==0;req.transfer==1;req.apb_read_paddr==r_addr;req.PRDATA==rdata;});
        req=apb_slave_transaction::type_id::create("req");

       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==0;
                                   apb_read_paddr inside{[0:255]};
                                   });
       finish_item(req);


   endtask

 
 endclass

//***********************************SINGLE WRITE READ  ***********************************************************************


 class master_rd_wr_seq extends apb_slave_sequence;
   `uvm_object_utils(master_rd_wr_seq)
    apb_slave_transaction req;
   
   function new(string name="master_rd_wr_seq");
      super.new(name);
   endfunction
   
   task body(); 
      req=apb_slave_transaction::type_id::create("req");
    
       //for(int i=0;i<5;i++) begin

       start_item(req);
       assert(req.randomize() with{//transfer ==1;
                                   READ_WRITE ==1;
                                   apb_write_paddr inside{[0:255]};
                                   //apb_write_data inside{[0:500]};
                                   });
       finish_item(req);
      //end


     // for(int i=0;i<5;i++) begin
       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==0;
                                   apb_read_paddr inside{[0:255]};
                                   //PRDATA inside{[0:500]};
                                   });
       finish_item(req);
     // end

    endtask
  
 endclass


//******************************** BACK TO BACK / CONTINOUS WRITE ***********************************************************************************************


 class master_cont_wr_seq extends apb_slave_sequence;
   `uvm_object_utils(master_cont_wr_seq)
    apb_slave_transaction req;
   
   function new(string name="master_cont_wr_seq");
      super.new(name);
   endfunction
   
  task body();
     // `uvm_do_with(req,{req.READ_WRITE==1;req.transfer==1;apb_write_paddr==w_addr;req.apb_write_data;});
       req=apb_slave_transaction::type_id::create("req");
    
       for(int i=0;i<10;i++) begin

       start_item(req);
       assert(req.randomize() with{//transfer == 1;
                                   READ_WRITE==1;
                                   });
       finish_item(req);
      end

   endtask
 
 endclass


//*********************************** BACK TO BACK / CONTINOUS READS ***********************************************************************************
 class master_cont_rd_seq extends apb_slave_sequence;
   `uvm_object_utils(master_cont_rd_seq)
    apb_slave_transaction req;
   
   function new(string name="master_cont_rd_seq");
      super.new(name);
   endfunction
   
  task body();
      // `uvm_do_with(req,{req.READ_WRITE==0;req.transfer==1;req.apb_read_paddr==r_addr;req.PRDATA==rdata;})
      req=apb_slave_transaction::type_id::create("req");
    
       for(int i=0;i<10;i++) begin

       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==0;
                                   apb_read_paddr inside{[0:255]};
                                   });
       finish_item(req);
      end

   endtask

 endclass



//******************************** N WRITE & N READ (with same ADDR and DATA)****************************************************************************
/* class master_same_wr_rd_seq extends apb_slave_sequence;
   `uvm_object_utils(master_same_wr_rd_seq)
    apb_slave_transaction req;
   rand  logic[`ADDR_WIDTH-1:0]addr_q[$];
   rand  logic[`ADDR_WIDTH-1:0]data_q[$];

   function new(string name="master_same_wr_rd_seq");
      super.new(name);
   endfunction
   
   task body(); 
      req=apb_slave_transaction::type_id::create("req");
    
       for(int i=0;i<10;i++) begin

       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==1;
                                   apb_write_paddr inside{[0:2]};
                                   });
       finish_item(req);

       addr_q.push_back(req.apb_write_paddr);
       data_q.push_back(req.apb_write_data);
      end


      for(int i=0;i<10;i++) begin
       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==0;
                                   apb_read_paddr == addr_q[i];
                                   PRDATA == data_q[i];
                                   });
       finish_item(req);
      end

    endtask
  
 endclass */


class master_same_wr_rd_seq extends apb_slave_sequence;
  `uvm_object_utils(master_same_wr_rd_seq)

  apb_slave_transaction req;

  // Expected memory model (Associative memory)
  logic [`DATA_WIDTH-1:0] exp_mem [logic[`ADDR_WIDTH-1:0]];
  rand  logic[`ADDR_WIDTH-1:0]addr_q[$];

  function new(string name="master_same_wr_rd_seq");
    super.new(name);
  endfunction

  task body();
    req = apb_slave_transaction::type_id::create("req");

    // --------------------------------------------------
    // WRITE PHASE
    // --------------------------------------------------
    for (int i = 0; i < 10; i++) begin
      start_item(req);
      assert(req.randomize() with{ READ_WRITE == 1;                  // WRITE
                                   apb_write_paddr inside {[0:2]}; // valid APB addr
                                  })
      finish_item(req);

      // Update expected memory (OVERWRITE if addr repeats)
            addr_q.push_back(req.apb_write_paddr);
            exp_mem[req.apb_write_paddr] = req.apb_write_data;

     `uvm_info(get_type_name(), $sformatf("WRITE: Addr=0x%0h Data=0x%0h",req.apb_write_paddr,req.apb_write_data), UVM_LOW)
    end

    // --------------------------------------------------
    // READ PHASE
    // --------------------------------------------------
    //foreach (exp_mem[apb_write_paddr]) begin
    for (int i = 0; i < 10; i++) begin
      start_item(req);
      assert(req.randomize() with {READ_WRITE == 0;             // READ
                                   apb_read_paddr == addr_q[i]; // read only written locations
                                   PRDATA == exp_mem[addr_q[i]];
                                   })     
      finish_item(req);

      end
  endtask
endclass

  
//************************************ Toggle transfer***************************************************************************************************

class toggle_transfer_seq extends apb_slave_sequence;
`uvm_object_utils(toggle_transfer_seq)
 apb_slave_transaction req;
 bit j=1;
   function new(string name="toggle_transfer_seq");
      super.new(name);
   endfunction

  task body();
       req=apb_slave_transaction::type_id::create("req");
    for(int i=0;i<5;i++)begin
       start_item(req);
       assert(req.randomize() with{transfer==j;
                                   READ_WRITE ==1;});
       finish_item(req);
    j=j+1;
  end
 endtask

endclass

//***************************** error injection ************************************************************************************************************
 class error_inject_seq extends apb_slave_sequence;
   `uvm_object_utils(error_inject_seq)
    apb_slave_transaction req;

   function new(string name="error_inject_seq");
      super.new(name);
   endfunction
   
  task body();  
      req=apb_slave_transaction::type_id::create("req");
   
     for(int i=0;i<3;i++)begin
       start_item(req);
       assert(req.randomize() with{//transfer==1;
                                   READ_WRITE ==0;
                                   apb_read_paddr inside{[256:$]};
                                   });
       finish_item(req);
     end

   endtask

 
 endclass


