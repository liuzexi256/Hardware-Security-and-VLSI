module des3_top(
           wb_adr_i, wb_cyc_i, wb_dat_i, wb_sel_i,
           wb_stb_i, wb_we_i,
           wb_ack_o, wb_err_o, wb_dat_o,
           wb_clk_i, wb_rst_i, int_o
       );
parameter dw = 32;
parameter aw = 32;
input [aw-1:0] wb_adr_i;
input   wb_cyc_i;
input [dw-1:0]  wb_dat_i;
input [3:0]   wb_sel_i;
input   wb_stb_i;
input   wb_we_i;
output   wb_ack_o;
output   wb_err_o;
output reg [dw-1:0]  wb_dat_o;
output  int_o;
input   wb_clk_i;
input   wb_rst_i;
assign wb_ack_o = 1'b1;
assign wb_err_o = 1'b0;
assign int_o = 1'b0;
reg start, start_r;
reg [31:0] data [0:1];
wire [63:0] bigData = {data[1], data[0]};
wire [63:0] valid;
wire ready_for_res;
reg decrypt;
reg wb_stb_i_r;
reg [31:0] key [0:5];
wire [55:0] key_1;
wire [55:0] key_2;
wire [55:0] key_3;
genvar i;
generate if (remove_parity_bits == 1) begin
    for (i = 0; i < 4; i = i + 1) begin
        assign key_1[34 + i*7:28 + i*7] = key[0][i*8+1 + 6:i*8+1];
        assign key_1[ 6 + i*7:     i*7] = key[1][i*8+1 + 6:i*8+1];
        assign key_2[34 + i*7:28 + i*7] = key[2][i*8+1 + 6:i*8+1];
        assign key_2[ 6 + i*7:     i*7] = key[3][i*8+1 + 6:i*8+1];
        assign key_3[34 + i*7:28 + i*7] = key[4][i*8+1 + 6:i*8+1];
        assign key_3[ 6 + i*7:     i*7] = key[5][i*8+1 + 6:i*8+1];
    end // generate for (i = 0; i < 4; i = i + 1)
end else begin
    assign key_1    = {key[0][27:0], key[1][27:0]};
    assign key_2    = {key[2][27:0], key[3][27:0]};
    assign key_3    = {key[4][27:0], key[5][27:0]};
end // end else
endgenerate
always @(posedge wb_clk_i)
    begin
        if(!wb_rst_i)
            begin
                start       <= 0;
                start_r     <= 0;
                decrypt     <= 0;
                data[0] <= 0;
                data[1] <= 0;
                key[0] <= 0;
                key[1] <= 0;
                key[2] <= 0;
                key[3] <= 0;
                key[4] <= 0;
                key[5] <= 0;
                wb_stb_i_r  <= 1'b0;
            end
        else begin
            start_r         <= start;
            wb_stb_i_r      <= wb_stb_i;
            if(wb_stb_i & wb_we_i) begin
                case(wb_adr_i[6:2])
                    0:  start <= wb_dat_i[0];
                    2:  data[0] <= wb_dat_i;
                    3:  data[1] <= wb_dat_i;
                    4:  key[0] <= wb_dat_i;
                    5:  key[1] <= wb_dat_i;
                    6:  key[2] <= wb_dat_i;
                    7:  key[3] <= wb_dat_i;
                    8:  key[4] <= wb_dat_i;
                    9:  key[5] <= wb_dat_i;
                    1:  decrypt <= wb_dat_i;
                    default:
                        ;
                endcase
            end else begin
                start           <= 1'b0;
            end
        end
    end
always @(*)
    begin
        case(wb_adr_i[6:2])
            4:  wb_dat_o = key[0];
            5:  wb_dat_o = key[1];
            6:  wb_dat_o = key[2];
            7:  wb_dat_o = key[3];
            8:  wb_dat_o = key[4];
            9:  wb_dat_o = key[5];
            2:  wb_dat_o = data[0];
            3:  wb_dat_o = data[1];
            10:  wb_dat_o = {31'b0, ready_for_res};
            11: wb_dat_o = valid[31:0];
            12: wb_dat_o = valid[63:32];
            default:
                wb_dat_o = 32'b0;
        endcase
    end
des3 des3(
           .clk(wb_clk_i),
           .start(start && ~start_r),
           .decrypt(decrypt),
           .key1(key_1),
           .key2(key_2),
           .key3(key_3),
           .desIn(bigData),
           .out_valid(ready_for_res),
           .desOut(valid)
        );
endmodule
