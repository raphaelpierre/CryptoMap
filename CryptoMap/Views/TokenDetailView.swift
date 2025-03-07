import SwiftUI
import Charts

struct TokenDetailView: View {
    let cryptocurrency: Cryptocurrency
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TokenDetailViewModel()
    @State private var selectedTimeframe: TimeframeOption = .day
    
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
            
            ScrollView {
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
                    
                    // Chart card
                    VStack(spacing: 16) {
                        Text("Price Chart")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                        
                        // Add timeframe selector
                        Picker("Timeframe", selection: $selectedTimeframe) {
                            ForEach(TimeframeOption.allCases, id: \.self) { timeframe in
                                Text(timeframe.rawValue)
                                    .tag(timeframe)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 8)
                        .onChange(of: selectedTimeframe) { _, newTimeframe in
                            Task {
                                await viewModel.fetchPriceHistory(for: cryptocurrency.id, timeframe: newTimeframe)
                            }
                        }
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(1.5)
                                .frame(height: 200)
                        } else if !viewModel.priceData.isEmpty {
                            VStack {
                                Chart {
                                    ForEach(viewModel.priceData) { dataPoint in
                                        LineMark(
                                            x: .value("Time", dataPoint.date),
                                            y: .value("Price", dataPoint.price)
                                        )
                                        .foregroundStyle(getChartGradient())
                                        .interpolationMethod(.catmullRom)
                                    }
                                    
                                    if let minPrice = viewModel.priceData.map({ $0.price }).min(),
                                       let minPricePoint = viewModel.priceData.first(where: { $0.price == minPrice }) {
                                        PointMark(
                                            x: .value("Time", minPricePoint.date),
                                            y: .value("Price", minPrice)
                                        )
                                        .foregroundStyle(Color.red)
                                        .symbolSize(100)
                                    }
                                    
                                    if let maxPrice = viewModel.priceData.map({ $0.price }).max(),
                                       let maxPricePoint = viewModel.priceData.first(where: { $0.price == maxPrice }) {
                                        PointMark(
                                            x: .value("Time", maxPricePoint.date),
                                            y: .value("Price", maxPrice)
                                        )
                                        .foregroundStyle(Color.green)
                                        .symbolSize(100)
                                    }
                                }
                                .frame(height: 200)
                                .chartYScale(domain: viewModel.yAxisRange)
                                .chartXAxis {
                                    AxisMarks(position: .bottom) { value in
                                        AxisGridLine()
                                        AxisValueLabel() {
                                            if let date = value.as(Date.self) {
                                                Text(viewModel.formatAxisDate(date, for: selectedTimeframe))
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                        }
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks(position: .leading) { value in
                                        AxisGridLine()
                                        AxisValueLabel() {
                                            if let price = value.as(Double.self) {
                                                Text(viewModel.formatPrice(price))
                                                    .font(.caption)
                                                    .foregroundColor(.white.opacity(0.7))
                                            }
                                        }
                                    }
                                }
                                
                                // Price stats
                                HStack(spacing: 24) {
                                    priceStatView(title: "Low", value: viewModel.formatPrice(viewModel.minPrice), color: .red)
                                    priceStatView(title: "High", value: viewModel.formatPrice(viewModel.maxPrice), color: .green)
                                    priceStatView(title: "Avg", value: viewModel.formatPrice(viewModel.avgPrice), color: .blue)
                                }
                                .padding(.top, 16)
                            }
                        } else {
                            VStack(spacing: 16) {
                                Image(systemName: "chart.line.downtrend.xyaxis")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 8)
                                
                                if !viewModel.errorMessage.isEmpty {
                                    Text(viewModel.errorMessage)
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal)
                                } else {
                                    Text("No chart data available")
                                        .font(.headline)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                
                                Button(action: {
                                    Task {
                                        await viewModel.fetchPriceHistory(for: cryptocurrency.id, timeframe: selectedTimeframe)
                                    }
                                }) {
                                    Text("Try Again")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 12)
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                .padding(.top, 8)
                            }
                            .frame(height: 200)
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
                        DetailRow(title: "Circulating Supply", value: formatSupply(cryptocurrency.circulatingSupply))
                        DetailRow(title: "Total Supply", value: formatSupply(cryptocurrency.totalSupply))
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.vertical, 8)
                        
                        // Price changes for different timeframes
                        if let change7d = cryptocurrency.priceChangePercentage7d {
                            DetailRow(
                                title: "7d Change",
                                value: String(format: "%.2f%%", change7d),
                                valueColor: change7d >= 0 ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color(red: 0.8, green: 0.2, blue: 0.3)
                            )
                        }
                        
                        if let change30d = cryptocurrency.priceChangePercentage30d {
                            DetailRow(
                                title: "30d Change",
                                value: String(format: "%.2f%%", change30d),
                                valueColor: change30d >= 0 ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color(red: 0.8, green: 0.2, blue: 0.3)
                            )
                        }
                        
                        if let change1y = cryptocurrency.priceChangePercentage1y {
                            DetailRow(
                                title: "1y Change",
                                value: String(format: "%.2f%%", change1y),
                                valueColor: change1y >= 0 ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color(red: 0.8, green: 0.2, blue: 0.3)
                            )
                        }
                        
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
                    
                    // Additional info card
                    VStack(spacing: 16) {
                        Text("Additional Information")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                        
                        // Links section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Links")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white.opacity(0.7))
                            
                            HStack(spacing: 16) {
                                linkButton(title: "Website", icon: "globe")
                                linkButton(title: "Explorer", icon: "magnifyingglass")
                                linkButton(title: "Twitter", icon: "bubble.left")
                                linkButton(title: "Reddit", icon: "person.2")
                            }
                            .padding(.top, 8)
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
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchPriceHistory(for: cryptocurrency.id, timeframe: selectedTimeframe)
            }
        }
    }
    
    private func getChartGradient() -> LinearGradient {
        let startColor = cryptocurrency.priceChangePercentage24h ?? 0 >= 0 ?
            Color(red: 0.2, green: 0.8, blue: 0.4) :
            Color(red: 0.8, green: 0.2, blue: 0.3)
        
        return LinearGradient(
            gradient: Gradient(colors: [startColor, startColor.opacity(0.7)]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func priceStatView(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
    }
    
    private func linkButton(title: String, icon: String) -> some View {
        Button(action: {
            // Action would open the relevant link
        }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 100, height: 100)
            .background(Color(white: 0.2))
            .cornerRadius(12)
        }
        .buttonStyle(CardButtonStyle())
        .focusable(true)
    }
    
    private func formatSupply(_ supply: Double?) -> String {
        guard let supply = supply else { return "N/A" }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        if supply >= 1_000_000_000 {
            let billions = supply / 1_000_000_000
            formatter.maximumFractionDigits = 2
            return "\(formatter.string(from: NSNumber(value: billions)) ?? "0") B"
        } else if supply >= 1_000_000 {
            let millions = supply / 1_000_000
            formatter.maximumFractionDigits = 2
            return "\(formatter.string(from: NSNumber(value: millions)) ?? "0") M"
        } else {
            return formatter.string(from: NSNumber(value: supply)) ?? "0"
        }
    }
}

// MARK: - Supporting Types

enum TimeframeOption: String, CaseIterable {
    case day = "24h"
    case week = "7d"
    case month = "30d"
    case year = "1y"
}

struct PriceDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let price: Double
}

struct CacheEntry {
    let data: [PriceDataPoint]
    let timestamp: Date
    
    var isValid: Bool {
        let now = Date()
        let timeInterval = now.timeIntervalSince(timestamp)
        
        // Cache validity periods:
        // 24h data: 5 minutes
        // 7d data: 15 minutes
        // 30d data: 30 minutes
        // 1y data: 1 hour
        switch timeInterval {
        case ..<300: // 5 minutes
            return true
        case ..<900: // 15 minutes
            return true
        case ..<1800: // 30 minutes
            return true
        case ..<3600: // 1 hour
            return true
        default:
            return false
        }
    }
}

class TokenDetailViewModel: ObservableObject {
    @Published var priceData: [PriceDataPoint] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let apiBaseUrl = "https://api.coingecko.com/api/v3"
    private let apiKey = "CG-oqF4Q4R4T9EgGA5pM5ZjKHge"
    private var retryCount = 0
    private let maxRetries = 3
    
    // Cache dictionary: [coinId-timeframe: CacheEntry]
    private var cache: [String: CacheEntry] = [:]
    
    var minPrice: Double {
        priceData.map { $0.price }.min() ?? 0
    }
    
    var maxPrice: Double {
        priceData.map { $0.price }.max() ?? 0
    }
    
    var avgPrice: Double {
        let sum = priceData.map { $0.price }.reduce(0, +)
        return priceData.isEmpty ? 0 : sum / Double(priceData.count)
    }
    
    var yAxisRange: ClosedRange<Double> {
        if priceData.isEmpty {
            return 0...1
        }
        
        let min = minPrice
        let max = maxPrice
        let padding = (max - min) * 0.1
        
        return (min - padding)...(max + padding)
    }
    
    func fetchPriceHistory(for coinId: String, timeframe: TimeframeOption) async {
        let cacheKey = "\(coinId)-\(timeframe.rawValue)"
        
        // Check cache first
        if let cachedEntry = cache[cacheKey], cachedEntry.isValid {
            await MainActor.run {
                self.priceData = cachedEntry.data
                self.isLoading = false
                self.errorMessage = ""
            }
            return
        }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            let days: String
            let cacheTimeout: TimeInterval
            
            switch timeframe {
            case .day:
                days = "1"
                cacheTimeout = 300 // 5 minutes
            case .week:
                days = "7"
                cacheTimeout = 900 // 15 minutes
            case .month:
                days = "30"
                cacheTimeout = 1800 // 30 minutes
            case .year:
                days = "365"
                cacheTimeout = 3600 // 1 hour
            }
            
            let urlString = "\(apiBaseUrl)/coins/\(coinId)/market_chart?vs_currency=usd&days=\(days)&interval=\(timeframe == .day ? "hourly" : "daily")"
            
            guard let url = URL(string: urlString) else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("Mozilla/5.0", forHTTPHeaderField: "User-Agent")
            request.setValue(apiKey, forHTTPHeaderField: "X-CG-API-KEY")
            
            // Add cache control headers
            request.cachePolicy = .returnCacheDataElseLoad
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            // Handle rate limiting
            if httpResponse.statusCode == 429 {
                // Check cache again before retrying, even if expired
                if let cachedEntry = cache[cacheKey] {
                    await MainActor.run {
                        self.priceData = cachedEntry.data
                        self.isLoading = false
                        self.errorMessage = "Using cached data (Rate limit exceeded)"
                    }
                    return
                }
                
                if retryCount < maxRetries {
                    retryCount += 1
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await fetchPriceHistory(for: coinId, timeframe: timeframe)
                    return
                } else {
                    throw URLError(.networkConnectionLost)
                }
            }
            
            retryCount = 0
            
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            guard let prices = json?["prices"] as? [[Double]] else {
                throw URLError(.badServerResponse)
            }
            
            let pricePoints = prices.map { dataPoint -> PriceDataPoint in
                let timestamp = dataPoint[0]
                let price = dataPoint[1]
                let date = Date(timeIntervalSince1970: timestamp / 1000)
                return PriceDataPoint(date: date, price: price)
            }
            
            guard !pricePoints.isEmpty else {
                throw URLError(.cannotDecodeContentData)
            }
            
            // Update cache
            cache[cacheKey] = CacheEntry(data: pricePoints, timestamp: Date())
            
            await MainActor.run {
                self.priceData = pricePoints
                self.isLoading = false
            }
            
        } catch {
            await MainActor.run {
                // If error occurs, try to use cached data even if expired
                if let cachedEntry = cache[cacheKey] {
                    self.priceData = cachedEntry.data
                    self.isLoading = false
                    self.errorMessage = "Using cached data (Error: \(self.getErrorMessage(for: error)))"
                } else {
                    self.errorMessage = self.getErrorMessage(for: error)
                    self.isLoading = false
                    self.priceData = []
                }
            }
        }
    }
    
    // Clear expired cache entries
    private func cleanCache() {
        let expiredKeys = cache.filter { !$0.value.isValid }.map { $0.key }
        expiredKeys.forEach { cache.removeValue(forKey: $0) }
    }
    
    private func getErrorMessage(for error: Error) -> String {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .networkConnectionLost:
                return "Rate limit exceeded. Please try again in a minute."
            case .notConnectedToInternet:
                return "No internet connection. Please check your connection and try again."
            case .timedOut:
                return "Request timed out. Please try again."
            case .badServerResponse:
                return "Unable to fetch data from server. Please try again later."
            default:
                return "Failed to fetch price history. Please try again."
            }
        }
        return "An unexpected error occurred. Please try again."
    }
    
    func formatAxisDate(_ date: Date, for timeframe: TimeframeOption) -> String {
        let formatter = DateFormatter()
        
        switch timeframe {
        case .day:
            formatter.dateFormat = "HH:mm"
        case .week:
            formatter.dateFormat = "EEE"
        case .month:
            formatter.dateFormat = "d MMM"
        case .year:
            formatter.dateFormat = "MMM"
        }
        
        return formatter.string(from: date)
    }
    
    func formatPrice(_ price: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    var valueColor: Color = .white
    
    var body: some View {
        HStack(spacing: 16) {
            Text(title)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .frame(width: 150, alignment: .leading)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(valueColor)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let mockCrypto = Cryptocurrency(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://example.com/bitcoin.png",
        currentPrice: 50000,
        marketCap: 1000000000000,
        marketCapRank: 1,
        totalVolume24h: 30000000000,
        priceChangePercentage24h: 5.25,
        priceChangePercentage7d: 15.5,
        priceChangePercentage30d: 25.75,
        priceChangePercentage1y: 85.30,
        circulatingSupply: 19000000,
        totalSupply: 21000000,
        lastUpdated: Date()
    )
    
    TokenDetailView(cryptocurrency: mockCrypto)
        .background(Color.black)
} 