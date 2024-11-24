import SwiftUI
import Observation
import AVFoundation


@Observable
class GameState {
    var score: Int = 0
    var timeLeft: Int = 20
    var isPlaying: Bool = false
    var isGameOver: Bool = false
}

struct ContentView: View {
    @State private var moleStates: [Bool] = Array(repeating: false, count: 16)
    @State private var scores: Int = 0 // 記錄得分
    @State private var isButtonVisible = true
    var gameState = GameState()
    var body: some View {
        NavigationStack {
            if gameState.isGameOver {
                // 跳轉到遊戲結束頁面
                GameOverView(onReplay: startGame)  .environment(gameState)
            } else {
                // 主遊戲畫面
                ZStack {
                    Image("background3")
                        .resizable()
                        .frame(width: 440, height: 880)
                        .ignoresSafeArea()
                    
                    // 添加地鼠或其他遊戲邏輯
                    VStack (spacing: 0){
                        Image("logo")
                            .resizable() // 可調整大小
                            .scaledToFit() // 等比例縮放以適應空間
                            .frame( height: 180)

                        HStack {
                            // 分數顯示
                            Text("Score: \(gameState.score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
//                                .frame(width: 150, height: 50)
                            
                            Spacer()
                            
                            // 剩餘時間顯示
                            Text("Time: \(gameState.timeLeft)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.yellow)
                                .cornerRadius(10)
//                                .frame(width: 150, height: 50)
                        }
                        .background(Color.yellow)
                        .overlay( // 加上黑框
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 7) // 設定框線顏色和粗細
                        )
                        //.cornerRadius(10) // 邊框圓角
//                        .padding(.horizontal) // 外部間距（可調整）
                        .padding()
                        ForEach(0..<4, id: \.self) { row in
                            HStack {
                                ForEach(0..<4, id: \.self) { column in
                                    let index = row * 4 + column // 計算每個格子的索引
                                    MoleView(isVisible: $moleStates[index]) {
                                        if moleStates[index] {
                                            scores += 1
                                            moleStates[index] = false // 點擊後地鼠消失
                                        }
                                    }.padding(6)
                                }
                            }.padding(.top, 10)
                        }
                        Spacer() .frame(height: 20)
                        // 啟動隨機地鼠出現
                        if isButtonVisible{
                            Button("Start Game") {
                                isButtonVisible = false
                                startGame()
                            }
                            .font(.title)  // 設定字型大小
                            .padding()     // 為按鈕增加內間距
                            .background(Color.yellow)  // 設定背景顏色為黃色
                            .foregroundColor(.white)  // 設定字體顏色為白色
                            .cornerRadius(10)  // 設定圓角，使按鈕邊角圓滑
                            .frame(height: 60) // 設定按鈕的高度為 60
                            .padding(.horizontal, 40)
                        }

                    }
                }.environment(gameState)
             
            }
        }
       
    }
    //遊戲開始
    func startGame() {
        gameState.isPlaying = true
        gameState.timeLeft = 20
        moleStates = Array(repeating: false, count: moleStates.count)//恢復地鼠狀態
        var player = AVPlayer()
        if let url = Bundle.main.url(forResource: "broughtheheatback", withExtension: "mp3") {
            player = AVPlayer(url: url)
            player.play()
        } else {
            print("音樂檔案未找到")
        }

        
        // 遊戲時間倒數計時器
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if gameState.timeLeft > 0 {
                // 每秒減少剩餘時間
                gameState.timeLeft -= 1
            } else {
                // 時間結束，停止遊戲

                gameState.isPlaying = false
                gameState.isGameOver = true
                timer.invalidate() // 停止倒數計時器
                player.pause()
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            // 每次都隨機選擇一隻地鼠
            if let randomIndex = (0..<16).randomElement() {
                // 顯示地鼠
                withAnimation {
                    moleStates[randomIndex] = true
                }
                
                // 設定延遲讓地鼠消失
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    moleStates[randomIndex] = false //
                }
            }
            if gameState.isGameOver{
                timer.invalidate() // 停止計時器
            }
                
        }
    }
    
}

#Preview {
    ContentView()
}
