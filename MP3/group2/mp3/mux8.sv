module mux8 #(parameter width = 16)
(
	input [2:0] sel,
	input [width-1:0] a, b, c, d, e, f, g, h,
	output logic [width-1:0] o
);

always_comb
begin
	if			(sel == 0)	o = a;
	else if	(sel == 1)	o = b;
	else if	(sel == 2)	o = c;
	else if	(sel == 3)	o = d;
	else if	(sel == 4)	o = e;
	else if	(sel == 5)	o = f;
	else if	(sel == 6)	o = g;
	else						o = h;
end

endmodule : mux8
