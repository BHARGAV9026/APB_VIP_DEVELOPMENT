class apb_master_sequence extends uvm_sequence #(apb_master_transaction);
   `uvm_object_utils(apb_master_sequence)
   function new(string name="apb_master_sequence");
      super.new(name);
   endfunction
endclass
 

//----------------------------------------------------------------------------------------------------------------------------------------
// ---------------------------  Single Write Sequence ------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------------
class apb_single_write_seq extends apb_master_sequence;
  `uvm_object_utils(apb_single_write_seq)
 
  function new(string name = "apb_single_write_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");

    start_item(xtn);
 
    xtn.pwrite = 1;          // write
    xtn.paddr  = 32'h1c;     // example addr
    xtn.pwdata = 32'hbaba;   // example data
    //xtn.pselx = 1'b1;
    
    finish_item(xtn);
    
   `uvm_info("SINGLE_WRITE", $sformatf("Single write: pselx=%0d | paddr=0x%0h | pwdata=0x%0h |",xtn.pselx, xtn.paddr, xtn.pwdata), UVM_LOW)
  endtask
endclass



//------------------------------------------------------------------------------------------------------------------------------------------------
//----------------- Single Read Sequence----------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------------------
class apb_single_read_seq extends apb_master_sequence;
  `uvm_object_utils(apb_single_read_seq)
 
  function new(string name = "apb_single_read_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");

    start_item(xtn);

    xtn.pwrite = 0;      // read
    xtn.paddr  = 32'h1c; // example addr 
    //xtn.pselx = 1'b1;
    xtn.pwdata = 32'd0;
   finish_item(xtn);

    `uvm_info("SINGLE_READ", $sformatf("Single read: pselx=%0d | paddr=0x%0h |",xtn.pselx, xtn.paddr), UVM_LOW)
  endtask
endclass
 

 
//-----------------------------------------------------------------------------------------------------------------------------------------------------
//-----------------Single Random Write Sequence -------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------
class apb_single_random_write_seq extends apb_master_sequence;
  `uvm_object_utils(apb_single_random_write_seq)
 
  function new(string name = "apb_single_random_write_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("rand_wr_txn");

    start_item(xtn);
    // paddr must be 0–255 but pwdata is full 32-bit random
    assert(xtn.randomize() with {  pwrite == 1;
                                   //pselx == 1;
                                   paddr inside {[0:255]}; // No limit on pwdata → 32-bit fully random
                                  }); 
    finish_item(xtn);

     `uvm_info("SINGLE_RAND_WRITE",$sformatf("Random single WRITE: paddr=0x%0h | pwdata=0x%08h |",xtn.paddr, xtn.pwdata),UVM_LOW)

  endtask
endclass

//---------------------------------------------------------------------------------------------------------------------------------------------------
//----------------Single Random Read Sequence--------------------------------------------------------------------------------------------------------
// --------------------------------------------------------------------------------------------------------------------------------------------------
class apb_single_random_read_seq extends apb_master_sequence;
  `uvm_object_utils(apb_single_random_read_seq)
 
  function new(string name = "apb_single_random_read_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");
 
    
    start_item(xtn);
    // Only constrain address
    assert(xtn.randomize() with {pwrite == 0;
                                 //pselx == 1;
                                 paddr inside {[0:255]};
                                 pwdata == 0; //unused, ignore
                                 });   
    finish_item(xtn);
    `uvm_info("SINGLE_RAND_READ",$sformatf("Random sinle READ: paddr=0x%0h", xtn.paddr), UVM_LOW)

   endtask
endclass
 
 
//---------------------------------------------------------------------------------------------------------------------------------------------------------
//-------------------- Back to Back/continous Random Write Sequence----------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------------------------------------------------------------------
 
class apb_cont_write_seq extends apb_master_sequence;
  `uvm_object_utils(apb_cont_write_seq)
 
  int unsigned num_trans = 10;

  function new(string name = "apb_cont_write_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");
 
    for (int i = 0; i < num_trans; i++) begin
      start_item(xtn);
      assert(xtn.randomize() with {  pwrite == 1;
                                     // pselx == 1;
                                     // paddr fully random (32-bit)
                                    // pwdata fully random (32-bit)
                                  });
 
      finish_item(xtn);
 
     `uvm_info("CONT_WRITE",$sformatf("WRITE[%0d]: paddr=0x%0h | pwdata=0x%0h |",i, xtn.paddr, xtn.pwdata),UVM_LOW)
    end
  endtask
endclass
 


//-----------------------------------------------------------------------------------------------------------------------------------------------------------------
//------------------Back to Back/continous Random READ Sequence----------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------------
class apb_cont_read_seq extends apb_master_sequence;
  `uvm_object_utils(apb_cont_read_seq)
 
  int unsigned num_trans = 10;
 
  function new(string name = "apb_cont_read_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");
 
    for (int i = 0; i < num_trans; i++) begin
      start_item(xtn);
      assert(xtn.randomize() with {pwrite == 0;
                                   //pselx  == 1;
                                   pwdata == 0;
                                   paddr inside{[0:255]};
                                  });
      finish_item(xtn);
 
      `uvm_info("CONT_READ", $sformatf("READ[%0d]: paddr=0x%0h", i, xtn.paddr), UVM_LOW)
    end
  endtask
endclass


//-------------------------------------------------------------------------------------------------------------------------------------------------
//---------------------mixed write and read Sequence-----------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------------------
 
class apb_write_read_seq extends apb_master_sequence;;
  `uvm_object_utils(apb_write_read_seq)
 
  int unsigned num_trans = 10;
  rand bit[31:0]addr_q[$];//queue to store write paddr
 
  function new(string name = "apb_cont_read_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");
    //write random pwdata to random paddr
    for (int i = 0; i < num_trans; i++) begin
      start_item(xtn);
      assert(xtn.randomize() with {pwrite == 1;
                                   //pselx  == 1;
                                   paddr inside{[0:255]};
                                   });
            
      finish_item(xtn);
        //push the write paddr into queue
      addr_q.push_back(xtn.paddr);

     `uvm_info("WRITE", $sformatf("WRITE[%0d]: pwdata=0x%0h|paddr=0x%0h|", i, xtn.pwdata,xtn.paddr), UVM_LOW)
    end
 
 //read from the written address

   for (int i = 0; i < num_trans; i++) begin
      start_item(xtn);
 
      assert(xtn.randomize() with {pwrite == 0;
                                  // pselx  == 1;
                                   paddr == addr_q[i];
	 			    });
      finish_item(xtn);
     `uvm_info("READ", $sformatf("READ[%0d]:paddr=0x%0h", i, xtn.paddr),UVM_LOW)
     end
  endtask
endclass
 

//------------------------------------------------------------------------------------------------------------------------------------
//----------------Error Injection Sequence--------------------------------------------------------------------------------------------
// ------------------------------------------------------------------------------------------------------------------------------------

 
 class apb_error_inject_seq extends apb_master_sequence;;
  `uvm_object_utils(apb_error_inject_seq)
 
  int unsigned num_trans = 10;
  function new(string name = "apb_cont_read_seq");
    super.new(name);
  endfunction
 
  task body();
    apb_master_transaction xtn;
    xtn = apb_master_transaction::type_id::create("xtn");
 for(int i=0;i<num_trans;i++) begin
    start_item(xtn);
    assert(xtn.randomize() with { paddr inside {[256:500]};
				  pwrite==0;
			         // pselx==1;
                                });
     finish_item(xtn);
          `uvm_info("READ","***",UVM_LOW)
     end
    endtask
endclass

/*
//--------------------------------------------------------------//
//write with idle cycle insertion
//---------------------------------------------------------------//

class write_idle_insert_seq extends apb_master_sequence;
`uvm_object_utils(write_idle_insert_seq)
 bit q[6]={1,0,1,0,0,1};

function new(string name="write_idle_insert_seq");
	super.new(name);
endfunction

task body();
 req = apb_master_transaction::type_id::create("xtn");
 for(int i=0;i<=5;i=i+1) 
    begin
         start_item(req);
       	 assert(req.randomize() with {pselx==q[i];pwrite==1;paddr==q[i]*paddr;});
         finish_item(req);
    end
 endtask
endclass


//--------------------------------------------------------------//
//read with idle cycle insertion
//---------------------------------------------------------------//

class read_idle_insert_seq extends apb_master_sequence;
`uvm_object_utils(read_idle_insert_seq)
 bit q[6]={1,0,1,0,0,1};

function new(string name="read_idle_insert_seq");
	super.new(name);
endfunction

task body();
 req = apb_master_transaction::type_id::create("xtn");
 for(int i=0;i<=5;i=i+1) 
    begin
         start_item(req);
       	 assert(req.randomize() with {pselx==q[i];pwrite==0;paddr==q[i]*paddr;});
         finish_item(req);
    end
 endtask

endclass*/


 
 
 
 
 
