`include "define.sv"
module apb_master (
                  input logic PCLK,PRESETn,
                  input logic PREADY,PSLVERR,
                  input logic[`DATA_WIDTH-1:0]PRDATA,
                  input logic[`ADDR_WIDTH-1:0]apb_wr_addr,apb_rd_addr,
                  input logic[`DATA_WIDTH-1:0]apb_wr_data,
                  input logic READ_WRITE,transfer,
                  output logic PENABLE,PWRITE,
                  output logic PSELx,
                  output logic[`ADDR_WIDTH-1:0]PADDR,
                  output logic[`DATA_WIDTH-1:0]PWDATA,apb_rd_data_out);

  typedef enum logic [1:0]{IDLE=2'b00,SETUP=2'b01,ACCESS=2'b10} state_t;
  state_t state,next_state;


  always@(posedge PCLK or negedge PRESETn) begin
      if(!PRESETn)
        state<=IDLE;
      else
        state<=next_state;
    end


  always@(*) begin
     if(!PRESETn)
       begin
         PSELx = 'b0;
         PENABLE = 'b0;
         PWDATA ='b0;
         PADDR ='b0;
         PWRITE='b0;
         apb_rd_data_out='b0;
       end
    else
      begin
      case(state)
      IDLE: begin
              PSELx=1'b0;
              PENABLE=1'b0;
              next_state=(transfer)? SETUP:IDLE;
             end
      SETUP:begin
               PENABLE=0;
               PSELx=1'b1;
               PWRITE=READ_WRITE;
              if(READ_WRITE)
                begin
                  PWDATA=apb_wr_data;
                  PADDR=apb_wr_addr;
               end                                  
              else
               begin
                PADDR=apb_rd_addr; 
               end
               next_state=ACCESS;
             end
ACCESS: begin
          PENABLE = 1'b1;
          PSELx   = 1'b1;
        
             if (PREADY)
               begin

                  // -------- READ --------
                  if (!READ_WRITE) 
                    begin
                       apb_rd_data_out = PRDATA;
                       if (PSLVERR)
                         begin
                           next_state = IDLE;   // error on read
                         end
                      else if (transfer) 
                         begin
                           next_state = SETUP;   // more transfers
                         end
                      else
                         begin
                          next_state = IDLE;    // done
                         end
                   end
  
                // -------- WRITE --------
                else 
                  begin
                    // PSLVERR intentionally ignored in state logic for write
                     if (transfer)
                       begin
                         next_state = SETUP;
                       end
                     else 
                       begin
                         next_state = IDLE;
                       end

                 end 
            end
          else //(PREADY == 0) : stay in ACCESS
              begin
                next_state = ACCESS;
              end
       end        
   default:next_state=IDLE;
   endcase
  end
end


////******************************************SIMULATION CHECKS/ASSERTIONS ********************************************************///

//========  default clock  ====================//
 default clocking def_clk @(posedge PCLK);
 endclocking

//=============================== verify reset ================================================//
property reset_check;
  
      !PRESETn |-> (state == IDLE)
                 && (!PWRITE)
                 && (!PSELx)
                 && (!PWDATA)
                 && (!PADDR)
                 && (!PENABLE)
;endproperty
 AST_RESET_CHECK:assert property(reset_check)
                    $display("================== A1:reset_check PASSED =================");
                 else
                    $display("================== A1:reset_check FAILED =================");



//============================= state transitions ============================================//


// 1)*************************** IDLE to SETUP ********************************//
 property idle_to_setup;
    disable iff(!PRESETn) (state==IDLE) && transfer |-> ##1 (state==SETUP);
  endproperty
 AST_IDLE_TO_SETUP :assert property(idle_to_setup)
                         $display("================== A2:idle_to_setup PASSED =================");
                      else
                       $display("================== A2:idle_to_setup FAILED =================");


// 2)************************ SETUP to ACCESS ********************************//
 property setup_to_access;
    disable iff(!PRESETn) (state==SETUP)|-> ##1 (state==ACCESS);
  endproperty
 AST_SETUP_TO_ACCESS:assert property(setup_to_access)
                         $display("================== A3:setup_to_access PASSED =================");
                      else
                          $display("================== A3:setup_to_access FAILED =================");


// 3)********************* ACCESS TO SETUP ************************************//
 property access_to_setup;
    disable iff(!PRESETn) (state==ACCESS) && (transfer && PREADY) |-> ##1 (state==SETUP);
  endproperty
 AST_ACCESS_TO_SETUP :assert property(access_to_setup)
                         $display("================== A4:access_to_setup PASSED =================");
                      else
                       $display("================== A4:access_to_setup FAILED =================");

// 4)********************** ACCESS TO IDLE 1 *************************************//
property access_to_idle_1;
    disable iff(!PRESETn) (state==ACCESS) && (!transfer && PREADY) |-> ##1 (state==IDLE);
  endproperty
 AST_ACCESS_TO_IDLE_1 :assert property(access_to_idle_1)
                         $display("================== A5_1:access_to_idle_1 PASSED =================");
                      else
                       $display("================== A5_1:access_to_idle_1 FAILED =================");


// 5)********************* ACCESS TO IDLE 2 ***************************************//
property access_to_idle_2;
    disable iff(!PRESETn) (state==ACCESS) && (PSLVERR && PREADY) |-> ##1 (state==IDLE);
  endproperty
 AST_ACCESS_TO_IDLE_2 :assert property(access_to_idle_2)
                         $display("================== A5_2:access_to_idle_2 PASSED =================");
                      else
                       $display("================== A5_2:access_to_idle_2 FAILED =================");


// 6)******************* STAY IN ACCESS *********************************************//
 property stay_in_access;
    disable iff(!PRESETn) (state==ACCESS) && (!PREADY) |-> ##1 (state==ACCESS);
  endproperty
 AST_STAY_IN_ACCESS :assert property(stay_in_access)
                         $display("================== A5_3: stay_in_access PASSED =================");
                      else
                       $display("================== A5_3: stay_in_access FAILED =================");




//======================================== check state output behaviors =====================================//

// 1)***************************** IDLE state output behavior **********************************//
 property idle_op;
     disable iff(!PRESETn) (state==IDLE) |-> (PSELx==1'b0) && (PENABLE==1'b0)                                      
  ;endproperty
 AST_IDLE_OP :assert property(idle_op)
                         $display("================== A6:idle_op PASSED =================");
                      else
                       $display("================== A6:idle_op FAILED =================");

 // 2)***************************** SETUP state output behavior **********************************//
 property setup_op;
     disable iff(!PRESETn) (state==SETUP) |-> ##0 PSELx == 1
                                              ##0 PENABLE == 0;
  endproperty
 AST_SETUP_OP :assert property(setup_op)
                         $display("================== A7:setup_op PASSED =================");
                      else
                       $display("================== A7:setup_op FAILED =================");
 
 // 3)***************************** ACCESS state output behavior **********************************//
 property access_op;
     disable iff(!PRESETn) (state==ACCESS) |-> ##0 PSELx == 1
                                               ##0 PENABLE == 1;
  endproperty
 AST_ACCESS_OP :assert property(access_op)
                         $display("================== A8:access_op PASSED =================");
                      else
                       $display("================== A8:access_op FAILED =================");


//==================================== check control,data and addr signals are stable from SETUP to ACCESS =================================//
   property stable_from_setup_to_access;
     disable iff(!PRESETn) (state==SETUP) |-> ##1 (state==ACCESS)
                                              ##0( PSELx == $past(PSELx,1))
                                              ##0( PADDR == $past(PADDR,1))
                                              ##0( PWDATA == $past(PWDATA,1))
                                              ##0( PWRITE == $past(PWRITE,1))
 ; endproperty
 AST_STABLE_FROM_SETUP_TO_ACCESS :assert property(stable_from_setup_to_access)
                                       $display("================== A9: stable_from_setup_to_access  PASSED =================");
                                  else
                                       $display("================== A9: stable_from_setup_to_access  FAILED =================");

//===================================check control,data and addr signals are stable when PREADY is not there in ACCESS ============================//

  property stable_in_access;
     disable iff(!PRESETn) (state==ACCESS) && !PREADY |-> ##1(state==ACCESS)
                                                          ##0( PSELx == $past(PSELx,1))
                                                          ##0( PENABLE == $past(PENABLE,1))
                                                          ##0( PADDR == $past(PADDR,1))
                                                          ##0( PWDATA == $past(PWDATA,1))
                                                          ##0( PWRITE == $past(PWRITE,1))
  ;endproperty

 AST_STABLE_IN_ACCESS :assert property(stable_in_access)
                                       $display("================== A10: stable_in_access  PASSED =================");
                                  else
                                       $display("================== A10: stable_in_access  FAILED =================");



//================================================= Additional checkers =========================================================================//

//********************************** check PSELx=1 in SETUP and ACCESS*****************************************//
 property pselx_high;
    disable iff(!PRESETn) (state==SETUP || state==ACCESS )|-> (PSELx == 1'b1)
 ;endproperty
AST_PSELX_HIGH:assert property(pselx_high)
                          $display("================== A11: pselx_high  PASSED =================");
                       else
                          $display("================== A11: pselx_high  FAILED =================");


//********************************* check PENABLE=1 in ACCESS ************************************************//

 property penable_high;
    disable iff(!PRESETn) (state==ACCESS) |-> (PENABLE ===1'b1);
 endproperty
AST_PENABLE_HIGH:assert property(penable_high)
                                $display("================== A12: penable_high  PASSED =================");
                             else
                                $display("================== A12: penable_high  FAILED =================");


//********************************check PWRITE is updating with READ_WRITE in SETUP state**************************************//
property pwrite_update;
   disable iff(!PRESETn) (state==SETUP) |-> (PWRITE == READ_WRITE);
endproperty
AST_PWRITE_UPDATE:assert property(pwrite_update)
                                 $display("================== A13: pwrite_update  PASSED =================");
                              else
                                 $display("================== A13: pwrite_update  FAILED =================");

//***************************** check PADDR is updated with apb_rd_addr,when PWRITE=0 in SETUP state **************************//
property read_paddr_update;
   disable iff(!PRESETn) (state==SETUP) && (PWRITE == 0) |-> (PADDR == apb_rd_addr);
endproperty
AST_READ_PADDR_UPDATE:assert property(read_paddr_update)
                                 $display("================== A14: read_paddr_update  PASSED =================");
                              else
                                 $display("================== A14: read_paddr_update  FAILED =================");

//***************************** check PADDR is updated with apb_wr_addr,when PWRITE=1 in SETUP state **************************//
property write_paddr_update;
   disable iff(!PRESETn) (state==SETUP) && (PWRITE == 1) |-> (PADDR == apb_wr_addr);
endproperty
AST_WRITE_PADDR_UPDATE:assert property(write_paddr_update)
                                 $display("================== A15: write_paddr_update  PASSED =================");
                              else
                                 $display("================== A15: write_paddr_update  FAILED =================");

//*************************** check PADDR,PWRITE and PWDATA are known and valid in the SETUP state ********************************//
 property valid_info_in_setup;
   disable iff(!PRESETn) (state==SETUP)  |-> ( !$isunknown(PADDR) && !$isunknown(PWDATA) && !$isunknown(PWRITE));
endproperty
AST_VALID_INFO_IN_SETUP : assert property(valid_info_in_setup)
                                 $display("================== A16: valid_info_in_setup  PASSED =================");
                              else
                                 $display("================== A16: valid_info_in_setup  FAILED =================");

//************************** check if a transaction completed in ACCESS, master must have PSELx and PENABLE *************************//
 property trans_done;
   disable iff(!PRESETn) (state==ACCESS) && PREADY  |-> (PSELx==1) && (PENABLE ==1);
endproperty
AST_TRANS_DONE : assert property(trans_done)
                                 $display("================== A17: trans_done  PASSED =================");
                              else
                                 $display("================== A17: trans_done  FAILED =================");


//************************ check if apb_rd_data_out is updated with PRDATA after the read transfer*************************************//

property apb_rd_data_out_update;
   disable iff(!PRESETn) (state==ACCESS) && (PREADY == 1) && (PWRITE==0) |-> (apb_rd_data_out == PRDATA );
endproperty
AST_APB_RD_DATA_OUT_UPDATE : assert property(apb_rd_data_out_update)
                                 $display("================== A18: apb_rd_data_out_update  PASSED =================");
                              else
                                 $display("================== A18: apb_rd_data_out_update  FAILED =================");

//************************ check apb_rd_data_out is stable,if PREADY=0 in SETUP state ************************************************//

property apb_rd_data_out_stable;
   disable iff(!PRESETn || PREADY) (state==ACCESS) && (PWRITE==0) &&(!PRDATA)|-> ##1 (apb_rd_data_out == $past(apb_rd_data_out,1));
endproperty
AST_APB_RD_DATA_OUT_STABLE : assert property(apb_rd_data_out_stable)
                                 $display("================== A19: apb_rd_data_out_stable  PASSED =================");
                              else
                                 $display("================== A19: apb_rd_data_out_stable  FAILED =================");

endmodule

