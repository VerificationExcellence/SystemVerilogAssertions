parameter BUSIDLE = 01;
parameter BUSBUSY = 10;

module sequence_first_match;
  logic clk;
  logic frame;
  logic irdy;
  logic[1:0] state;

sequence checkBusIdle;
  (##[2:$] (frame && irdy) );
  //(frame && irdy) [*2:$];
endsequence

property first_match_idle;
 first_match(checkBusIdle)  |-> (state == BUSIDLE);
endproperty

assert property (@(posedge clk) first_match_idle) else $display("time=%0t Error in first match", $time);
cover property (@(posedge clk) first_match_idle) $display("time=%0t  first match passes", $time);

//create a test clock
initial clk=0;
always #5 clk = ~clk;

task test_sequence;
  frame=0; 
  irdy=0;
  $display("time=%0t frame=%0d irdy=%0d", $time, frame, irdy);
  repeat (5) @(posedge clk);
  //Condition 1 pass - where frame and irdy remains high for a minimum of 2 clks
  frame=1'b1;
  repeat (1) @(posedge clk);
  irdy=1'b1;
  $display("time=%t frame=%0d irdy=%0d", $time, frame, irdy);
  repeat ($urandom_range(5,10)) @(posedge clk);
  frame=1'b0; irdy=1'b0;
  $display("time=%t frame=%0d irdy=%0d", $time, frame, irdy);
  //Condition 2 fail 
  repeat (5) @(posedge clk);
  frame=1'b1;
  repeat (1) @(posedge clk);
  irdy=1'b1;
  $display("time=%t frame=%0d irdy=%0d", $time, frame, irdy);
  repeat (1) @(posedge clk);
  frame=1'b0; irdy=1'b0;
  $display("time=%t frame=%0d irdy=%0d", $time, frame, irdy);
  repeat (5) @(posedge clk);
endtask

initial begin
   test_sequence();
   test_sequence();
end

always @ (posedge clk) begin
  if((frame==1) ) begin
    state = BUSBUSY;
    $display("time=%0t state=BUSIDLE",$time);
  end else begin
    state = BUSBUSY;
    $display("time=%0t state=BUSBUSY",$time);
  end
end

endmodule
