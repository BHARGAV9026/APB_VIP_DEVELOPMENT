`include "define.sv"
interface apb_interface(input logic PCLK);
logic PRESETn;
logic transfer;
logic PSLVERR;
logic READ_WRITE;
logic[`ADDR_WIDTH-1:0]apb_write_paddr;
logic[`DATA_WIDTH-1:0]apb_write_data;
logic[`ADDR_WIDTH-1:0]apb_read_paddr;
logic[`DATA_WIDTH-1:0]apb_read_data_out;
logic PWRITE;
logic PREADY;
logic PSELx;
logic PENABLE;
logic[`ADDR_WIDTH-1:0]PADDR;
logic[`DATA_WIDTH-1:0]PWDATA;
logic[`DATA_WIDTH-1:0]PRDATA;

   clocking driver_cb@(posedge PCLK);
		   default input #1 output #1;

		   output PREADY;
		   output PSLVERR;
		   output PRDATA;
                   
		   output apb_write_paddr;
		   output apb_read_paddr;
		   output apb_write_data;
		   output READ_WRITE;
		   output transfer;

		   input  PENABLE;
		   input  PWRITE;
                   input  PSELx;
		   input  PADDR;
		   input  PWDATA;
		   input  apb_read_data_out;
		    

   endclocking



   clocking monitor_cb@(posedge PCLK);
		   default input #1 output #1;

           input PREADY;
           input PSLVERR;           
           input PRDATA;
                             
           input apb_write_paddr;
           input apb_read_paddr;   



           input apb_write_data;
           input READ_WRITE;
           input transfer;
                             
           input PENABLE;
           input PWRITE;
           input PSELx;
           input PADDR;
           input PWDATA;
           input apb_read_data_out;

   endclocking

  endinterface

