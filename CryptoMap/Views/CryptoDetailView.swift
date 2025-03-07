import SwiftUI

struct CryptoDetailView: View {
    let cryptocurrency: Cryptocurrency
    @Environment(\.dismiss) private var dismiss
    
    // Create the formatter outside the body
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var body: some View {
        ZStack {
            // Modern gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Header with close button
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(cryptocurrency.name)
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            Text(cryptocurrency.symbol.uppercased())
                                .font(.headline)
                                .foregroundColor(.white.opacity(0.7))
                            
                            if let rank = cryptocurrency.marketCapRank {
                                Text("Rank #\(rank)")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Price card
                VStack(spacing: 16) {
                    HStack {
                        Text("Current Price")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        Text(cryptocurrency.formattedPrice)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    HStack {
                        Text("24h Change")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            if let priceChange = cryptocurrency.priceChangePercentage24h {
                                Image(systemName: priceChange >= 0 ? "arrow.up.right" : "arrow.down.right")
                                    .font(.subheadline)
                                    .foregroundColor(priceChange >= 0 ? 
                                                    Color(red: 0.2, green: 0.8, blue: 0.4) : 
                                                    Color(red: 0.8, green: 0.2, blue: 0.3))
                            }
                            
                            Text(cryptocurrency.formattedPriceChange)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(
                                    cryptocurrency.priceChangePercentage24h ?? 0 >= 0 ? 
                                        Color(red: 0.2, green: 0.8, blue: 0.4) : 
                                        Color(red: 0.8, green: 0.2, blue: 0.3)
                                )
                        }
                    }
                }
                .padding(24)
                .background(Color(white: 0.15))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                
                // Market data card
                VStack(spacing: 16) {
                    Text("Market Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                        .background(Color.white.opacity(0.2))
                    
                    DetailRow(title: "Market Cap", value: cryptocurrency.formattedMarketCap)
                    DetailRow(title: "24h Volume", value: cryptocurrency.formattedVolume)
                    
                    if let lastUpdated = cryptocurrency.lastUpdated {
                        DetailRow(title: "Last Updated", value: dateFormatter.string(from: lastUpdated))
                    }
                }
                .padding(24)
                .background(Color(white: 0.15))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 120, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.vertical, 4)
    }
} 