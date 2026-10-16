//
//  HapticManager.swift
//  NamesOfAllah
//
//  Cross-platform haptic feedback manager
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    func impact(style: ImpactStyle) {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: style.uiKitStyle)
        generator.impactOccurred()
        #endif
    }
    
    func selection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
    
    func notification(type: NotificationType) {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type.uiKitType)
        #endif
    }
    
    enum ImpactStyle {
        case light, medium, heavy
        
        #if canImport(UIKit)
        var uiKitStyle: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .light: return .light
            case .medium: return .medium
            case .heavy: return .heavy
            }
        }
        #endif
    }
    
    enum NotificationType {
        case success, warning, error
        
        #if canImport(UIKit)
        var uiKitType: UINotificationFeedbackGenerator.FeedbackType {
            switch self {
            case .success: return .success
            case .warning: return .warning
            case .error: return .error
            }
        }
        #endif
    }
}