//
//  AppDelegate.swift
//  UnlightInnerScreen
//
//  Created by hugo on 2023/6/3.
//

import Foundation
import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuExtrasConfigurator: MacExtrasConfigurator?
    final private class MacExtrasConfigurator: NSObject {
        
        private var statusBar: NSStatusBar
        private var statusItem: NSStatusItem

        // MARK: - Lifecycle
        override init() {
            statusBar = NSStatusBar.system
            statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
            
            super.init()
            
            createMenu()
        }

        // MARK: - MenuConfig
        private func createMenu() {
            if let statusBarButton = statusItem.button {
                statusBarButton.image = NSImage(
                    systemSymbolName: "hammer",
                    accessibilityDescription: nil
                )
                let lightOff = NSMenuItem()
                lightOff.title = "LightOff"
                lightOff.target = self
                lightOff.action = #selector(Self.onItemLightOff(_:))
                let lightOn = NSMenuItem()
                lightOn.title = "LightOn"
                lightOn.target = self
                lightOn.action = #selector(Self.onItemLightOn(_:))
                let exit = NSMenuItem()
                exit.title = "Quit"
                exit.keyEquivalent = "q"
                exit.target = self
                exit.action = #selector(Self.onItemExit(_:))
                
                let m = NSMenu()
                m.addItem(lightOff)
                m.addItem(lightOn)
                m.addItem(exit)
                statusItem.menu = m
            }
        }
        
        // MARK: - Actions
        @objc private func onItemLightOff(_ sender: Any?) {
            self.innerScreenBrightness = 0;
        }
        @objc private func onItemLightOn(_ sender: Any?) {
            self.innerScreenBrightness = 1;
        }
        @objc private func onItemExit(_ sender: Any?) {
            NSApp.terminate(self)
        }
        
        // MARK: - Privates
        public var innerScreenBrightness: Float {
            get {
                var brightness: Float = 0
                var iterator: io_iterator_t = 0
                if IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceMatching("IODisplayConnect"), &iterator) == kIOReturnSuccess {
                    var service: io_object_t = 1
                    while service != 0 {
                        service = IOIteratorNext(iterator)
                        IODisplayGetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, &brightness)
                        IOObjectRelease(service)
                        return brightness;
                    }
                }
                return 1;
            }
            set {
                var iterator: io_iterator_t = 0
                if IOServiceGetMatchingServices(kIOMainPortDefault, IOServiceMatching("IODisplayConnect"), &iterator) == kIOReturnSuccess {
                    var service: io_object_t = 1
                    while service != 0 {
                        service = IOIteratorNext(iterator)
                        IODisplaySetFloatParameter(service, 0, kIODisplayBrightnessKey as CFString, newValue)
                        IOObjectRelease(service)
                        break;
                    }
                }
            }
        }
        
    }

    // MARK: - NSApplicationDelegate
    func applicationDidFinishLaunching(_ notification: Notification) {
        menuExtrasConfigurator = .init()
    }
}
