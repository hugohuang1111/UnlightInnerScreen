//
//  UnlightInnerScreenApp.swift
//  UnlightInnerScreen
//
//  Created by hugo on 2023/6/3.
//

import SwiftUI
import AppKit

@main
struct UnlightInnerScreenApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            EmptyView().frame(width: .zero)
        }
    }

}
