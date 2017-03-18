//
// Clock Delay Operator
// This is used to specify delay in terms of 
// Clock Cycle.
//
// Created by: Mayur Kubavat
// 18 March 2017

module test;

	logic clock;
	logic req, grnt;


	//
	// Specification:
	// For each Request there should be a Grant signal
	// after 5 clock cycle
	property send_req_when_grant;
		@(posedge clock)

		req |-> ##5 grnt;
	endproperty

	send_req_when_grant_p: assert property(send_req_when_grant)
		$display($time,,"Grant detected successfully.."); 
	else
		$display($time,,"Grant did not come for previous Request!");


	// Generate Clock here
	initial
	begin
		clock = 0;
		forever
			#10 clock = ~clock;
	end

	// Request/Grant stimulus
	initial
	begin
		req = 0;
		grnt = 0;

		// Pass case:
		#50;
		req = 1; //Assert Request for 1 Clock
		
		#20;
		req = 0;

		#80;
		grnt = 1;

		#20;
		grnt = 0;

		// Fail case:
		req = 1;
		
		#40;
		req = 0; //Assert Request for 2 Clock

		#80;
		grnt = 1;

		#20;
		grnt = 0; //Grant comes only for 1 Cycle instead of 2!


		#100 $finish;
	end

endmodule //test
