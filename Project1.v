/*
* Edward Zhu
* Project 1 - Seven Sensor Alarm
* 9/17/14
*/
module Project1(f, x1, x2, x3, x4, x5, x6, x7);
   output f;
	input x1, x2, x3, x4, x5, x6, x7;
	
	//struct U1(f, x1, x2, x3, x4, x5, x6, x7);
	//continuous U2(f, x1, x2, x3, x4, x5, x6, x7);
	procedural U3(f, x1, x2, x3, x4, x5, x6, x7);
	
endmodule

module struct(f, x1, x2, x3, x4, x5, x6, x7);
	output f;
	input x1, x2, x3, x4, x5, x6, x7;
	wire y1, y2, y3, y4, y5, y6, y7, nx1, nx2, nx3, nx4, nx5, nx6, nx7;
  
	not(nx1, x1);
	not(nx2, x2);
	not(nx3, x3);
	not(nx4, x4);
	not(nx5, x5);
	not(nx6, x6);
	not(nx7, x7);
	or(y1, nx1, nx2, nx3, nx4, nx5, nx6);
	or(y2, nx1, nx2, nx3, nx4, nx5, nx7);
	or(y3, nx1, nx2, nx3, nx4, nx6, nx7);
	or(y4, nx1, nx2, nx3, nx5, nx6, nx7);
	or(y5, nx1, nx2, nx4, nx5, nx6, nx7);
	or(y6, nx1, nx3, nx4, nx5, nx6, nx7);
	or(y7, nx2, nx3, nx4, nx5, nx6, nx7);
	and(f, y1, y2, y3, y4, y5, y6, y7);
  
endmodule 



module continuous(f, x1, x2, x3, x4, x5, x6, x7);
	output f;
	input x1, x2, x3, x4, x5, x6, x7;
	
	assign f = (~x1|~x2|~x3|~x4|~x5|~x6)&(~x1|~x2|~x3|~x4|~x5|~x7)
					&(~x1|~x2|~x3|~x4|~x6|~x7)&(~x1|~x2|~x3|~x5|~x6|~x7)
					&(~x1|~x2|~x4|~x5|~x6|~x7)&(~x1|~x3|~x4|~x5|~x6|~x7)
					&(~x2|~x3|~x4|~x5|~x6|~x7);
  
endmodule 



module procedural(f, x1, x2, x3, x4, x5, x6, x7);
	output reg f;
	input x1, x2, x3, x4, x5, x6, x7;
	reg [2:0]count;
	
	always @(x1, x2, x3, x4, x5, x6, x7, f)
	begin
		count = x1 + x2 + x3 + x4 + x5 + x6 + x7;
		if (count <= 5)
			f = 1;
		else
			f = 0;
	end

endmodule 




