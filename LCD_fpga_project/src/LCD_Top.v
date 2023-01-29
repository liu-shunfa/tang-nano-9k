
`timescale 1ns/1ps

module lcd_top(
	input clk,      // 27M
	input resetn,   //key reset

	output ser_tx,          //JTAG serial tx
	input ser_rx,           //JTAG serial rx

	output lcd_resetn,      //RST  PIN47_IOB43B_SPILCD_EN
	output lcd_clk,         //SCL  PIN76_IOT37B_SPILCD_MCLK
	output lcd_cs,          //CS   PIN48_IOR24B_SPILCD_CS
	output lcd_rs,          //RS   PIN49_IOR24A_SPILCD_RS     DC:0:cmd  1:data 
	output lcd_data         //SDA  PIN77_IOT37A_SPILCD_MO
);


wire [15:0] pixel,pixel_cnt;
lcd_draw lcd_draw_1(
.reset          (resetn),
.pixel_cnt      (pixel_cnt),
.pixel          (pixel)
);

reg lcd_cs_r,lcd_reset_r,lcd_rs_r;
lcd_init lcd_init_1(
.clk            (clk),
.lcd_clk        (lcd_clk),
.resetn         (resetn),
.pixel          (pixel),
.pixel_cnt      (pixel_cnt),
.lcd_reset_r    (lcd_resetn),
.lcd_cs_r       (lcd_cs),
.lcd_rs_r       (lcd_rs),
.spi_data_msb   (lcd_data)

);

endmodule
