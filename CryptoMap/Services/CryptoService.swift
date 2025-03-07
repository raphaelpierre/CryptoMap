import Foundation

enum CryptoError: Error, CustomStringConvertible {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
    case apiRateLimitExceeded
    case noData
    case jsonFormatError(String)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiRateLimitExceeded:
            return "API rate limit exceeded"
        case .noData:
            return "No data received from server"
        case .jsonFormatError(let details):
            return "JSON format error: \(details)"
        }
    }
}

class CryptoService: ObservableObject {
    private let baseURL = "https://api.coingecko.com/api/v3"
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        
        // Print API status to check if it's available
        Task {
            do {
                try await checkAPIStatus()
            } catch {
                print("API Status Check Failed: \(error)")
            }
        }
    }
    
    private func checkAPIStatus() async throws {
        let endpoint = "\(baseURL)/ping"
        guard let url = URL(string: endpoint) else {
            throw CryptoError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                throw CryptoError.invalidResponse
            }
            
            print("API Status Check - HTTP Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 429 {
                print("API Rate Limit Exceeded")
                throw CryptoError.apiRateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("API Error - Status Code: \(httpResponse.statusCode)")
                throw CryptoError.invalidResponse
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("API Response: \(responseString)")
            }
            
            print("API Status Check Successful")
        } catch let error as CryptoError {
            throw error
        } catch {
            print("Network Error: \(error.localizedDescription)")
            throw CryptoError.networkError(error)
        }
    }
    
    func fetchTopCryptocurrencies(limit: Int = 50) async throws -> [Cryptocurrency] {
        // Try using the markets endpoint again, which provides ordering by market cap
        let marketsEndpoint = "\(baseURL)/coins/markets"
        var components = URLComponents(string: marketsEndpoint)!
        components.queryItems = [
            URLQueryItem(name: "vs_currency", value: "usd"),
            URLQueryItem(name: "order", value: "market_cap_desc"),
            URLQueryItem(name: "per_page", value: String(limit)),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "sparkline", value: "false"),
            URLQueryItem(name: "price_change_percentage", value: "24h,7d,30d,1y")
        ]
        
        guard let url = components.url else {
            print("Invalid URL: \(marketsEndpoint)")
            throw CryptoError.invalidURL
        }
        
        print("Fetching data from: \(url.absoluteString)")
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                throw CryptoError.invalidResponse
            }
            
            print("HTTP Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 429 {
                print("API Rate Limit Exceeded")
                throw CryptoError.apiRateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("API Error - Status Code: \(httpResponse.statusCode)")
                throw CryptoError.invalidResponse
            }
            
            // Print the full response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Response preview: \(jsonString.prefix(500))...")
            }
            
            // Try to parse the response as an array of dictionaries
            if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                print("Successfully parsed JSON array with \(jsonArray.count) items")
                
                var cryptocurrencies: [Cryptocurrency] = []
                
                for item in jsonArray {
                    let id = item["id"] as? String ?? ""
                    let symbol = item["symbol"] as? String ?? ""
                    let name = item["name"] as? String ?? ""
                    let currentPrice = item["current_price"] as? Double
                    let marketCap = item["market_cap"] as? Double
                    let marketCapRank = item["market_cap_rank"] as? Int
                    let priceChangePercentage24h = item["price_change_percentage_24h"] as? Double
                    let priceChangePercentage7d = item["price_change_percentage_7d"] as? Double
                    let priceChangePercentage30d = item["price_change_percentage_30d"] as? Double
                    let priceChangePercentage1y = item["price_change_percentage_1y"] as? Double
                    let totalVolume = item["total_volume"] as? Double
                    let image = item["image"] as? String
                    let circulatingSupply = item["circulating_supply"] as? Double
                    let totalSupply = item["total_supply"] as? Double
                    
                    // Handle last updated
                    var lastUpdated: Date? = nil
                    if let lastUpdatedString = item["last_updated"] as? String {
                        let formatter = ISO8601DateFormatter()
                        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                        lastUpdated = formatter.date(from: lastUpdatedString)
                        
                        if lastUpdated == nil {
                            // Try without fractional seconds
                            formatter.formatOptions = [.withInternetDateTime]
                            lastUpdated = formatter.date(from: lastUpdatedString)
                        }
                    }
                    
                    let cryptocurrency = Cryptocurrency(
                        id: id,
                        symbol: symbol,
                        name: name,
                        image: image,
                        currentPrice: currentPrice,
                        marketCap: marketCap,
                        marketCapRank: marketCapRank,
                        totalVolume24h: totalVolume,
                        priceChangePercentage24h: priceChangePercentage24h,
                        priceChangePercentage7d: priceChangePercentage7d,
                        priceChangePercentage30d: priceChangePercentage30d,
                        priceChangePercentage1y: priceChangePercentage1y,
                        circulatingSupply: circulatingSupply,
                        totalSupply: totalSupply,
                        lastUpdated: lastUpdated
                    )
                    
                    cryptocurrencies.append(cryptocurrency)
                }
                
                print("Successfully created \(cryptocurrencies.count) cryptocurrency objects")
                return cryptocurrencies
            } else {
                print("Failed to parse response as array of dictionaries")
                throw CryptoError.jsonFormatError("Failed to parse response as array")
            }
        } catch let error as CryptoError {
            throw error
        } catch {
            print("Network Error: \(error.localizedDescription)")
            throw CryptoError.networkError(error)
        }
    }
    
    // Fallback method if the markets endpoint doesn't work
    func fetchTopCryptocurrenciesAlternative(limit: Int = 50) async throws -> [Cryptocurrency] {
        // First get the list of all coins, then get prices separately
        let coinListEndpoint = "\(baseURL)/coins/list"
        
        guard let coinListURL = URL(string: coinListEndpoint) else {
            print("Invalid URL: \(coinListEndpoint)")
            throw CryptoError.invalidURL
        }
        
        print("Fetching coin list from: \(coinListURL.absoluteString)")
        
        do {
            // Step 1: Get the list of all coins
            let (coinListData, coinListResponse) = try await session.data(from: coinListURL)
            
            guard let httpResponse = coinListResponse as? HTTPURLResponse else {
                print("Invalid HTTP response")
                throw CryptoError.invalidResponse
            }
            
            print("HTTP Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 429 {
                print("API Rate Limit Exceeded")
                throw CryptoError.apiRateLimitExceeded
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("API Error - Status Code: \(httpResponse.statusCode)")
                throw CryptoError.invalidResponse
            }
            
            // Step 2: Decode the coin list
            let allCoins = try decoder.decode([CoinListItem].self, from: coinListData)
            print("Successfully decoded \(allCoins.count) coins from list")
            
            // Step 3: Take only the top coins based on the limit
            let topCoins = Array(allCoins.prefix(limit))
            
            // Step 4: Get price data for these coins
            let coinIds = topCoins.map { $0.id }.joined(separator: ",")
            let priceEndpoint = "\(baseURL)/simple/price"
            var priceComponents = URLComponents(string: priceEndpoint)!
            priceComponents.queryItems = [
                URLQueryItem(name: "ids", value: coinIds),
                URLQueryItem(name: "vs_currencies", value: "usd"),
                URLQueryItem(name: "include_market_cap", value: "true"),
                URLQueryItem(name: "include_24hr_vol", value: "true"),
                URLQueryItem(name: "include_24hr_change", value: "true"),
                URLQueryItem(name: "include_last_updated_at", value: "true")
            ]
            
            guard let priceURL = priceComponents.url else {
                print("Invalid URL: \(priceEndpoint)")
                throw CryptoError.invalidURL
            }
            
            print("Fetching price data from: \(priceURL.absoluteString)")
            
            let (priceData, priceResponse) = try await session.data(from: priceURL)
            
            guard let priceHttpResponse = priceResponse as? HTTPURLResponse else {
                print("Invalid HTTP response for price data")
                throw CryptoError.invalidResponse
            }
            
            print("Price HTTP Status: \(priceHttpResponse.statusCode)")
            
            if priceHttpResponse.statusCode == 429 {
                print("API Rate Limit Exceeded for price data")
                throw CryptoError.apiRateLimitExceeded
            }
            
            guard (200...299).contains(priceHttpResponse.statusCode) else {
                print("API Error for price data - Status Code: \(priceHttpResponse.statusCode)")
                throw CryptoError.invalidResponse
            }
            
            // Step 5: Parse the price data
            guard let priceDict = try JSONSerialization.jsonObject(with: priceData) as? [String: [String: Any]] else {
                print("Failed to parse price data as dictionary")
                throw CryptoError.jsonFormatError("Failed to parse price data")
            }
            
            // Step 6: Combine coin list with price data
            var cryptocurrencies: [Cryptocurrency] = []
            
            for coin in topCoins {
                if let priceInfo = priceDict[coin.id] {
                    let currentPrice = priceInfo["usd"] as? Double
                    let marketCap = priceInfo["usd_market_cap"] as? Double
                    let volume = priceInfo["usd_24h_vol"] as? Double
                    let priceChange = priceInfo["usd_24h_change"] as? Double
                    let lastUpdatedTimestamp = priceInfo["last_updated_at"] as? Double
                    
                    let lastUpdated: Date? = lastUpdatedTimestamp != nil ? 
                        Date(timeIntervalSince1970: lastUpdatedTimestamp!) : nil
                    
                    let cryptocurrency = Cryptocurrency(
                        id: coin.id,
                        symbol: coin.symbol,
                        name: coin.name,
                        image: nil,
                        currentPrice: currentPrice,
                        marketCap: marketCap,
                        marketCapRank: nil,
                        totalVolume24h: volume,
                        priceChangePercentage24h: priceChange,
                        priceChangePercentage7d: nil,
                        priceChangePercentage30d: nil,
                        priceChangePercentage1y: nil,
                        circulatingSupply: nil,
                        totalSupply: nil,
                        lastUpdated: lastUpdated
                    )
                    
                    cryptocurrencies.append(cryptocurrency)
                } else {
                    // If no price data, still include the coin with nil values
                    let cryptocurrency = Cryptocurrency(
                        id: coin.id,
                        symbol: coin.symbol,
                        name: coin.name,
                        image: nil,
                        currentPrice: nil,
                        marketCap: nil,
                        marketCapRank: nil,
                        totalVolume24h: nil,
                        priceChangePercentage24h: nil,
                        priceChangePercentage7d: nil,
                        priceChangePercentage30d: nil,
                        priceChangePercentage1y: nil,
                        circulatingSupply: nil,
                        totalSupply: nil,
                        lastUpdated: nil
                    )
                    
                    cryptocurrencies.append(cryptocurrency)
                }
            }
            
            // Sort by market cap (if available)
            let sortedCryptocurrencies = cryptocurrencies.sorted { (crypto1, crypto2) -> Bool in
                if let marketCap1 = crypto1.marketCap, let marketCap2 = crypto2.marketCap {
                    return marketCap1 > marketCap2
                } else if crypto1.marketCap != nil {
                    return true
                } else if crypto2.marketCap != nil {
                    return false
                } else {
                    return crypto1.name < crypto2.name // Alphabetical if no market cap
                }
            }
            
            print("Successfully created \(sortedCryptocurrencies.count) cryptocurrency objects with price data")
            return sortedCryptocurrencies
            
        } catch let error as CryptoError {
            throw error
        } catch {
            print("Network Error: \(error.localizedDescription)")
            throw CryptoError.networkError(error)
        }
    }
    
    func searchCryptocurrencies(query: String) async throws -> [Cryptocurrency] {
        // For now, let's use a simpler approach that's more likely to work
        // We'll fetch all cryptocurrencies and filter them locally
        do {
            let allCryptos = try await fetchTopCryptocurrencies(limit: 100)
            let filteredCryptos = allCryptos.filter { 
                $0.name.localizedCaseInsensitiveContains(query) || 
                $0.symbol.localizedCaseInsensitiveContains(query)
            }
            return filteredCryptos
        } catch {
            // Try the alternative method if the first one fails
            do {
                let allCryptos = try await fetchTopCryptocurrenciesAlternative(limit: 100)
                let filteredCryptos = allCryptos.filter { 
                    $0.name.localizedCaseInsensitiveContains(query) || 
                    $0.symbol.localizedCaseInsensitiveContains(query)
                }
                return filteredCryptos
            } catch {
                throw error
            }
        }
    }
}

// Simple structure for the coin list endpoint
struct CoinListItem: Codable {
    let id: String
    let symbol: String
    let name: String
} 