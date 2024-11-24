//
//  gameApp.swift
//  game
//
//  Created by chianyih on 2024/11/20.
//

import SwiftUI
import Observation

@main
struct gameApp: App {
 private var gameState = GameState()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(gameState)
        }
    }
}
