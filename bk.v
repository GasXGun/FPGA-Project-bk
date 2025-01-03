module bk(output reg [7:0] dataxr, dataxg, dataxb,
			 output reg [0:3] comm,
			 output reg [7:0] led,
			 output reg b,
			 input clk,up,down,left,right,enter,re);
			 
	logic [0:7]  red [0:7] ='{8'b11111111,//red=black
										8'b11111111,
										8'b11111111,
										8'b11101111,
										8'b11110111,
										8'b11111111,
										8'b11111111,
										8'b11111111};
													  
	logic [0:7] blue [0:7] ='{8'b11111111,//blue = black
										8'b11111111,
										8'b11111111,
										8'b11110111,
										8'b11101111,
										8'b11111111,
										8'b11111111,
										8'b11111111};
													 
	logic [0:7] dark [0:7] ='{8'b00000000,//dark = 可以下子的點
										8'b00000000,
										8'b00000000,
										8'b00011000,
										8'b00011000,
										8'b00000000,
										8'b00000000,
										8'b00000000};
														
	logic [0:7] initpos [0:7] = '{8'b11111111,
											8'b11111111,
											8'b11111111,
											8'b11011111,
											8'b11111111,
											8'b11111111,
											8'b11111111,
											8'b11111111};
																										
	divfreq 	(clk , clk_div );
	divfreq2 (clk , clk_div2);
	byte cnt;
	bit slow;
	byte prow;
	byte pcol;
	integer pow=1;
	byte column;
	byte row;
	byte col;
	bit blueplayer=1;
	bit next;
	byte from;
	byte to;
	reg [3:0]	same;
	reg [3:0]	empty;
	bit select;
	bit dothat;
	reg [3:0]	samex;
	reg [3:0]	samey;
	reg [3:0]	emptyx;
	reg [3:0]	emptyy;
	byte xpos;
	byte ypos;
	byte cb;
	byte cr;
	byte count;
	reg [2:0] blue_wins; // 藍方勝利次數
   reg [2:0] red_wins; // 紅方勝利次數
	initial//初始值
		begin
			cnt=0;			//顯示亮哪行
			pcol=2;			//落子column
			prow=3;			//落子row
			cb=0;				//count blue
			cr=0;				//count red
			count=4;			//count 棋子
			led = 8'b00000000;
		end

	always @(posedge clk_div)//偵測上下左右
		begin
					if (up)//上
						begin
						if (pcol==7)
							begin
							pcol=0;
							initpos[prow][7] <=1;
							initpos[prow][0] <=0;
							end
						else
							begin
							initpos[prow][pcol] =1;
							initpos[prow][pcol+1] =0; 
							pcol=pcol+1;
							end
					end
					else if (down)//下
						begin
							if (pcol==0)
								begin
								pcol=7;
								initpos[prow][0] <=1;
								initpos[prow][7] <=0;
								end
							else
								begin
								initpos[prow][pcol] =1;
								initpos[prow][pcol-1] =0; 
								pcol=pcol-1;
								end
						end
					else if (left)//左
						begin
							if (prow==0)
								begin
								prow=7;
								initpos[0][pcol] <=1;
								initpos[7][pcol] <=0;
								end
							else
								begin
								initpos[prow][pcol] =1;
								initpos[prow-1][pcol] =0; 
								prow=prow-1;
								end
						end
					else if (right)//右
						begin
							if (prow==7)
								begin
								prow=0;
								initpos[7][pcol] <=1;
								initpos[0][pcol] <=0;
								end
							else
								begin
								initpos[prow][pcol] =1;
								initpos[prow+1][pcol] =0; 
								prow=prow+1;
								end
						end
		end
		
		always @(posedge enter) //當enter trigger 時
		begin
			if(re)//restart
				begin
					cb=0;
					cr=0;
					count=4;
					for(int i=0;i<8;i++)
						begin
							for(int j=0;j<8;j++)
								begin
									dark[i][j]<=0;
									red[i][j]<=1;
									blue[i][j]<=1;
								end
						
						end
					red[3][3]<=0;
					dark[3][3]<=1;
					red[4][4]<=0;
					dark[4][4]<=1;
					blue[3][4]<=0;
					dark[3][4]<=1;
					blue[4][3]<=0;
					dark[4][3]<=1;
					cb=0;
					cr=0;
				end

			if(dark[prow][pcol]==0 && blueplayer==1 )//如果可下子且輪到藍色
				begin
					b=1;
					count=count+1;
					dark[prow][pcol]<=1;
					blue[prow][pcol]<=0;
					if (dark[prow+1][pcol+1]==1 && red[prow+1][pcol+1]==0)
						begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//從1開始找到7
								begin
									if (dark[xpos+j][ypos+j]==0)
										break;
									if (blue[xpos+j][ypos+j]==0)
										begin
										samex=xpos+j;
										samey=ypos+j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos+k<=samex && ypos+k<=samey)
										begin
												red[xpos+k][ypos+k]<=1;
												blue[xpos+k][ypos+k]<=0;
												dark[xpos+k][ypos+k]<=1;
											
										end
									end
								end
							end
					if (dark[prow+1][pcol]==1 && red[prow+1][pcol]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (dothat==0)
										begin
											if (i==prow)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的棋子
										begin
											if (dark[i][pcol]==0)
												begin
													empty=i;
													break;
												end
											else if (blue[i][pcol]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if (select==1)
								begin
								for (int j=0 ; j<=7 ; j++)
									begin
									if (j>=prow)
										begin
											if (j<=same)
												begin
												red[j][pcol]<=1;
												blue[j][pcol]<=0;
												dark[j][pcol]<=1;
												end
										end
									end
								end
						end	
					if (dark[prow+1][pcol-1]==1 && red[prow+1][pcol-1]==0)
					begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//從1開始找到7
								begin
									if (dark[xpos+j][ypos-j]==0)
										break;
									if (blue[xpos+j][ypos-j]==0)
										begin
										samex=xpos+j;
										samey=ypos-j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos+k<=samex && ypos-k>=samey)
										begin
												red[xpos+k][ypos-k]<=1;
												blue[xpos+k][ypos-k]<=0;
												dark[xpos+k][ypos-k]<=1;
											
										end
									end
								end
							end
					if (dark[prow][pcol-1]==1 && red[prow][pcol-1]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=7 ; i>=0 ;i--)//從7開始找到0
								begin
									if (dothat==0)
										begin
											if (i==pcol)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[prow][i]==0)
												begin
													empty=i;
													break;
												end
											else if (blue[prow][i]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=7 ; j>=0 ; j--)
									begin
									if (j<=pcol)
										begin
											if (j>=same)
												begin
												red[prow][j]<=1;
												blue[prow][j]<=0;
												dark[prow][j]<=1;
												end
										end
									end
								end
							end
					if (dark[prow-1][pcol-1]==1 && red[prow-1][pcol-1]==0)
					begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//j是減多少所以不用動
							//
							
								begin
									if (dark[xpos-j][ypos-j]==0)
										break;
									if (blue[xpos-j][ypos-j]==0)
										begin
										samex=xpos-j;
										samey=ypos-j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos-k>=samex && ypos-k>=samey)
										begin
												red[xpos-k][ypos-k]<=1;
												blue[xpos-k][ypos-k]<=0;
												dark[xpos-k][ypos-k]<=1;
											
										end
									end
								end
							end
					if (dark[prow-1][pcol]==1 && red[prow-1][pcol]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=7 ; i>=0 ;i--)//從7開始找到0
								begin
									if (dothat==0)
										begin
											if (i==prow)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[i][pcol]==0)
												begin
													empty=i;
													break;
												end
											else if (blue[i][pcol]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=7 ; j>=0 ; j--)
									begin
									if (j<=prow)
										begin
											if (j>=same)
												begin
												red[j][pcol]<=1;
												blue[j][pcol]<=0;
												dark[j][pcol]<=1;
												end
										end
									end
								end
							end
					
					if (dark[prow-1][pcol+1]==1 && red[prow-1][pcol+1]==0)
						begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//j是減多少所以不用動
							
								begin
									if (dark[xpos-j][ypos+j]==0)
										break;
									if (blue[xpos-j][ypos+j]==0)
										begin
										samex=xpos-j;
										samey=ypos+j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos-k>=samex && ypos+k<=samey)
										begin
												red[xpos-k][ypos+k]<=1;
												blue[xpos-k][ypos+k]<=0;
												dark[xpos-k][ypos+k]<=1;
											
										end
									end
								end
							end
					if (dark[prow][pcol+1]==1 && red[prow][pcol+1]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (dothat==0)
										begin
											if (i==pcol)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[prow][i]==0)
												begin
													empty=i;
													break;
												end
											else if (blue[prow][i]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=0 ; j<=7 ; j++)
									begin
									if (j>=pcol)
										begin
											if (j<=same)
												begin
												red[prow][j]<=1;
												blue[prow][j]<=0;
												dark[prow][j]<=1;
												end
										end
									end
								end
							end
					

					
					blueplayer=~blueplayer;
				end 
			else if (dark[prow][pcol]==0 && blueplayer==0)
				begin
					b=0;
					count=count+1;
					dark[prow][pcol]<=1;
					red[prow][pcol]<=0;
					if (dark[prow+1][pcol+1]==1 && blue[prow+1][pcol+1]==0)
						begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//從1開始找到7
								begin
									if (dark[xpos+j][ypos+j]==0)
										break;
									if (red[xpos+j][ypos+j]==0)
										begin
										samex=xpos+j;
										samey=ypos+j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos+k<=samex && ypos+k<=samey)
										begin
												blue[xpos+k][ypos+k]<=1;
												red[xpos+k][ypos+k]<=0;
												dark[xpos+k][ypos+k]<=1;
											
										end
									end
								end
							end
					if (dark[prow+1][pcol]==1 && blue[prow+1][pcol]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (dothat==0)
										begin
											if (i==prow)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[i][pcol]==0)
												begin
													empty=i;
													break;
												end
											else if (red[i][pcol]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if (select==1)
								begin
								for (int j=0 ; j<=7 ; j++)
									begin
									if (j>=prow)
										begin
											if (j<=same)
												begin
												blue[j][pcol]<=1;
												red[j][pcol]<=0;
												dark[j][pcol]<=1;
												end
										end
									end
								end
						end	
					if (dark[prow+1][pcol-1]==1 && blue[prow+1][pcol-1]==0)
					begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//從1開始找到7
								begin
									if (dark[xpos+j][ypos-j]==0)
										break;
									if (red[xpos+j][ypos-j]==0)
										begin
										samex=xpos+j;
										samey=ypos-j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos+k<=samex && ypos-k>=samey)
										begin
												blue[xpos+k][ypos-k]<=1;
												red[xpos+k][ypos-k]<=0;
												dark[xpos+k][ypos-k]<=1;
											
										end
									end
								end
							end
					if (dark[prow][pcol-1]==1 && blue[prow][pcol-1]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=7 ; i>=0 ;i--)//從7開始找到0
								begin
									if (dothat==0)
										begin
											if (i==pcol)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[prow][i]==0)
												begin
													empty=i;
													break;
												end
											else if (red[prow][i]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=7 ; j>=0 ; j--)
									begin
									if (j<=pcol)
										begin
											if (j>=same)
												begin
												blue[prow][j]<=1;
												red[prow][j]<=0;
												dark[prow][j]<=1;
												end
										end
									end
								end
							end
					if (dark[prow-1][pcol-1]==1 && blue[prow-1][pcol-1]==0)
					begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//j是減多少所以不用動
							
								begin
									if (dark[xpos-j][ypos-j]==0)
										break;
									if (red[xpos-j][ypos-j]==0)
										begin
										samex=xpos-j;
										samey=ypos-j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos-k>=samex && ypos-k>=samey)
										begin
												blue[xpos-k][ypos-k]<=1;
												red[xpos-k][ypos-k]<=0;
												dark[xpos-k][ypos-k]<=1;
											
										end
									end
								end
							end
					if (dark[prow-1][pcol]==1 && blue[prow-1][pcol]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=7 ; i>=0 ;i--)//從7開始找到0
								begin
									if (dothat==0)
										begin
											if (i==prow)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[i][pcol]==0)
												begin
													empty=i;
													break;
												end
											else if (red[i][pcol]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=7 ; j>=0 ; j--)
									begin
									if (j<=prow)
										begin
											if (j>=same)
												begin
												blue[j][pcol]<=1;
												red[j][pcol]<=0;
												dark[j][pcol]<=1;
												end
										end
									end
								end
							end
					
					if (dark[prow-1][pcol+1]==1 && blue[prow-1][pcol+1]==0)
						begin
							select=0;
							dothat=0;
							empty=8;
							samex=8;
							samey=8;
							xpos=0;
							ypos=0;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (i==prow)
										xpos=i;
									if (i==pcol)
										ypos=i;
								end
							for (int j=1 ; j<=7 ;j++)//j是減多少所以不用動
							
								begin
									if (dark[xpos-j][ypos+j]==0)
										break;
									if (red[xpos-j][ypos+j]==0)
										begin
										samex=xpos-j;
										samey=ypos+j;
										select=1;
										end
								end
							if ( select==1 )
								begin
								for (int k=1 ; k<=7 ; k++)
									begin
									if (xpos-k>=samex && ypos+k<=samey)
										begin
												blue[xpos-k][ypos+k]<=1;
												red[xpos-k][ypos+k]<=0;
												dark[xpos-k][ypos+k]<=1;
											
										end
									end
								end
							end
					if (dark[prow][pcol+1]==1 && blue[prow][pcol+1]==0)
						begin
							select=0;
							same=8;
							dothat=0;
							empty=8;
							for (int i=0 ; i<=7 ;i++)//從0開始找到7
								begin
									if (dothat==0)
										begin
											if (i==pcol)//找到自己進入下一階段
												begin
												dothat=1;
												continue;
												end
											else
												continue;
										end
									if (dothat==1)//找到自己以後開始找離自己最近的旗子
										begin
											if (dark[prow][i]==0)
												begin
													empty=i;
													break;
												end
											else if (red[prow][i]==0)
												begin
													same=i;
													select=1;
													break;
												end
										end
								end
							if ( select==1 )
								begin
								for (int j=0 ; j<=7 ; j++)
									begin
									if (j>=pcol)
										begin
											if (j<=same)
												begin
												blue[prow][j]<=1;
												red[prow][j]<=0;
												dark[prow][j]<=1;
												end
										end
									end
								end
						end
					blueplayer=~blueplayer;
				end
	
			if(count==64)// 結束後計分
				begin
					blue_wins <= blue_wins+3'b001;
					for (int i=0;i<=7;i++)
						begin
							for (int j=0; j<=7;j++)
								begin
									if ( blue[i][j]==0 )
										cb=cb+1;
									//else if ( red[i][j]==0)
									//	countred=countred+1;
									if(red[i][j]==0)
										cr=cr+1;
								end
						end
					if(cb>cr)//如果藍色多於紅色 顯示藍色X
						begin
							red_wins <= red_wins+3'b001;
							for(int i=0;i<8;i++)
								begin
									for(int j=0;j<8;j++)
										begin
											blue[i][j]<=1;
											red[i][j]<=1;
											dark[i][j]<=1;
										end
								end
							blue[0][0]=0; dark[0][0]=1;
							blue[1][1]=0; dark[1][1]=1;
							blue[2][2]=0; dark[2][2]=1;
							blue[3][3]=0; dark[3][3]=1;
							blue[4][4]=0; dark[4][4]=1;
							blue[5][5]=0; dark[5][5]=1;
							blue[6][6]=0; dark[6][6]=1;
							blue[7][7]=0; dark[7][7]=1;

							blue[7][0]=0; dark[7][0]=1;
							blue[6][1]=0; dark[6][1]=1;
							blue[5][2]=0; dark[5][2]=1;
							blue[4][3]=0; dark[4][3]=1;
							blue[3][4]=0; dark[3][4]=1;
							blue[2][5]=0; dark[2][5]=1;
							blue[1][6]=0; dark[1][6]=1;
							blue[0][7]=0; dark[0][7]=1;				
						end
					else if (cr>cb)//如果紅色大於藍色 顯示紅色X
						begin
							for(int i=0;i<8;i++)
								begin
									for(int j=0;j<8;j++)
										begin
											blue[i][j]<=1;
											red[i][j]<=1;
											dark[i][j]<=1;
										end
								end
							red[0][0]=0; dark[0][0]=1;
							red[1][1]=0; dark[1][1]=1;
							red[2][2]=0; dark[2][2]=1;
							red[3][3]=0; dark[3][3]=1;
							red[4][4]=0; dark[4][4]=1;
							red[5][5]=0; dark[5][5]=1;
							red[6][6]=0; dark[6][6]=1;
							red[7][7]=0; dark[7][7]=1;

							red[7][0]=0; dark[7][0]=1;
							red[6][1]=0; dark[6][1]=1;
							red[5][2]=0; dark[5][2]=1;
							red[4][3]=0; dark[4][3]=1;
							red[3][4]=0; dark[3][4]=1;
							red[2][5]=0; dark[2][5]=1;
							red[1][6]=0; dark[1][6]=1;
							red[0][7]=0; dark[0][7]=1;
							//顯示X
						end
					else if (cr==cb)//如果相等
						begin
							for(int i=0;i<8;i++)
								begin
									for(int j=0;j<8;j++)
										begin
											blue[i][j]<=0;
											red[i][j]<=1;
											dark[i][j]<=1;
										end
								end
							blue[0][0]=0; dark[0][0]=1;
							red[1][1]=0; dark[1][1]=1;
							blue[2][2]=0; dark[2][2]=1;
							red[3][3]=0; dark[3][3]=1;
							blue[4][4]=0; dark[4][4]=1;
							red[5][5]=0; dark[5][5]=1;
							blue[6][6]=0; dark[6][6]=1;
							red[7][7]=0; dark[7][7]=1;

							red[7][0]=0; dark[7][0]=1;
							blue[6][1]=0; dark[6][1]=1;
							red[5][2]=0; dark[5][2]=1;
							blue[4][3]=0; dark[4][3]=1;
							red[3][4]=0; dark[3][4]=1;
							blue[2][5]=0; dark[2][5]=1;
							red[1][6]=0; dark[1][6]=1;
							blue[0][7]=0; dark[0][7]=1;
							//顯示X
						end
				end		
		end
					
	//show
	always @(posedge clk_div2)
		begin
			if(cnt >= 7 )
				begin
				dataxg=8'b11111111; 
				dataxb=8'b11111111;
				dataxr=8'b11111111;
				cnt <=3'b000;
				end
			else
				begin
				cnt <= cnt +3'b001;
				end
			comm <={cnt,1'b1};
			dataxr <= red[cnt];
			dataxb <= blue[cnt];
			dataxg <= initpos[cnt];
        // 根據藍方勝利次數從左邊推進 LED 燈
        case (blue_wins)
            3'b001: led[7:7] = 1'b1;
            3'b010: led[7:6] = 2'b11;
            3'b011: led[7:5] = 3'b111;
        //    default: led[7:1] = 7'b0000000;
        endcase
        // 根據紅方勝利次數從右邊推進 LED 燈
        case (red_wins)
            3'b001: led[0:0] = 1'b1;
            3'b010: led[1:0] = 2'b11;
            3'b011: led[2:0] = 3'b111;
        //    default: led[6:0] = 7'b0000000;
        endcase
		end
endmodule

//除頻器1
module divfreq(input clk, output reg clk_div);
	reg [24:0] Count;
	reg [24:0] num;
	always @(posedge clk)
		begin
			if(Count > 3000000)
				begin
					Count <= 25'b0;
					clk_div <= ~clk_div;
				end
			else Count <= Count + 1'b1;
		end
endmodule


//除頻器2
module divfreq2(input clk, output reg clk_div2);
	reg [24:0] Count2;
	reg [24:0] num2;
	always @(posedge clk)
		begin
			if(Count2 > 1000)
				begin
					Count2 <= 25'b0;
					clk_div2 <= ~clk_div2;
				end
			else Count2 <= Count2 + 1'b1;
		end
endmodule


			