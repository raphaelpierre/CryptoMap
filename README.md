# CryptoMap

A modern iOS cryptocurrency tracking application built with SwiftUI that provides real-time cryptocurrency market data, interactive price charts, and detailed token information.

## Features

### Real-time Market Data
- Live cryptocurrency prices and market data
- Price changes for multiple timeframes (24h, 7d, 30d, 1y)
- Market cap, volume, and supply information
- Ranking system for top cryptocurrencies

### Interactive Price Charts
- Dynamic price charts with multiple timeframes
- Smooth animations and transitions
- Min/max price indicators
- Average price calculations
- Customizable chart appearance

### Smart Caching System
- Intelligent data caching to reduce API calls
- Different cache durations based on timeframe:
  - 24h data: 5 minutes
  - 7d data: 15 minutes
  - 30d data: 30 minutes
  - 1y data: 1 hour
- Fallback to cached data during rate limits

### Modern UI/UX
- Dark mode optimized interface
- Smooth animations and transitions
- Responsive grid layout
- Intuitive search functionality
- Detailed token information cards

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- CoinGecko API Key

## Installation

1. Clone the repository:
```bash
git clone https://github.com/raphaelpierre/CryptoMap.git
cd CryptoMap
```

2. Open the project in Xcode:
```bash
open CryptoMap.xcodeproj
```

3. Add your CoinGecko API key in `TokenDetailViewModel.swift`:
```swift
private let apiKey = "YOUR_API_KEY"
```

4. Build and run the project in Xcode

## API Integration

CryptoMap uses the CoinGecko API v3 for cryptocurrency data. The following endpoints are used:

- `/coins/markets` - List all supported coins with market data
- `/coins/{id}/market_chart` - Get historical market data

Rate Limits:
- Free tier: 10-50 calls/minute
- Pro tier: Higher limits available

## Architecture

The app follows modern iOS development practices:

- **SwiftUI** for the UI layer
- **MVVM** architecture
- **Async/await** for network calls
- **Combine** for reactive updates
- **Modular** components for reusability

Key Components:
- `HeatmapView`: Main grid view of cryptocurrencies
- `TokenDetailView`: Detailed view for individual tokens
- `SearchViewController`: Handles search functionality
- `CacheSystem`: Manages data caching

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [CoinGecko API](https://www.coingecko.com/api/documentation) for cryptocurrency data
- [Swift Charts](https://developer.apple.com/documentation/charts) for charting functionality
- [SwiftUI](https://developer.apple.com/xcode/swiftui/) for the modern UI framework

## Support

For support, please open an issue in the repository or contact the maintainers.

## Screenshots

![CryptoMap Main View](Simulator%20Screenshot%20-%20Apple%20TV%204K%20(3rd%20generation)%20(at%201080p)%20-%202025-03-07%20at%2011.57.19.png)
*Main view showing the cryptocurrency grid*

![CryptoMap Detail View](Simulator%20Screenshot%20-%20Apple%20TV%204K%20(3rd%20generation)%20(at%201080p)%20-%202025-03-07%20at%2011.57.53.png)
*Detailed view of a cryptocurrency with price chart*

## Roadmap

- [ ] Add portfolio tracking
- [ ] Implement price alerts
- [ ] Add more technical indicators
- [ ] Support for more cryptocurrencies
- [ ] Enhanced chart interactions
- [ ] Watchlist functionality 