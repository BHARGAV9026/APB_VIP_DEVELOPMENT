`include "define.sv"
module apb_slave (
                  input logic PCLK,PRESETn,
                  input logic PENABLE,PWRITE,
                  input logic PSELx,
                  input logic[`ADDR_WIDTH-1:0]PADDR,
                  input logic[`DATA_WIDTH-1:0]PWDATA,
                  output logic PREADY,PSLVERR,
                  output logic[`DATA_WIDTH-1:0]PRDATA);
 
bit [`DATA_WIDTH-1:0]memory[`MEM_DEPTH-1:0];
bit [$clog2(`MAX_WAIT+1)-1:0] CNT;

wire invalid_addr;
assign invalid_addr = (PADDR > 32'd255);

wire protocol_error;
assign protocol_error = (PENABLE && !PSELx);

always@(posedge PCLK or negedge PRESETn) begin
   if(!PRESETn) begin
     PSLVERR='b0;
     PREADY ='b0;
     PRDATA ='b0;
   end
 
  else
    begin
     /* if(!PSELx) begin
       PSLVERR =0;
       PREADY =0;
       PRDATA =0;
      end

     else if(PSELx && !PENABLE)begin
        PSLVERR =0;
       PREADY =0;
       PRDATA =0;
     end */
     if(protocol_error)begin
        PREADY =1;
        PSLVERR=1;
        PRDATA = 32'b0;
      end

     else if(PSELx && PENABLE) begin
       if(CNT == (`MAX_WAIT))
        begin
           // if(!PWRITE && PENABLE) 
            if(!PWRITE)
             begin
               if(!invalid_addr)
                  begin
                    PREADY =1;
                    PSLVERR =0;
                    PRDATA=memory[PADDR];
                    CNT =0;
                   end
               else  
                   begin
                     PREADY=1;
                     PSLVERR=1;
                     CNT = 0;
                     PRDATA = memory[PADDR];
                   end
             end
           // if(PWRITE && PENABLE)
           else
            begin
                PREADY =1;
                PSLVERR = 0;
                memory[PADDR]=PWDATA;
                CNT =0;
             end
        end

     else
        begin
           PREADY =0;
           PSLVERR = 0;
           PRDATA = 'b0;
           CNT = CNT+1;
        end
 
   end
 end
end
endmodule
