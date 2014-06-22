//-----------------------
// Write assertions for a simple Round Robin arbiter that takes say 4 requests 
// Req1, Req2, Req3, Req4 and  provides Gnt1/2/3  in arbitration order
//-----------------------
interface rr_arb_sva;

//Clk and Reset (active low)
logic clk;
logic resetn;

//4 Requests to Arbiter
logic req1;
logic req2;
logic req3;
logic req4;

//4 Gnt outputs from Arbiter
logic gnt1;
logic gnt2;
logic gnt3;
logic gnt4;

//Delay for REQ assertion to GNT assertion from Arbiter
parameter  REQ2GNT = 2; 


//------------------------------------------------------
//Immediate Assertion - Check for violations at any given time
//------------------------------------------------------

//Rule1: Arbiter should assert only one of the grant signals at any given time
assert ( gnt1 || gnt2 || gnt3 || grnt4)  
 else begin
   $error("More than one grant asserted in same time")
 end

//Rule2: If not in Reset - none of  gnt1/2/3/4 should be X/Z
always @ (posedge clk) begin
  if (!resetn) begin
     
  end
end


//----------------------------------------------------
//Concurrent Assertion - Check for violations  of rule across cycles
//------------------------------------------------------
//Rule1: 



endinterface
