//
// Clock Delay Range
//
// This is used where exact clock cycle delay for a signal 
// to be asserted is not available and instead variable time 
// is specified. 
// Note: This type of delay causes multi threaded behaviour 
// in assertion use /first_match/$rise/ operator to avoid this
//
// Created By: Mayur Kubavat
// 18 March 2017

module test;

	logic clock;
	logic x, y;


	property xy;
		@(posedge clock)

		x |-> ##[8:13] y;
	endproperty

	xy_p: assert property(xy)
				$display($time,,"Y asserted within timeframe..");
			else
				$display($time,,"Y did not follow X within specified timeframe!");


	// Generate Clock here 
	initial
	begin
		clock = 0;
		forever
			#10 clock = ~clock;
	end

	initial
	begin
		x = 0;
		y = 0;

		//Pass case:
		@(posedge clock);
		x = 1;

		@(posedge clock);
		x = 0; //Assert X for 1 Clock

		repeat (9)
			@(posedge clock);
		y = 1;

		@(posedge clock);
		y = 0;

		//Fail case:
		x = 1;

		@(posedge clock);
	  	x = 0;

		repeat (13)
			@(posedge clock);
		y = 1;

		@(posedge clock);
		y = 0;

		#100 $finish;
	end


endmodule //test

