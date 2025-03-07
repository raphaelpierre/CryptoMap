import SwiftUI

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .brightness(configuration.isPressed ? 0.1 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
            .shadow(
                color: Color.black.opacity(configuration.isPressed ? 0.2 : 0.1),
                radius: configuration.isPressed ? 5 : 3,
                x: 0,
                y: configuration.isPressed ? 2 : 1
            )
    }
}

struct TVOSSelectionButtonStyle: ButtonStyle {
    @Environment(\.isFocused) private var isFocused
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(isFocused ? 1.15 : 1.0)
            .brightness(isFocused ? 0.3 : 0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused ? Color.white : Color.clear, lineWidth: 6)
            )
            .shadow(
                color: isFocused ? Color.white.opacity(0.5) : Color.clear,
                radius: 20,
                x: 0,
                y: 0
            )
    }
}

extension ButtonStyle where Self == CardButtonStyle {
    static var card: CardButtonStyle {
        CardButtonStyle()
    }
}

extension ButtonStyle where Self == TVOSSelectionButtonStyle {
    static var tvosSelection: TVOSSelectionButtonStyle { TVOSSelectionButtonStyle() }
} 