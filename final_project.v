`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2018 14:45:25
// Design Name: 
// Module Name: sev_seg_dis
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


  module game(
    input btnU,
    input btnC,
    input btnD,
    input clk,
    output reg [6:0] seg,
    output reg [3:0] an
    
    );

    wire [1:0] s;
    integer count=0;
    reg [4:0]  seg_0=27;
    reg [4:0]  seg_1=26;
    reg [4:0]  seg_2=25;
    reg [4:0]  seg_3=24;
    reg [4:0]  digit;
    reg [19:0] clkdiv;

    reg [26:0] move;
    reg [4:0]  rand_no;
    reg [12:0] score=0;
    reg [1:0] display_score;
    reg [26:0] state_clk;
    reg prev_btnU;
    reg prev_btnD;
    reg prev_btnC;
   
    initial begin
    state_clk = 27'b111111111110000000000000000;
    end
    
    assign s = clkdiv[19:18];
   

    always @(posedge clk)
    begin
    
               if(count!=1)
    begin
     seg_0=27;
     seg_1=26;
     seg_2=25;
     seg_3=24;
     end
    
       if(  btnC == 1 )
        begin
            count=1;
            seg_0=5'b00001;
            seg_1=5'b11111;
            seg_2=5'b11111;
            seg_3=5'b11111;
             clkdiv <= 0;
            move=0;
            state_clk=27'b1111111111110000000000000000;
            score=0;
            display_score=0;;
        end
        
           else
            clkdiv <= clkdiv + 1;
        move = move+1;
         if( prev_btnU==0 && btnU==1 )
        begin
            prev_btnU = 1;
          
            if(seg_0==5'b00010)
                seg_0 = 5'b00000;
            else if(seg_0==5'b00000)
                seg_0 = 5'b00001;
        end
        
        else if( prev_btnD==0 && btnD==1 )
        begin
            prev_btnD = 1;
            if(seg_0==5'b00000)
                seg_0 = 5'b00010;
            else if(seg_0==5'b00001)
                seg_0 = 5'b00000;
           
        end
      
        if(btnU==0)
            prev_btnU = 0;
        if(btnD==0)
            prev_btnD = 0;
     
        rand_no = (rand_no+clkdiv[19:17]*clkdiv[15:14]*move+clkdiv[19:18]+seg_0*rand_no+seg_1*clkdiv[2:0]+seg_2*clkdiv[6:5]+seg_3*3)%10;
       
        if(move==state_clk)
        begin
                    move = 27'b000000000000000000000000000;
            if( ( seg_0 == 0 && ( seg_1 == 0 || seg_1 == 5 || seg_1 == 4 || seg_1==6 || seg_1==7 || seg_1==8 || seg_1==9)) || ( seg_0 == 1 && ( seg_1 == 1 || seg_1 == 4 || seg_1 == 3 || seg_1==6 || seg_1==7) ) || ( seg_0 == 2 && ( seg_1 == 2 || seg_1 == 3 || seg_1 == 5 || seg_1==8 || seg_1==9))  )
            begin
                seg_3 = 10;
                seg_2 = 11;
                seg_1 = 12;
                seg_0 = 13;
                display_score=2;
               
            end
            
            else if(display_score  == 2 )
            begin
                score = score - 3;
                seg_0 = ( score % 10 ) + 14;
                score = score / 10;
                seg_1 = ( score % 10 ) + 14;
                score = score / 10;
                seg_2 = ( score % 10 ) + 14;
                score = score / 10;
                seg_3 = ( score % 10 ) + 14;
                display_score=display_score +1;     
            end
            else if( display_score!= 3 && count==1)
            begin
            
                seg_1 = seg_2;
                seg_2 = seg_3;
                seg_3 = rand_no;
                score = score + 1;
            end
      end   
      
      end  
            
         always @(*)
    begin
    
   
        case(s)
        2'b00: begin
            an = 4'b1110; 
            // activate LED1 and Deactivate LED2, LED3, LED4
              digit = seg_0;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            an = 4'b1101; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            digit = seg_1;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            an = 4'b1011; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            digit = seg_2;
            // the third digit of the 16-bit number
                end
        2'b11: begin
           an = 4'b0111; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            digit = seg_3;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
        
   


    // decoder or truth-table for 7 a_to_g display values
     always @(*)
    begin
        case(digit)
            0:  seg = 7'b0111111;   // g
            1:  seg = 7'b1111110;   // a
            2:  seg = 7'b1110111;  // d
            3:  seg = 7'b1110110;  //ad
            4:  seg = 7'b0111110;  //ag
            5:  seg = 7'b0110111;  // gd
            6:  seg = 7'b1011110;   //af
            7:  seg = 7'b1111100;      //ab
            8:  seg = 7'b1100111;      //de
            9:  seg = 7'b1110011;    //cd
            10:  seg = 7'b1000000;     //  O
            11:  seg = 7'b1010101;     //  V
            12:  seg = 7'b0000110;     // E
            13:  seg = 7'b0001000;     // R
            14: seg = 7'b1000000;     // 0
            15: seg = 7'b1111001;     //  1
            16: seg = 7'b0100100;     // 2
            17: seg = 7'b0110000;     // 3
            18: seg = 7'b0011001;     // 4
            19: seg = 7'b0010010;     // 5
            20: seg = 7'b0000010;     //  6
            21: seg = 7'b1111000;     // 7
            22: seg = 7'b0000000;     //  8
            23: seg = 7'b0011000;     // 9
            24: seg = 7'b0001100;     //  P
            25: seg = 7'b1000111;     //L
            26: seg = 7'b0001000;      //A
            27: seg = 7'b0011001;      //y
          
            default: seg = 7'b1111111;  // all off
          endcase         
    end
endmodule