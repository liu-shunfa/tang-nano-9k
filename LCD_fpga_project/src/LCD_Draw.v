`timescale 1ns/1ps

module lcd_draw
(
 //       input           oscclk,
        input           reset,
        input   [15:0]  pixel_cnt,
        
        output  [15:0]  pixel
);

localparam black        = 16'h0000;
localparam pink         = 16'hFE19;
localparam dark_pink    = 16'hF8B2;
localparam light_pink   = 16'hFDB8;
localparam purple       = 16'h8010;
localparam dark_purple  = 16'h901A;
localparam light_purple = 16'hFF9E;
localparam blue         = 16'h001F;
localparam dark_blue    = 16'h0011;
localparam light_blue   = 16'h867F;
localparam gray         = 16'h7412;
localparam dark_gray    = 16'h6B4D;
localparam light_gray   = 16'h7453;
localparam green        = 16'h0400;
localparam dark_green   = 16'h0320;
localparam light_green  = 16'h9772;
localparam yellow       = 16'hFFE0;
localparam dark_yellow  = 16'hFFD9;
localparam light_yellow = 16'hFFFC;
localparam orange       = 16'hFD20;
localparam dark_orange  = 16'hFC60;
localparam light_orange = 16'hFF36;
localparam red          = 16'hF800;
localparam dark_red     = 16'h8800;
localparam light_red    = 16'hF410;
localparam gold         = 16'hFEA0;
localparam silver       = 16'hC618;
localparam white        = 16'hFFFF;
localparam brown        = 16'hA145;
localparam chocolate    = 16'hD343;
localparam tomato       = 16'hFB08;

wire [ 7:0] pixel_x,pixel_y;
reg  [15:0] pixel_r;
assign pixel_x = (pixel_cnt)%8'd240;     //x轴，从左到右 0---239
assign pixel_y = (pixel_cnt)/8'd240;     //y轴，从上到下 0---134
/*
         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
        |0-------------------------239 |
        |240-----------------------479 |
        |                              |
        |         原计数方案            |
        |                              |
        |                              |
        |_ _ _ _ _ _ _ _ _ _ _  _ 32399|

         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
        |0-------------------------239 0|
        |1-------------------------239 0|
        |                              0|
        |          现计数方案           0|
        |                              0|
        |                              0|
        |134------------------------239 |

*/
/*
0000001010182828243C444242E70000//"A",0/
000000F8444444784442424244F80000//"B",1/


100408040804FFA40224422422241424
14240824082414242404420482140008//"刘",0

01000100010001003FF8210821082108
210821083FF821080100010001000100*"中",0*
08101D10F09010901010FD1010903890
3410501E53F090101010101010101010*"科",1*
200027FC240424A4F910220820402840
37FCE04020E0215022482C46A0404040*"探",2*
0100210011FC120085F8410849480928
17FE1108E248222823FC200820500020*"海",3*

*/
//localparam char_num = 1;                        //汉字数量
wire [8*16 - 1:0] char_s [7:0];                 //一个汉字2个长数组char_s组成
//assign char_s[0] = 128'h01000100010001003FF8210821082108;
//assign char_s[1] = 128'h210821083FF821080100010001000100;
assign char_s[0] = 128'h08101D10F09010901010FD1010903890;
assign char_s[1] = 128'h3410501E53F090101010101010101010;
assign char_s[4] = 128'h200027FC240424A4F910220820402840;
assign char_s[5] = 128'h37FCE04020E0215022482C46A0404040;
assign char_s[6] = 128'h0100210011FC120085F8410849480928;
assign char_s[7] = 128'h17FE1108E248222823FC200820500020;
reg [15:0]  char_pixel [15:0];


always@(*)              //dange hanzi xianshi 
begin
    char_pixel [ 0] <= char_s[0][127:111];
    char_pixel [ 1] <= char_s[0][111: 95];
    char_pixel [ 2] <= char_s[0][ 95: 79];
    char_pixel [ 3] <= char_s[0][ 79: 63];
    char_pixel [ 4] <= char_s[0][ 63: 47];
    char_pixel [ 5] <= char_s[0][ 47: 31];
    char_pixel [ 6] <= char_s[0][ 31: 15];
    char_pixel [ 7] <= char_s[0][ 15:  0];
    char_pixel [ 8] <= char_s[1][127:111];
    char_pixel [ 9] <= char_s[1][111: 95];
    char_pixel [10] <= char_s[1][ 95: 79];
    char_pixel [11] <= char_s[1][ 79: 63];
    char_pixel [12] <= char_s[1][ 63: 47];
    char_pixel [13] <= char_s[1][ 47: 31];
    char_pixel [14] <= char_s[1][ 31: 15];
    char_pixel [15] <= char_s[1][ 15:  0];    
 
end

/*
always@(*)
begin
    char_pixel [ 0] <= char_s[0][127:111];
    char_pixel [ 1] <= char_s[0][111: 95];
    char_pixel [ 2] <= char_s[0][ 95: 79];
    char_pixel [ 3] <= char_s[0][ 79: 63];
    char_pixel [ 4] <= char_s[0][ 63: 47];
    char_pixel [ 5] <= char_s[0][ 47: 31];
    char_pixel [ 6] <= char_s[0][ 31: 15];
    char_pixel [ 7] <= char_s[0][ 15:  0];
    char_pixel [ 8] <= char_s[1][127:111];
    char_pixel [ 9] <= char_s[1][111: 95];
    char_pixel [10] <= char_s[1][ 95: 79];
    char_pixel [11] <= char_s[1][ 79: 63];
    char_pixel [12] <= char_s[1][ 63: 47];
    char_pixel [13] <= char_s[1][ 47: 31];
    char_pixel [14] <= char_s[1][ 31: 15];
    char_pixel [15] <= char_s[1][ 15:  0]; 
    char_pixel [16] <= char_s[2][127:111];
    char_pixel [17] <= char_s[2][111: 95];
    char_pixel [18] <= char_s[2][ 95: 79];
    char_pixel [19] <= char_s[2][ 79: 63];
    char_pixel [20] <= char_s[2][ 63: 47];
    char_pixel [21] <= char_s[2][ 47: 31];
    char_pixel [22] <= char_s[2][ 31: 15];
    char_pixel [23] <= char_s[2][ 15:  0];
    char_pixel [24] <= char_s[3][127:111];
    char_pixel [25] <= char_s[3][111: 95];
    char_pixel [26] <= char_s[3][ 95: 79];
    char_pixel [27] <= char_s[3][ 79: 63];
    char_pixel [28] <= char_s[3][ 63: 47];
    char_pixel [29] <= char_s[3][ 47: 31];
    char_pixel [30] <= char_s[3][ 31: 15];
    char_pixel [31] <= char_s[3][ 15:  0]; 
    char_pixel [32] <= char_s[4][127:111];
    char_pixel [33] <= char_s[4][111: 95];
    char_pixel [34] <= char_s[4][ 95: 79];
    char_pixel [35] <= char_s[4][ 79: 63];
    char_pixel [36] <= char_s[4][ 63: 47];
    char_pixel [37] <= char_s[4][ 47: 31];
    char_pixel [38] <= char_s[4][ 31: 15];
    char_pixel [39] <= char_s[4][ 15:  0];
    char_pixel [40] <= char_s[5][127:111];
    char_pixel [41] <= char_s[5][111: 95];
    char_pixel [42] <= char_s[5][ 95: 79];
    char_pixel [43] <= char_s[5][ 79: 63];
    char_pixel [44] <= char_s[5][ 63: 47];
    char_pixel [45] <= char_s[5][ 47: 31];
    char_pixel [46] <= char_s[5][ 31: 15];
    char_pixel [47] <= char_s[5][ 15:  0]; 
    char_pixel [48] <= char_s[6][127:111];
    char_pixel [49] <= char_s[6][111: 95];
    char_pixel [50] <= char_s[6][ 95: 79];
    char_pixel [51] <= char_s[6][ 79: 63];
    char_pixel [52] <= char_s[6][ 63: 47];
    char_pixel [53] <= char_s[6][ 47: 31];
    char_pixel [54] <= char_s[6][ 31: 15];
    char_pixel [55] <= char_s[6][ 15:  0];
    char_pixel [56] <= char_s[7][127:111];
    char_pixel [57] <= char_s[7][111: 95];
    char_pixel [58] <= char_s[7][ 95: 79];
    char_pixel [59] <= char_s[7][ 79: 63];
    char_pixel [60] <= char_s[7][ 63: 47];
    char_pixel [61] <= char_s[7][ 47: 31];
    char_pixel [62] <= char_s[7][ 31: 15];
    char_pixel [63] <= char_s[7][ 15:  0]; 
 
end
*/
always@(*)
begin
    if(!reset) pixel_r <= green;
    else if(pixel_x <8'd16 && pixel_y < 8'd16)
            if(char_pixel[pixel_y][16-pixel_x])
//    else if(pixel_y == 134)
                pixel_r <= white;
            else
                pixel_r <= black;
        else pixel_r <= yellow;
end
assign pixel = pixel_r;

endmodule

        
