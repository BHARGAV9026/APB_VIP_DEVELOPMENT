class apb_slave_transaction extends uvm_sequence_item;
     bit PCLK;
     bit PRESETn;
     bit [`ADDR_WIDTH-1:0]PADDR;
     bit       PSELx;
     bit       PENABLE;
     bit       PWRITE;
     bit [`DATA_WIDTH-1:0]PWDATA,apb_read_data_out;
rand bit       PREADY;
rand bit       PSLVERR;
rand bit [`DATA_WIDTH-1:0]PRDATA;
rand bit [`ADDR_WIDTH-1:0]apb_write_paddr;
rand bit [`ADDR_WIDTH-1:0]apb_read_paddr;
rand bit [`DATA_WIDTH-1:0]apb_write_data;
rand bit  READ_WRITE,transfer;

//rand int unsigned MAX_WAIT; 

 //constraint wait_for_PREADY {MAX_WAIT inside {[0:5]};}
// constraint data_c {apb_write_data inside {[0:50]};}



		function new(string name ="");
				super.new(name);
		endfunction

		`uvm_object_utils_begin(apb_slave_transaction)
		`uvm_field_int(PADDR,UVM_ALL_ON);
		`uvm_field_int(PSELx,UVM_ALL_ON);
		`uvm_field_int(PENABLE,UVM_ALL_ON);
		`uvm_field_int(PWRITE,UVM_ALL_ON);
		`uvm_field_int(PWDATA,UVM_ALL_ON);
		`uvm_field_int(PRDATA,UVM_ALL_ON);
		`uvm_field_int(PREADY,UVM_ALL_ON);
		`uvm_field_int(PSLVERR,UVM_ALL_ON);
        `uvm_field_int(READ_WRITE,UVM_ALL_ON);
	    `uvm_field_int(apb_read_paddr,UVM_ALL_ON);
        `uvm_field_int(apb_write_paddr,UVM_ALL_ON);
		`uvm_field_int(apb_write_data,UVM_ALL_ON);
        `uvm_field_int(apb_read_data_out,UVM_ALL_ON);
        `uvm_field_int(transfer,UVM_ALL_ON);
		`uvm_object_utils_end
 
endclass

