module pllclk (input ext_clock, output pll_clock, input nrst, output lock);
   wire core_out;
   wire bypass;

   assign bypass = 1'b0;

   SB_PLL40_CORE #(.FEEDBACK_PATH("SIMPLE"), .PLLOUT_SELECT("GENCLK"),
		   .DIVR(4'd0), .DIVF(7'd85), .DIVQ(3'd4),
		   .FILTER_RANGE(3'b001)
   ) mypll (.REFERENCECLK(ext_clock),
	    .PLLOUTGLOBAL(pll_clock), .PLLOUTCORE(core_out), .LOCK(lock),
	    .RESETB(nrst), .BYPASS(bypass));
endmodule	    

module top (
	input  crystal_clk,
	output LED0,
	output LED1,
	output LED2,
	output LED3,
	output LED4,
	output LED5,
	output LED6,
	output LED7
);

   localparam BITS = 8;
   localparam LOG2DELAY = 22;

   reg [BITS+LOG2DELAY-1:0] counter = 0;
   reg [BITS-1:0] 	    outcnt;
   wire 		    clk;

   wire      nrst, lock;

   assign nrst = 1'b1;
   
   pllclk my_pll(crystal_clk, clk, nrst, lock);
   

   always@(posedge clk) begin
      counter <= counter + 1;
      outcnt <= counter >> LOG2DELAY;
   end

   assign {LED0, LED1, LED2, LED3, LED4, LED5, LED6, LED7} = outcnt ^ (outcnt >> 1);
endmodule
