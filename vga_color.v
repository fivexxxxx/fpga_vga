/*
	VGA说明：
	分辨率：640×480 /60Hz
	基准时钟：25MHz，由：（1/60） /（800×525）约=39.6825ns; 1s/39.6825ns 越=25MHz.
	
		同步脉冲		显示后沿		显示区域		显示前沿		帧长		单位
	行	96				48				640				16				800			基准时钟
	列	2				33				480				10				525			行
	目标：
		显示红色整屏

*/
module vga_color(
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

wire								clk_0			;
wire								hys				;
wire								vys				;
wire	[15:0]						lcd_rgb			;


//例化PLL模块，为VGA驱动模块提供25M时钟
my_pll uut_pll(
	.inclk0	(	clk		)		,
	.c0		(	clk_0	)		
);

//例化VGA驱动模块
color uut_color(
					.clk	(	clk_0		)		,
					.rst_n	(	rst_n		)		,
					.hys	(	hys			)		,
					.vys	(	vys			)		,
					.lcd_rgb(	lcd_rgb		)       
);

endmodule
