//-----------------------
// Write assertions for a simple Round Robin arbiter that takes say 3 requests 
// Req1, Req2, Req3 and  provides Gnt1/2/3  in arbitration order
//-----------------------
interface rr_arb_sva;

//Clk and Reset (active low)
logic clk;
logic resetn;

//3 Requests to Arbiter
logic req1;
logic req2;
logic req3;

//Gnt outputs from Arbiter
logic gnt1;
logic gnt2;
logic gnt3;

//Delay for REQ assertion to GNT assertion from Arbiter
parameter  REQ2GNT = 2; 



//------------------------------------------------------
//Immediate Assertion - Check for violations at any given time
//------------------------------------------------------

//Rule1: Arbiter should assert only one of the grant signals at any given time
assert_only1_grant: assert ( $isonehot({gnt1,gnt2,gnt3}) )  
                    else begin
                     $error("More than one grant asserted in same time");
                    end

//Rule2: If not in Reset - none of  gnt1/2/3 should be X/Z
always @ (posedge clk) begin
  if (!resetn) begin
     assert_gnt_check_x: assert (not(isunknown({gnt1,gnt2,gnt3})))
                         else begin
			   $error("Gnt1/2/3 going X ");
			 end
     
  end
end


//----------------------------------------------------
//Concurrent Assertion - Check for violations  of rule across cycles
//------------------------------------------------------
//Rule1: Req1/2/3  going high shoul be followed by Grant1/2/3 after "REQ2GNT" delay cycles
property  req2gnt (req, gnt)
  @(posedge clk) req ## REQ2GNT  gnt;
endproperty

//Req1 is high => Gnt1 should be seen in next REQ2GNT cycles
req1gnt_asert: assert property  req2gnt (req1, gnt1) 
               else begin
	          $error("gnt1 not seen 2 cycles after req1");
	       end

req2gnt_asert: assert property  req2gnt (req2 & !req1, gnt2) 
               else begin
	          $error("gnt2 not seen 2 cycles after req2 when req1 is zero");
	       end

req3gnt_asert: assert property  req2gnt (req3 & !req2 & !req1, gnt3) 
               else begin
	          $error("gnt3 not seen 2 cycles after req3 when req1 and req2 is zero");
	       end


endinterface
