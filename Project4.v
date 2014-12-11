// Show hexdisplay
module hexdisplay (x,y);
	input [3:0] x;
	output reg [0:6] y;

	always@(x)
	begin
		case(x)
			0: y=7'b0000001; 
			1: y=7'b1001111;
			2: y=7'b0010010;
			3: y=7'b0000110;
			4: y=7'b1001100;
			5: y=7'b0100100;
			6: y=7'b0100000;
			7: y=7'b0001111;
			8: y=7'b0000000;
			9: y=7'b0000100;
			// Rest are mapped to letters
			10: y=7'b0011000; //P
			11: y=7'b1110001;	//L
			12: y=7'b0001000;	//A
			13: y=7'b1000100;	//Y
			14: y=7'b1001000;	//H
			15: y=7'b1111110;	//-
			default: y=7'b0000001;
		endcase
	end
endmodule


// Random number generator
module lfsr (L, R, Clock, Q, state);
	parameter n=10;
	input Clock, L;
	input [2:0] state;
	input [0:n-1] R;
	output reg [0:n-1] Q;
	always@(posedge Clock) begin
		if (state == 0) begin
			if(L)
				Q <= R;
			else
				Q <= { Q[n-1] ^ Q[n-3], Q[0:n-2] };
		end
	end
endmodule



module countGuesses (Reset, Guess_button, count0, count1);
	input Reset, Guess_button;
	output reg [3:0] count0, count1;
	
	always@(negedge Guess_button, negedge Reset) begin
		if (~Reset) begin
			count0 <= 4'b0000;
			count1 <= 4'b0000;
		end
		else if (~Guess_button) begin
			if (count0 == 4'b1001) begin
				count0 <= 4'b0000;
				if (count1 == 4'b1001) begin
					count1 <= 4'b0000;
				end
				else begin
					count1 <= count1 + 1'b1;
				end
			end
			else begin
				count0 <= count0 + 1'b1;
			end
		end
	end
endmodule


module OUTvars (state, Clock, count0, count1, OUT0, OUT1, OUT2, OUT3);
	input [2:0] state;
	input Clock;
	input [3:0] count0, count1;
	output reg [3:0] OUT0, OUT1, OUT2, OUT3;
	
	always @(posedge Clock) begin
		// Idle/Reset
		if (state == 0) begin
			//Blank/Zeros
			OUT0 <= 4'b0;
			OUT1 <= 4'b0;
			OUT2 <= 4'b0;
			OUT3 <= 4'b0;
		end
		else if (state == 1) begin
			//PLAY
			OUT0 <= 4'b1101;
			OUT1 <= 4'b1100;
			OUT2 <= 4'b1011;
			OUT3 <= 4'b1010;
		end
		else if (state == 2) begin
			//LO
			OUT0 <= 4'b1111;
			OUT1 <= 4'b0000;
			OUT2 <= 4'b1011;
			OUT3 <= 4'b1111;
		end
		else if (state == 3) begin
			//HI
			OUT0 <= 4'b1111;
			OUT1 <= 4'b0001;
			OUT2 <= 4'b1110;
			OUT3 <= 4'b1111;
		end
		else if (state == 4) begin
			//--## for now
			OUT0 <= count0;
			OUT1 <= count1;
			OUT2 <= 4'b1111;
			OUT3 <= 4'b1111;
		end
	end
endmodule


// buttons
module buttonPress(Clock, Reset, guess, Start_button, Guess_button, state, random);
	input Clock, Reset, Start_button, Guess_button;
	input [9:0] guess, random;
	output reg [2:0] state;
	
	always @(posedge Clock) begin
		if (~Reset) begin
			state <= 0;
		end
		else if (~Start_button) begin
			state <= 1;
		end
		else if (~Guess_button) begin
			if (random > guess) begin
				state <= 2; // Low
			end
			else if (random < guess) begin
				state <= 3; // High
			end
			else if (random == guess) begin
				state <= 4; // Hit
			end
		end
	end
endmodule


// Main driver
module Project4(Clock, Reset, Start_button, Guess_button, switch, y0, y1, y2, y3);
	input [9:0] switch;
	input Clock, Reset, Start_button, Guess_button;
	
	output [0:6] y0, y1, y2, y3;
	
	wire [2:0] state;
	wire [9:0] random;
	wire [3:0] OUT0, OUT1, OUT2, OUT3;
	wire [3:0] count0, count1;
	
	
	lfsr L1 (~Reset, 9'b1, Clock, random, state);
	countGuesses G1 (Reset, Guess_button, count0, count1);
	OUTvars O1 (state, Clock, count0, count1, OUT0, OUT1, OUT2, OUT3);
	buttonPress B1 (Clock, Reset, switch, Start_button, Guess_button, state, random);
	
	
	hexdisplay ss0 (OUT0, y0);
	hexdisplay ss1 (OUT1, y1);
	hexdisplay ss2 (OUT2, y2);
	hexdisplay ss3 (OUT3, y3);
endmodule

