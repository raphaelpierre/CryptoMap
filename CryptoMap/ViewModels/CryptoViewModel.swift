import Foundation
import SwiftUI

@MainActor
class CryptoViewModel: ObservableObject {
    @Published var cryptocurrencies: [Cryptocurrency] = []
    @Published var selectedCryptocurrency: Cryptocurrency?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var errorMessage: String = ""
    @Published var searchQuery = ""
    @Published var isSearching = false
    @Published var selectedMetric: MetricType = .priceChange
    @Published var lastUpdated: Date?
    
    private let cryptoService: CryptoService
    private var updateTimer: Timer?
    private let updateInterval: TimeInterval = 300 // 5 minutes
    
    enum MetricType: String, CaseIterable {
        case priceChange = "Price Change"
        case volume = "Volume"
        case marketCap = "Market Cap"
    }
    
    init(cryptoService: CryptoService = CryptoService()) {
        self.cryptoService = cryptoService
        setupAutoUpdate()
    }
    
    private func setupAutoUpdate() {
        // Update every 5 minutes
        updateTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchData()
            }
        }
        // Initial fetch
        Task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        isLoading = true
        error = nil
        errorMessage = ""
        
        do {
            print("Fetching cryptocurrency data...")
            cryptocurrencies = try await cryptoService.fetchTopCryptocurrencies()
            lastUpdated = Date()
            print("Successfully fetched \(cryptocurrencies.count) cryptocurrencies")
        } catch let cryptoError as CryptoError {
            error = cryptoError
            errorMessage = cryptoError.description
            print("Error fetching data: \(cryptoError.description)")
            
            // Handle specific errors
            if case .apiRateLimitExceeded = cryptoError {
                errorMessage = "API rate limit exceeded. Please try again later."
            }
        } catch {
            self.error = error
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            print("Unexpected error: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
    func searchCryptocurrencies() async {
        guard !searchQuery.isEmpty else {
            await fetchData()
            return
        }
        
        isLoading = true
        error = nil
        errorMessage = ""
        isSearching = true
        
        do {
            print("Searching for cryptocurrencies with query: \(searchQuery)")
            cryptocurrencies = try await cryptoService.searchCryptocurrencies(query: searchQuery)
            lastUpdated = Date()
            print("Search returned \(cryptocurrencies.count) results")
        } catch let cryptoError as CryptoError {
            error = cryptoError
            errorMessage = cryptoError.description
            print("Error searching: \(cryptoError.description)")
            
            // Handle specific errors
            if case .apiRateLimitExceeded = cryptoError {
                errorMessage = "API rate limit exceeded. Please try again later."
            }
        } catch {
            self.error = error
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
            print("Unexpected error: \(error.localizedDescription)")
        }
        
        isLoading = false
        isSearching = false
    }
    
    func getColorForMetric(_ cryptocurrency: Cryptocurrency) -> Color {
        switch selectedMetric {
        case .priceChange:
            guard let priceChange = cryptocurrency.priceChangePercentage24h else {
                return Color.gray // Default color for missing data
            }
            return priceChange >= 0 ? .green : .red
            
        case .volume:
            guard let volume = cryptocurrency.totalVolume24h, volume > 0 else {
                return Color.gray // Default color for missing data
            }
            
            let maxVolume = cryptocurrencies.compactMap { $0.totalVolume24h }.max() ?? 1
            let normalizedVolume = volume / maxVolume
            return Color(red: normalizedVolume, green: 0, blue: 0)
            
        case .marketCap:
            guard let marketCap = cryptocurrency.marketCap, marketCap > 0 else {
                return Color.gray // Default color for missing data
            }
            
            let maxMarketCap = cryptocurrencies.compactMap { $0.marketCap }.max() ?? 1
            let normalizedMarketCap = marketCap / maxMarketCap
            return Color(red: 0, green: normalizedMarketCap, blue: 0)
        }
    }
    
    var formattedLastUpdated: String {
        guard let lastUpdated = lastUpdated else {
            return "Never"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: lastUpdated)
    }
    
    deinit {
        updateTimer?.invalidate()
    }
} 