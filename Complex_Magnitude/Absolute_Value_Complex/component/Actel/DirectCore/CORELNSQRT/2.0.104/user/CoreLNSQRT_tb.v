// ********************************************************************/ 
// Microsemi Corporation Proprietary and Confidential 
// Copyright 2018 Microsemi Corporation.  All rights reserved.
//
// ANY USE OR REDISTRIBUTION IN PART OR IN WHOLE MUST BE HANDLED IN 
// ACCORDANCE WITH THE MICROSEMI LICENSE AGREEMENT AND MUST BE APPROVED 
// IN ADVANCE IN WRITING.  
//  
// Description: This module implements a test bench for CORELNSQRT. 
//
// Revision Information:
// Date     Description
// 07Mar18 Initial Release 
//
// SVN Revision Information:
// SVN $Revision: $
// SVN $Date: $
//
// Resolved SARs
// SAR      Date     Who   Description
//
// Notes: 
//        
// *********************************************************************/ 

`timescale 1ns/100ps

module CORELNSQRT_TB;
//=================================================================================================
// Signal declarations
//=================================================================================================
parameter SYSCLK_PERIOD               = 10;// 100MHZ
parameter G_NO_OF_ITERATIONS          = 25;


reg SYSCLK;
reg NSYSRESET;
parameter G_ARCHITECTURE             = 0;// G_ARCHITECTURE = 0, for Sequential Architecture
                                          // G_ARCHITECTURE = 1, for Pipeline Architecture
parameter G_IO_COMBINATION            = 1;// if G_IO_COMBINATION =1, then Input Width = 64 and Output Width = 32
                                          // if G_IO_COMBINATION =2, then Input Width = 48 and Output Width = 32
										  // if G_IO_COMBINATION =3, then Input Width = 36 and Output Width = 32
										  // if G_IO_COMBINATION =4, then Input Width = 32 and Output Width = 24
										  // if G_IO_COMBINATION =5, then Input Width = 24 and Output Width = 24
										  // if G_IO_COMBINATION =6, then Input Width = 18 and Output Width = 24

reg [5:0]                   i;

//=================================================================================================
// Function declarations
//=================================================================================================

function integer INPUT_WIDTH;
input integer G_IO_COMBINATION;
	if (G_IO_COMBINATION == 1)
	begin
		INPUT_WIDTH = 64;
	end
	else if (G_IO_COMBINATION == 2)
    begin
		INPUT_WIDTH = 48;
	end
	else if (G_IO_COMBINATION == 3)
    begin
		INPUT_WIDTH = 36;
	end
	else if (G_IO_COMBINATION == 4)
    begin
		INPUT_WIDTH = 32;
	end
	else if (G_IO_COMBINATION == 5)
    begin
		INPUT_WIDTH = 24;
	end
	else if (G_IO_COMBINATION == 6)
    begin
		INPUT_WIDTH = 18;
	end
	else
	begin
		INPUT_WIDTH = 32;
	end
endfunction

function integer OUTPUT_WIDTH;
input integer G_IO_COMBINATION;
	if ((G_IO_COMBINATION == 1) || (G_IO_COMBINATION == 2) || (G_IO_COMBINATION == 3))
	begin
		OUTPUT_WIDTH = 32;
	end
	else if ((G_IO_COMBINATION == 4) || (G_IO_COMBINATION == 5) || (G_IO_COMBINATION == 6))
    begin
		OUTPUT_WIDTH = 24;
	end
	else
	begin
		OUTPUT_WIDTH = 32;
	end
endfunction

parameter  G_INPUT_WIDTH                  = INPUT_WIDTH(G_IO_COMBINATION);
parameter  G_OUTPUT_WIDTH                 = OUTPUT_WIDTH(G_IO_COMBINATION);


wire  [G_INPUT_WIDTH-1 : 0] s_input_array[0 : 9];
wire  [G_OUTPUT_WIDTH-1 : 0] s_sqrt_array[0 : 9];
wire  [G_OUTPUT_WIDTH-1 : 0] s_logn_array[0 : 9];

reg t_start;
wire t_done;
reg [G_INPUT_WIDTH-1:0] t_input;
wire [G_OUTPUT_WIDTH-1:0] t_log;
wire [G_OUTPUT_WIDTH-1:0] t_sqrt;

//========================================================
// Initial Block
//========================================================
initial
begin
    SYSCLK            <= 1'b0;
    NSYSRESET         <= 1'b0;
	t_start           <= 1'b0;
end

//========================================================
// Reset pulse
//========================================================
// initial
// begin
    // #(SYSCLK_PERIOD * 10 )
        // reset_tb = 1'b1;
// end
//========================================================
// Asynchronous blocks
//========================================================
generate if((G_INPUT_WIDTH == 64) & (G_OUTPUT_WIDTH == 32)) begin
//input width = 64
// test inputs
	assign s_input_array[0]           =  64'h0000000000000064;
	assign s_input_array[1]           =  64'h00000000000003E8;
	assign s_input_array[2]           =  64'h0000000000002710;
	assign s_input_array[3]           =  64'h000000000000C350;
	assign s_input_array[4]           =  64'h00000000000186A0;
	assign s_input_array[5]           =  64'h000000000003D090;
	assign s_input_array[6]           =  64'h0000000000F42400;
	assign s_input_array[7]           =  64'h00000000FFFFFFFF;
	assign s_input_array[8]           =  64'h0000FFFFFFFFFFFF;
	assign s_input_array[9]           =  64'h7FFFFFFFFFFFFFFF;

	// test outputs
	assign s_sqrt_array[0]         =  32'h0000000A;
	assign s_sqrt_array[1]         =  32'h00000020;
	assign s_sqrt_array[2]         =  32'h00000064;
	assign s_sqrt_array[3]         =  32'h000000E0;
	assign s_sqrt_array[4]         =  32'h0000013C;
	assign s_sqrt_array[5]         =  32'h000001F4;
	assign s_sqrt_array[6]         =  32'h00000FA0;
	assign s_sqrt_array[7]         =  32'h00010000;
	assign s_sqrt_array[8]         =  32'h01000000;
	assign s_sqrt_array[9]         =  32'hB504F334;

	assign s_logn_array[0]         =  32'h000126BB;
	assign s_logn_array[1]         =  32'h0001BA18;
	assign s_logn_array[2]         =  32'h00024D76;
	assign s_logn_array[3]         =  32'h0002B477;
	assign s_logn_array[4]         =  32'h0002E0D3;
	assign s_logn_array[5]         =  32'h00031B78;
	assign s_logn_array[6]         =  32'h000425A3;
	assign s_logn_array[7]         =  32'h00058B91;
	assign s_logn_array[8]         =  32'h00085159;
	assign s_logn_array[9]         =  32'h000AEAC5;
	end
endgenerate

generate if((G_INPUT_WIDTH == 48) & (G_OUTPUT_WIDTH == 32)) begin
//input width = 48
// test inputs
	assign s_input_array[0]           =  48'h000000000040;
	assign s_input_array[1]           =  48'h000000000300;
	assign s_input_array[2]           =  48'h000000002700;
	assign s_input_array[3]           =  48'h00000000C340;
	assign s_input_array[4]           =  48'h0000000A0000;
	assign s_input_array[5]           =  48'h000001240000;
	assign s_input_array[6]           =  48'h0000FA000000;
	assign s_input_array[7]           =  48'h0001FFFFFFFF;
	assign s_input_array[8]           =  48'h03FFFFFFFFFF;
	assign s_input_array[9]           =  48'h7FFFFFFFFFFF;

	// test outputs
	assign s_sqrt_array[0]         =  32'h00000008;
	assign s_sqrt_array[1]         =  32'h0000001C;
	assign s_sqrt_array[2]         =  32'h00000064;
	assign s_sqrt_array[3]         =  32'h000000E0;
	assign s_sqrt_array[4]         =  32'h0000032A;
	assign s_sqrt_array[5]         =  32'h00001117;
	assign s_sqrt_array[6]         =  32'h0000FCFB;
	assign s_sqrt_array[7]         =  32'h00016A0A;
	assign s_sqrt_array[8]         =  32'h00200000;
	assign s_sqrt_array[9]         =  32'h00B504F3;

	assign s_logn_array[0]         =  32'h00010ADF;
	assign s_logn_array[1]         =  32'h0001A933;
	assign s_logn_array[2]         =  32'h00024D5B;
	assign s_logn_array[3]         =  32'h0002B472;
	assign s_logn_array[4]         =  32'h00035925;
	assign s_logn_array[5]         =  32'h00043118;
	assign s_logn_array[6]         =  32'h00058A0C;
	assign s_logn_array[7]         =  32'h0005B7ED;
	assign s_logn_array[8]         =  32'h0007472D;
	assign s_logn_array[9]         =  32'h000824FC;
	end
endgenerate

generate if((G_INPUT_WIDTH == 36) & (G_OUTPUT_WIDTH == 32)) begin
//input width = 36
// test inputs
	assign s_input_array[0]           =  36'h000000030;
	assign s_input_array[1]           =  36'h000000100;
	assign s_input_array[2]           =  36'h000000900;
	assign s_input_array[3]           =  36'h000001234;
	assign s_input_array[4]           =  36'h00000FA32;
	assign s_input_array[5]           =  36'h0000A0200;
	assign s_input_array[6]           =  36'h000FF0000;
	assign s_input_array[7]           =  36'h00A024000;
	assign s_input_array[8]           =  36'h0FFFFFF00;
	assign s_input_array[9]           =  36'h7FFFFFFFF;

	// test outputs
	assign s_sqrt_array[0]         =  32'h00000007;
	assign s_sqrt_array[1]         =  32'h00000010;
	assign s_sqrt_array[2]         =  32'h00000030;
	assign s_sqrt_array[3]         =  32'h00000044;
	assign s_sqrt_array[4]         =  32'h000000FD;
	assign s_sqrt_array[5]         =  32'h0000032A;
	assign s_sqrt_array[6]         =  32'h00000FF8;
	assign s_sqrt_array[7]         =  32'h0000329E;
	assign s_sqrt_array[8]         =  32'h00010000;
	assign s_sqrt_array[9]         =  32'h0002D414;

	assign s_logn_array[0]         =  32'h0000F7C1;
	assign s_logn_array[1]         =  32'h000162E4;
	assign s_logn_array[2]         =  32'h0001EF83;
	assign s_logn_array[3]         =  32'h00021C97;
	assign s_logn_array[4]         =  32'h0002C450;
	assign s_logn_array[5]         =  32'h00035932;
	assign s_logn_array[6]         =  32'h0004286C;
	assign s_logn_array[7]         =  32'h0004BC18;
	assign s_logn_array[8]         =  32'h00058B90;
	assign s_logn_array[9]         =  32'h000610A6;
	end
endgenerate

generate if((G_INPUT_WIDTH == 32) & (G_OUTPUT_WIDTH == 24)) begin
//input width = 32
// test inputs
	assign s_input_array[0]           =  32'h00000010;
	assign s_input_array[1]           =  32'h00000024;
	assign s_input_array[2]           =  32'h00000051;
	assign s_input_array[3]           =  32'h00000271;
	assign s_input_array[4]           =  32'h00000640;
	assign s_input_array[5]           =  32'h00001024;
	assign s_input_array[6]           =  32'h0000FACA;
	assign s_input_array[7]           =  32'h000FFFFF;
	assign s_input_array[8]           =  32'h3FFFFFFF;
	assign s_input_array[9]           =  32'h7FFFFFFF;

	// test outputs
	assign s_sqrt_array[0]         =  24'h000004;
	assign s_sqrt_array[1]         =  24'h000006;
	assign s_sqrt_array[2]         =  24'h000009;
	assign s_sqrt_array[3]         =  24'h000019;
	assign s_sqrt_array[4]         =  24'h000028;
	assign s_sqrt_array[5]         =  24'h000040;
	assign s_sqrt_array[6]         =  24'h0000FD;
	assign s_sqrt_array[7]         =  24'h000400;
	assign s_sqrt_array[8]         =  24'h008000;
	assign s_sqrt_array[9]         =  24'h00B505;

	assign s_logn_array[0]         =  24'h00B172;
	assign s_logn_array[1]         =  24'h00E558;
	assign s_logn_array[2]         =  24'h01193E;
	assign s_logn_array[3]         =  24'h019C04;
	assign s_logn_array[4]         =  24'h01D82D;
	assign s_logn_array[5]         =  24'h0214E5;
	assign s_logn_array[6]         =  24'h02C477;
	assign s_logn_array[7]         =  24'h03773A;
	assign s_logn_array[8]         =  24'h0532D7;
	assign s_logn_array[9]         =  24'h055F34;
	end
endgenerate

generate if((G_INPUT_WIDTH == 24) & (G_OUTPUT_WIDTH == 24)) begin
//input width = 24
// test inputs
	assign s_input_array[0]           =  24'h000010;
	assign s_input_array[1]           =  24'h000024;
	assign s_input_array[2]           =  24'h000051;
	assign s_input_array[3]           =  24'h000271;
	assign s_input_array[4]           =  24'h000640;
	assign s_input_array[5]           =  24'h001024;
	assign s_input_array[6]           =  24'h00FACA;
	assign s_input_array[7]           =  24'h0FFFFF;
	assign s_input_array[8]           =  24'h3FFFFF;
	assign s_input_array[9]           =  24'h7FFFFF;

	// test outputs
	assign s_sqrt_array[0]         =  24'h000004;
	assign s_sqrt_array[1]         =  24'h000006;
	assign s_sqrt_array[2]         =  24'h000009;
	assign s_sqrt_array[3]         =  24'h000019;
	assign s_sqrt_array[4]         =  24'h000028;
	assign s_sqrt_array[5]         =  24'h000040;
	assign s_sqrt_array[6]         =  24'h0000FD;
	assign s_sqrt_array[7]         =  24'h000400;
	assign s_sqrt_array[8]         =  24'h000800;
	assign s_sqrt_array[9]         =  24'h000B50;

	assign s_logn_array[0]         =  24'h00B172;
	assign s_logn_array[1]         =  24'h00E558;
	assign s_logn_array[2]         =  24'h01193E;
	assign s_logn_array[3]         =  24'h019C04;
	assign s_logn_array[4]         =  24'h01D82D;
	assign s_logn_array[5]         =  24'h0214E5;
	assign s_logn_array[6]         =  24'h02C477;
	assign s_logn_array[7]         =  24'h03773A;
	assign s_logn_array[8]         =  24'h03CFF3;
	assign s_logn_array[9]         =  24'h03FC50;
	end
endgenerate

generate if((G_INPUT_WIDTH == 18) & (G_OUTPUT_WIDTH == 24)) begin
//input width = 18
// test inputs
	assign s_input_array[0]           =  18'h00010;
	assign s_input_array[1]           =  18'h00024;
	assign s_input_array[2]           =  18'h00051;
	assign s_input_array[3]           =  18'h00271;
	assign s_input_array[4]           =  18'h00640;
	assign s_input_array[5]           =  18'h01024;
	assign s_input_array[6]           =  18'h0FACA;
	assign s_input_array[7]           =  18'h0FB00;
	assign s_input_array[8]           =  18'h0FFFF;
	assign s_input_array[9]           =  18'h1FFFF;

	// test outputs
	assign s_sqrt_array[0]         =  24'h000004;
	assign s_sqrt_array[1]         =  24'h000006;
	assign s_sqrt_array[2]         =  24'h000009;
	assign s_sqrt_array[3]         =  24'h000019;
	assign s_sqrt_array[4]         =  24'h000028;
	assign s_sqrt_array[5]         =  24'h000040;
	assign s_sqrt_array[6]         =  24'h0000FD;
	assign s_sqrt_array[7]         =  24'h0000FD;
	assign s_sqrt_array[8]         =  24'h000100;
	assign s_sqrt_array[9]         =  24'h00016A;

	assign s_logn_array[0]         =  24'h00B172;
	assign s_logn_array[1]         =  24'h00E558;
	assign s_logn_array[2]         =  24'h01193E;
	assign s_logn_array[3]         =  24'h019C04;
	assign s_logn_array[4]         =  24'h01D82D;
	assign s_logn_array[5]         =  24'h0214E5;
	assign s_logn_array[6]         =  24'h02C477;
	assign s_logn_array[7]         =  24'h02C485;
	assign s_logn_array[8]         =  24'h02C5C8;
	assign s_logn_array[9]         =  24'h02F224;
	end
endgenerate

//========================================================
// Clock divider
//========================================================
always @(SYSCLK)
    #(SYSCLK_PERIOD / 2.0) SYSCLK <= !SYSCLK;
    
//========================================================
// Reset pulse
//========================================================
initial
begin
    // Assert Reset
		NSYSRESET         <= 1'b0;
		i                 <= {6{1'b0}};
		// Start Signals
		t_start           <= 1'b0;
		
		// Initial Inputs
		t_input           <= {64{1'b0}};

		#( SYSCLK_PERIOD * 10 ) NSYSRESET    <= 1'b1;
		// Start Signals
		t_start            <= 1'b0;
		
		// Initial Inputs
		t_input            <= s_input_array[0];
		
		i                  <= {6{1'b0}};
		
		$display("------------------------------------------------------------------");
        $display("                    CORELNSQRT TESTBENCH                          ");
        $display("------------------------------------------------------------------");
		if(G_ARCHITECTURE == 0)
		begin
			if((G_IO_COMBINATION == 1) || (G_IO_COMBINATION == 2) || (G_IO_COMBINATION == 3) || 
			      (G_IO_COMBINATION == 4) || (G_IO_COMBINATION == 5) || (G_IO_COMBINATION == 6))
		    begin
				$display("------------------------------------------------------------------");
				$display("SEQUENTIAL","         ","INPUT WIDTH=%0d",G_INPUT_WIDTH,"        ","OUTPUT WIDTH=%0d",G_OUTPUT_WIDTH);
				$display("------------------------------------------------------------------");			
				for(i=0;i<=9;i=i+1)
				begin
					t_input <= s_input_array[i];
					#(SYSCLK_PERIOD)
					$display("==================================================================");
					$displayh("               ","TEST",i,": Input = " ,t_input                   );
					$display("==================================================================");
					#(SYSCLK_PERIOD)
					t_start <= 1'b1;
					#(SYSCLK_PERIOD)
					t_start <= 1'b0;
					wait (t_done);
					#(SYSCLK_PERIOD)
					$display("==================================================================");
					$display("                          Square Root:                            ");
					$displayh(""," DUT   : ",t_sqrt                                         );
					$displayh(""," TB    : ",s_sqrt_array[i]                               );
					$display("==================================================================");
					$display("                          Natural Log:                            ");
					$displayh(""," DUT   : ",t_log                                          );
					$displayh(""," TB    : ",s_logn_array[i]                               );
					$display("==================================================================");
				end
			end
			else
			begin
				$display("==================================================================");
				$display("Test-bench is supported for G_IO_COMBINATION = 1,2,3,4,5 and 6 only");
				$display("==================================================================");
			end
		end
		if(G_ARCHITECTURE == 1)
		begin
			if((G_IO_COMBINATION == 1) || (G_IO_COMBINATION == 2) || (G_IO_COMBINATION == 3) || 
			      (G_IO_COMBINATION == 4) || (G_IO_COMBINATION == 5) || (G_IO_COMBINATION == 6))
		    begin
				$display("------------------------------------------------------------------");
				$display("PIPELINE","         ","INPUT WIDTH=%0d",G_INPUT_WIDTH,"        ","OUTPUT WIDTH=%0d",G_OUTPUT_WIDTH);
				$display("------------------------------------------------------------------");	
				
				t_start     <= 1'b1;
				for(i=0;i<=9;i=i+1)
				begin
					t_input <= s_input_array[i];
					#(SYSCLK_PERIOD);
				end
				wait (t_done);
				for(i=0;i<=9;i=i+1)
				begin
					$display("==================================================================");
					$displayh("               ","TEST",i,": Input = " ,s_input_array[i]          );
					$display("==================================================================");
					#(SYSCLK_PERIOD)
					$display("==================================================================");
					$display("                          Square Root:                            ");
					$displayh(""," DUT   : ",t_sqrt                                              );
					$displayh(""," TB    : ",s_sqrt_array[i]                                     );
					$display("==================================================================");
					$display("                          Natural Log:                            ");
					$displayh(""," DUT   : ",t_log                                               );
					$displayh(""," TB    : ",s_logn_array[i]                                     );
					$display("==================================================================");
				end
			end
			else
			begin
				$display("==================================================================");
				$display("Test-bench is supported for G_IO_COMBINATION = 1,2,3,4,5 and 6 only");
				$display("==================================================================");
			end
		end
		$display("==================================================================");
		$display("                    END OF TESTS                                  ");
		$display("==================================================================");
end

//========================================================
// Module instantiation
//========================================================   
//========================================================
// CORELNSQRT_INST
//======================================================== 
CORELNSQRT
#(
    .G_ARCHITECTURE         (G_ARCHITECTURE),
	.G_INPUT_WIDTH          (G_INPUT_WIDTH),
	.G_OUTPUT_WIDTH         (G_OUTPUT_WIDTH),
	.G_NO_OF_ITERATIONS     (G_NO_OF_ITERATIONS)
)
CORELNSQRT_INST(
    .RESETN_I               (NSYSRESET),
    .SYS_CLK_I              (SYSCLK),
    .START_I                (t_start),
    .INPUT_I                (t_input),
    .DONE_O                 (t_done),
    .LOG_O                  (t_log),
    .SQ_ROOT_O              (t_sqrt)
);
endmodule


