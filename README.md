# FPGA-Final Project-黑白棋
黑白棋遊戲呈現在8x8LED上<br>
##### 修改專案 自 105321007_鄒瑞慶_105321021_簡健軒之Project<br>
### Authors: b班-112321004 王毓傑, b班-112321008 張文碩<br>

#### 基本規則(邏輯功能):
* 棋盤與棋子
棋盤是 8x8 的方格棋盤。
棋子是雙面棋子，一面黑色，一面白色。
玩家分別使用黑棋和白棋。<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO1.png" width="200"/><br>

#### 遊戲目標
* 在棋局結束時，棋盤上擁有更多自己顏色的棋子的玩家獲勝。<br>
* 初始佈局
棋盤中央的四個格子擺放兩黑兩白，黑白斜對角排列
黑棋先行。<br>
#### 下棋規則
* 合法落子位置
每次下棋，必須至少翻轉對方的一顆棋子。<br>
* 棋子翻轉條件：
你的棋子夾住對方的棋子（在一條直線上，包括水平、垂直、斜線方向），中間的對方棋子會被翻轉成你的棋子。<br>
* 翻轉棋子
	所有方向中被夾住的對方棋子都會翻轉。
無法下棋時
若一方無法進行合法落子，該玩家跳過回合，由對方繼續下棋。如果雙方都無法合法落子，遊戲結束。<br>
(一種結局示意圖)<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO2.png" width="200"/><br>

### 實現方式(顯示功能):
#### 在 8x8 LED 矩陣中
* LED綠色:當前位置(落子位置)<br>
* LED藍色:黑棋<br>
* LED紅色:白棋<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO3.png" width="200"/><br>
### 實現方式(操作功能):
* 透過按鈕操作移動於確定落子位置(綠色)<br>
(示意圖)<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO6.png" width="200"/><br>
#### 用指撥開關來重置棋局與落子
* 棋盤的reset<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO7.png" width="200"/><br>
### 實現方式(邏輯功能):
* 黑白方輪流落子<br>
判定落子位置是否符合規則(至少翻轉一子)
翻轉被夾的棋子(直橫斜)
判定可否落子，若雙方都不可再落子則遊戲結束
計分與判勝負，並記錄雙方勝局
#### (extra 1)七段顯示器
* 顯示下棋方剩餘時間與倒數<br>
(示意圖)<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO4.png" width="200"/><br>
#### (extra 2)不管怎麼翻都變成藍色(黑棋)
(示意圖)<br>
<img src="https://github.com/GasXGun/FPGA-Project-bk/blob/main/images/IO8.png" width="200"/><br>
### 實作注意(建議)
* 需要注意comm之調節，否則橫排排列會出大問題<br>
* 在做功能前應先注意線的數量(使用功能)<br>
* bk是原版本，bk_extra是修改後版本<br>
### 參考資料:
* [黑白棋- 維基百科，自由的百科全書](https://zh.wikipedia.org/zh-tw/%E9%BB%91%E7%99%BD%E6%A3%8B)<br>
