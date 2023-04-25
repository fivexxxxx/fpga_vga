/*
	VGA驱动模块说明：
	分辨率：640×480 /60Hz
	基准时钟：25MHz，由：（1/60） /（800×525）约=39.6825ns; 1s/39.6825ns 越=25MHz.
	
		同步脉冲		显示后沿		显示区域		显示前沿		帧长		单位
	行	96				48				640				16				800			基准时钟
	列	2				33				480				10				525			行
	
*/
module color(
					clk								,
					rst_n							,
	//其他信号
					hys								,
					vys								,
					lcd_rgb
);
//信号定义----------信号名-------------------------//
input				clk								;
input				rst_n							;
//信号类型----------信号名-------------------------//
output								hys				;
output								vys				;
output	[15:0]						lcd_rgb			;
//计数器--hcnt
reg[9:0]							hcnt		;	//计数器位宽
wire								add_hcnt	;	//计数开始条件
wire								end_hcnt	;	//计数结束条件
//计数器--vcnt
reg[9:0]							vcnt		;	//计数器位宽
wire								add_vcnt	;	//计数开始条件
wire								end_vcnt	;	//计数结束条件
reg									hys			;
reg									vys			;
reg									red_area	;
reg	[15:0]							lcd_rgb		;
//计数器--hcnt
always @(posedge	clk	or	negedge	rst_n) begin
	if(!rst_n) begin
		hcnt	<=	0	;
	end
	else if(add_hcnt) begin
		if(end_hcnt)
			hcnt	<=	0	;
		else
			hcnt	<=	hcnt	+	1	;
	end
end
//计数器--hcnt 加1条件
assign	add_hcnt	=	1	;
//计数器--hcnt 计数结束条件							
assign	end_hcnt	=	add_hcnt	&&	hcnt	==	800	-	1	;
/*
hys				 ____________________800________________________________________	
----|			|																|
	|___96______|																|______
*/
always @(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)	begin
		hys <= 0	;
	end
	else if(add_hcnt && add_hcnt==96-1)begin
		hys	<=	1	;
	end 
	else if(end_hcnt)begin
		hys	<=	0	;
	end 
end
/*
vys				 ____________________525________________________________________	
----|			|																|
	|___2_______|																|______
*/
//计数器--vcnt
always @(posedge	clk	or	negedge	rst_n) begin
	if(!rst_n) begin
		vcnt	<=	0	;
	end
	else if(add_vcnt) begin
		if(end_vcnt)
			vcnt	<=	0	;
		else
			vcnt	<=	vcnt	+	1	;
	end
end
//计数器--vcnt 加1条件
assign	add_vcnt	=	end_hcnt	;
//计数器--vcnt 计数结束条件							
assign	end_vcnt	=	add_vcnt	&&	vcnt	==	525	-	1	;
always @(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)	begin
		vys	<=	0	;
	end
	else if(add_vcnt && vcnt==2-1)begin
		vys	<=	1	;
	end 
	else if(end_vcnt)begin
		vys	<=	0	;
	end 
end
//组合逻辑--always
always @(*)begin
	red_area=(hcnt>=(96+48)&& hcnt<(96+48+640))&& (vcnt>= (2+33) && vcnt<(2+33+480))	;
end 
always @(posedge	clk	or	negedge	rst_n)	begin
	if(!rst_n)	begin
		lcd_rgb	<=	0	;
	end
	else if(red_area)begin
		lcd_rgb	<=	16'b11111_000000_00000	;
	end 
	else begin
		lcd_rgb	<=	0	;
	end 
end

endmodule
