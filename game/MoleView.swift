import SwiftUI
struct MoleView: View {
    @Binding var isVisible: Bool
    @Environment(GameState.self) private var gameState
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // 泥土洞
            Circle()
                .fill(Color.brown)
                .frame(width: 80, height: 85)
            
            // 地鼠
            if isVisible {
                Button(action: {
                    // 當按下地鼠時，增加分數
                    gameState.score += 1
                    
                    // 執行其他邏輯（例如觸發動畫或隱藏地鼠）
                    onTap()
                }) {
                    Text("🐹") // 地鼠表情
                        .font(.system(size: 70))
                }
                .transition(.move(edge: .bottom))//地鼠出現 消失動畫
            }
        }
    }
}
