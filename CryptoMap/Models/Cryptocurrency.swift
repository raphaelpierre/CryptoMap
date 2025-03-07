import Foundation

struct Cryptocurrency: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String?
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Int?
    let priceChangePercentage24h: Double?
    let priceChangePercentage7d: Double?
    let priceChangePercentage30d: Double?
    let priceChangePercentage1y: Double?
    let totalVolume24h: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let lastUpdated: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case priceChangePercentage7d = "price_change_percentage_7d"
        case priceChangePercentage30d = "price_change_percentage_30d"
        case priceChangePercentage1y = "price_change_percentage_1y"
        case totalVolume24h = "total_volume"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case lastUpdated = "last_updated"
    }
    
    // Custom initializer to handle different data formats
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Required fields
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        
        // Optional fields with flexible decoding
        image = try? container.decodeIfPresent(String.self, forKey: .image)
        currentPrice = try? container.decodeIfPresent(Double.self, forKey: .currentPrice)
        
        // Handle market cap which might be a string, double, or null
        if let marketCapDouble = try? container.decodeIfPresent(Double.self, forKey: .marketCap) {
            marketCap = marketCapDouble
        } else if let marketCapString = try? container.decodeIfPresent(String.self, forKey: .marketCap),
                  let marketCapDouble = Double(marketCapString) {
            marketCap = marketCapDouble
        } else {
            marketCap = nil
        }
        
        // Handle market cap rank which might be a string, int, or null
        if let rankInt = try? container.decodeIfPresent(Int.self, forKey: .marketCapRank) {
            marketCapRank = rankInt
        } else if let rankString = try? container.decodeIfPresent(String.self, forKey: .marketCapRank),
                  let rankInt = Int(rankString) {
            marketCapRank = rankInt
        } else {
            marketCapRank = nil
        }
        
        // Handle price changes which might be strings, doubles, or null
        func decodePriceChange(forKey key: CodingKeys) -> Double? {
            if let changeDouble = try? container.decodeIfPresent(Double.self, forKey: key) {
                return changeDouble
            } else if let changeString = try? container.decodeIfPresent(String.self, forKey: key),
                      let changeDouble = Double(changeString) {
                return changeDouble
            }
            return nil
        }
        
        priceChangePercentage24h = decodePriceChange(forKey: .priceChangePercentage24h)
        priceChangePercentage7d = decodePriceChange(forKey: .priceChangePercentage7d)
        priceChangePercentage30d = decodePriceChange(forKey: .priceChangePercentage30d)
        priceChangePercentage1y = decodePriceChange(forKey: .priceChangePercentage1y)
        
        // Handle volume which might be a string, double, or null
        if let volumeDouble = try? container.decodeIfPresent(Double.self, forKey: .totalVolume24h) {
            totalVolume24h = volumeDouble
        } else if let volumeString = try? container.decodeIfPresent(String.self, forKey: .totalVolume24h),
                  let volumeDouble = Double(volumeString) {
            totalVolume24h = volumeDouble
        } else {
            totalVolume24h = nil
        }
        
        // Handle circulating supply which might be a string, double, or null
        if let supplyDouble = try? container.decodeIfPresent(Double.self, forKey: .circulatingSupply) {
            circulatingSupply = supplyDouble
        } else if let supplyString = try? container.decodeIfPresent(String.self, forKey: .circulatingSupply),
                  let supplyDouble = Double(supplyString) {
            circulatingSupply = supplyDouble
        } else {
            circulatingSupply = nil
        }
        
        // Handle total supply which might be a string, double, or null
        if let supplyDouble = try? container.decodeIfPresent(Double.self, forKey: .totalSupply) {
            totalSupply = supplyDouble
        } else if let supplyString = try? container.decodeIfPresent(String.self, forKey: .totalSupply),
                  let supplyDouble = Double(supplyString) {
            totalSupply = supplyDouble
        } else {
            totalSupply = nil
        }
        
        // Handle date which might be in different formats
        if let dateString = try? container.decodeIfPresent(String.self, forKey: .lastUpdated) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: dateString) {
                lastUpdated = date
            } else {
                // Try without fractional seconds
                formatter.formatOptions = [.withInternetDateTime]
                lastUpdated = formatter.date(from: dateString)
            }
        } else {
            lastUpdated = nil
        }
    }
    
    // For preview and testing
    init(id: String, symbol: String, name: String, image: String?, currentPrice: Double?, 
         marketCap: Double?, marketCapRank: Int?, totalVolume24h: Double?, 
         priceChangePercentage24h: Double?, priceChangePercentage7d: Double?,
         priceChangePercentage30d: Double?, priceChangePercentage1y: Double?,
         circulatingSupply: Double?, totalSupply: Double?,
         lastUpdated: Date?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.totalVolume24h = totalVolume24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.priceChangePercentage7d = priceChangePercentage7d
        self.priceChangePercentage30d = priceChangePercentage30d
        self.priceChangePercentage1y = priceChangePercentage1y
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.lastUpdated = lastUpdated
    }
    
    var formattedPrice: String {
        guard let price = currentPrice else {
            return "N/A"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: price)) ?? "$0.00"
    }
    
    var formattedMarketCap: String {
        guard let cap = marketCap else {
            return "N/A"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: cap)) ?? "$0"
    }
    
    var formattedVolume: String {
        guard let volume = totalVolume24h else {
            return "N/A"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: volume)) ?? "$0"
    }
    
    var formattedPriceChange: String {
        guard let change = priceChangePercentage24h else {
            return "N/A"
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: change / 100)) ?? "0%"
    }
    
    var formattedRank: String {
        guard let rank = marketCapRank else {
            return "N/A"
        }
        return "#\(rank)"
    }
} 