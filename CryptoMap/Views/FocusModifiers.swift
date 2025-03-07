import SwiftUI

// Custom focus modifier for tvOS
struct FocusChangedModifier: ViewModifier {
    let handler: (Bool) -> Void
    
    @FocusState private var isFocused: Bool
    
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { oldValue, newValue in
                handler(newValue)
            }
    }
}

extension View {
    func onFocusChanged(perform action: @escaping (Bool) -> Void) -> some View {
        self.modifier(FocusChangedModifier(handler: action))
    }
} 