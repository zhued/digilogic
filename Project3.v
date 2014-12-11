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
			default: y=7'b0000001;
		endcase
	end

endmodule	

module buttonPress(Clock, Set, Reset, Real_Reset, buttonState);
	input Clock, Set, Reset, Real_Reset;
	output reg buttonState;
	
	always@(posedge Clock) begin
		if(~Reset|| ~Real_Reset) begin
			buttonState = 0;
		end
		else if (~Set) begin
			buttonState = 1;
		end
	end
endmodule


module Project3(Clock, Reset, Start_button, Stop_button, LED_on, LED_live, y0, y1, y2, y3);
	input Clock, Reset, Start_button, Stop_button;
	
	output reg LED_on, LED_live;
	output [0:6] y0, y1, y2, y3;
	
	reg [3:0] BCD0, BCD1, BCD2, BCD3;
	
	initial begin
		BCD0 <= 4'b0000;
		BCD1 <= 4'b0000;
		BCD2 <= 4'b0000;
		BCD3 <= 4'b0000;
	end
	
	wire start;
	
	buttonPress str (Clock, Start_button, Stop_button, Reset, start);
	
	reg [18:0]count;
	wire count_max;
	reg start_reaction;
	
	//
	//50MHz to 100Hz
	// Doubt it's working
	always @(posedge Clock) begin
		if (~Reset) begin
			count <= 0;
		end
		else if (count == 500000) begin
			count <= 0;
		end
		else if(start_reaction) begin
			count <= count + 1;
		end
	end
	
	assign count_max = ((count == 500000)?1'b1:1'b0);
	
	
	//
	//LFSR Random Time Generatation
	//
	reg [26:0] rand, rand_next, rand_found;
	reg [4:0] count_r, count_next_r;
	
	wire feedback = rand[26] ^ rand[24];
	 
	always @ (posedge Clock) begin
		if (~Reset) begin
			rand <= 27'hF; // LFSR cannot have all 0 state
			count_r <= 0;
		end
		else begin
			rand <= rand_next;
			count_r <= count_next_r;
		end
	end
	 
	always @ (*) begin
		rand_next = rand;
		count_next_r = count_r;
		
		rand_next = {rand[25:0], feedback}; //shift left then the feedback gets placed in the [0] position
				
		if (count_r == 27) begin
			count_next_r = 0;
			rand_found = rand; //assign the rand number to output after 30 shifts
		end
		else begin
			count_next_r = count_r + 1;
			rand_found = rand; //keep previous value of rand
		end
	end
	//
	// END LFSR Random Time Generatation
	//
	
	wire [26:0] delay_rand;
	assign delay_rand = 50000000 + rand_found;
	reg [26:0] count2rand;
	//	
	//Time reaction!
	//
	always @(posedge Clock) begin
		if (~Reset) begin
			LED_on = 0;
			LED_live = 0;
			count2rand <= 0;
		end
		else if (start) begin
			start_reaction = 1;
			LED_live = 1;
			if (~start) begin
				LED_on <= 1'b0;
			end
			else begin
				if (count2rand == delay_rand) begin

					count2rand <= 0;
					LED_on <= 1'b1;
				end
				else begin
					count2rand <= count2rand + 1'b1;
				end
			end
		end
		else begin
			LED_on = 0;
			LED_live = 0;
		end
	end
	
	
	
	//BCD for seven segment hex display
	//	TIME BELOW
	// 	1.234
	//	BCD0 is far right digit (4), BCD3 is far left digit (1)
	
	always@(posedge Clock) begin
		if (~Reset) begin
			BCD0 <= 4'b0000;
			BCD1 <= 4'b0000;
			BCD2 <= 4'b0000;
			BCD3 <= 4'b0000;
		end
		else if (LED_on) begin
			if (count_max) begin
				if (BCD0 == 4'b1001) begin
					BCD0 <= 4'b0000;
					if (BCD1 == 4'b1001) begin
						BCD1 <= 4'b0000;
						if (BCD2 == 4'b1001) begin
							BCD2 <= 4'b0000;
							if (BCD3 == 4'b1001) begin
								BCD3 <= 4'b0000;
							end
							else begin
								BCD3 <= BCD3 + 1'b1;
							end
						end
						else begin
							BCD2 <= BCD2 + 1'b1;
						end
					end
					else begin
						BCD1 <= BCD1 + 1'b1;
					end
				end
				else begin
					BCD0 <= BCD0 + 1'b1;
				end
			end
		end
	end
	

	//Display number on hexdisplay
	hexdisplay ss0 (BCD0, y0);
	hexdisplay ss1 (BCD1, y1);
	hexdisplay ss2 (BCD2, y2);
	hexdisplay ss3 (BCD3, y3);
endmodule