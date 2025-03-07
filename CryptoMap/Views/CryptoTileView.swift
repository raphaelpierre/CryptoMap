import SwiftUI

struct CryptoTileView: View {
    let cryptocurrency: Cryptocurrency
    let color: Color
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(cryptocurrency.symbol.uppercased())
                .font(.headline)
                .foregroundColor(.white)
            
            Text(cryptocurrency.formattedPrice)
                .font(.subheadline)
                .foregroundColor(.white)
            
            Text(cryptocurrency.formattedPriceChange)
                .font(.caption)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(color)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(), value: isSelected)
    }
} 