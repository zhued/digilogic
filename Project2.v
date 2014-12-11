/*************
* Edward Zhu
*
* Project 2 -  Ternary adder with carry lookahead
* Due 10/07/14, P. Mathys
**************/

module Project2(x01,x00,x11,x10,y01,y00,y11,y10,c0,c1,c2,s01,s00,s11,s10,g0,g1,p0,p1);
	input x01,x00,x11,x10,y01,y00,y11,y10,c0;
	output s01,s00,s11,s10,c1,c2,g0,g1,p0,p1;
	
	assign s01 = x00&y00&~c0 | ~x01&~x00&y01&~c0 | x01&~y01&~y00&~c0 | x01&y01&c0 | ~x01&~x00&y00&c0 | x00&~y01&~y00&c0; 
	assign s00 = x01&y01&~c0 | ~x01&~x00&y00&~c0 |  x00&~y01&~y00&~c0 | x01&y00&c0 |  x00&y01&c0 | ~x01&~x00&~y01&~y00&c0;
	
	assign g0 = x00&y01 | x01&y00 | x01&y01;
	assign p0 = y01 | x00&y00 |  x01;
	assign c1 = g0 | p0&c0;
	
	assign s11 = x10&y10&~c1 | ~x11&~x10&y11&~c1 | x11&~y11&~y10&~c1 | x11&y11&c1 | ~x11&~x10&y10&c1 | x10&~y11&~y10&c1;
	assign s10 = x11&y11&~c1 | ~x11&~x10&y10&~c1 |  x10&~y11&~y10&~c1 | x11&y10&c1 |  x10&y11&c1 | ~x11&~x10&~y11&~y10&c1;
	
	assign g1 = x10&y11 | x11&y10 | x11&y11;
	assign p1 = y11 | x10&y10 | x11;
	assign c2 = g1 | p1&g0 | p1&p0&c0;
	
endmodule

//module carrylookahead()

//endmodule