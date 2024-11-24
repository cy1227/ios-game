import SwiftUI

struct GameOverView: View {
    @Environment(GameState.self) private var gameState
    var onReplay: () -> Void // 回呼函數，用於重玩遊戲
    @State private var isShowingGameView = false
    var body: some View {
        ZStack {
            // 背景漸層
            LinearGradient(
                gradient: Gradient(colors: [Color.purple, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
                ZStack {
                    
                    VStack {
                        Text("Game Over")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
//                        
                        Text("Your Score: \(gameState.score)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.bottom, 20)
                        
                        Button("Replay") {
//                             重置遊戲狀態
                            gameState.score = 0
                            gameState.isPlaying = true
                            gameState.isGameOver = false
                            isShowingGameView = true
                            onReplay()
                        }
                        .sheet(isPresented: $isShowingGameView) {
                            ContentView() // 遊戲主畫面
                        }
                        .padding()
                        .background(Color.yellow)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .transition(.opacity) // 使用淡入淡出效果
        }
    }
}
