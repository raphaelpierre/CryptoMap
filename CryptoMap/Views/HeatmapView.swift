import SwiftUI

// Add custom placeholder modifier
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

class SearchViewController: ObservableObject {
    @Published var searchText = ""
    @Published var isSearching = false
    @Published var recentSearches: [String] = []
    private let maxRecentSearches = 5
    
    func startSearching() {
        isSearching = true
    }
    
    func endSearching() {
        isSearching = false
        if !searchText.isEmpty {
            addRecentSearch(searchText)
        }
    }
    
    func clearSearch() {
        searchText = ""
        isSearching = false
    }
    
    private func addRecentSearch(_ search: String) {
        if !recentSearches.contains(search) {
            recentSearches.insert(search, at: 0)
            if recentSearches.count > maxRecentSearches {
                recentSearches.removeLast()
            }
        }
    }
    
    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
    }
}

struct SearchResultsView: View {
    @ObservedObject var searchController: SearchViewController
    let cryptocurrencies: [(index: Int, crypto: Cryptocurrency)]
    var onSelect: (Int) -> Void
    
    var body: some View {
        VStack {
            if searchController.isSearching && searchController.searchText.isEmpty {
                // Show recent searches
                VStack(alignment: .leading, spacing: 12) {
                    if !searchController.recentSearches.isEmpty {
                        Text("Recent Searches")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal)
                        
                        ForEach(searchController.recentSearches, id: \.self) { search in
                            HStack {
                                Button(action: {
                                    searchController.searchText = search
                                }) {
                                    HStack {
                                        Image(systemName: "chart.bar.fill")
                                            .foregroundColor(.gray)
                                        Text(search)
                                            .foregroundColor(.white)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    searchController.removeRecentSearch(search)
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color(white: 0.15))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        Button(action: {
                            searchController.clearRecentSearches()
                        }) {
                            Text("Clear Recent Searches")
                                .foregroundColor(.blue)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                    }
                }
            } else if !cryptocurrencies.isEmpty {
                // Show filtered results
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(cryptocurrencies, id: \.crypto.id) { index, crypto in
                            Button(action: {
                                onSelect(index)
                                searchController.endSearching()
                            }) {
                                HStack {
                                    AsyncImage(url: URL(string: crypto.image ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                    } placeholder: {
                                        Image(systemName: "bitcoinsign.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 32, height: 32)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text(crypto.symbol.uppercased())
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(crypto.name)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    
                                    Spacer()
                                    
                                    Text(crypto.formattedPrice)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color(white: 0.15))
                                .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            } else if !searchController.searchText.isEmpty {
                // Show no results
                VStack {
                    Image(systemName: "wallet.pass")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                        .padding(.bottom, 8)
                    
                    Text("No Results Found")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Try a different search term")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                .padding()
            }
        }
        .background(Color.black.opacity(0.95))
    }
}

struct HeatmapView: View {
    @ObservedObject var viewModel: CryptoViewModel
    @Binding var selectedIndex: Int?
    @Binding var showingDetail: Bool
    @StateObject private var searchController = SearchViewController()
    @FocusState private var isSearchFieldFocused: Bool
    
    // Define the grid layout with smaller spacing
    private let columns = [
        GridItem(.adaptive(minimum: 280, maximum: 320), spacing: 16)
    ]
    
    private var filteredCryptocurrencies: [(index: Int, crypto: Cryptocurrency)] {
        let enumerated = viewModel.cryptocurrencies.enumerated()
        let mapped = enumerated.map { (index: $0.offset, crypto: $0.element) }
        
        if searchController.searchText.isEmpty {
            return mapped
        }
        
        return mapped.filter { index, crypto in
            crypto.name.localizedCaseInsensitiveContains(searchController.searchText) ||
            crypto.symbol.localizedCaseInsensitiveContains(searchController.searchText)
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                // Search field
                HStack(spacing: 10) {
                    TextField("Search cryptocurrencies...", text: $searchController.searchText)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .focused($isSearchFieldFocused)
                        .onTapGesture {
                            searchController.startSearching()
                            isSearchFieldFocused = true
                        }
                        .submitLabel(.search)
                        .onSubmit {
                            if let firstResult = filteredCryptocurrencies.first {
                                selectedIndex = firstResult.index
                                showingDetail = true
                                searchController.endSearching()
                                isSearchFieldFocused = false
                            }
                        }
                    
                    if !searchController.searchText.isEmpty {
                        Button(action: {
                            searchController.clearSearch()
                            isSearchFieldFocused = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(white: 0.2))
                .cornerRadius(8)
                .frame(width: 300)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFieldFocused ? Color.blue : Color.clear, lineWidth: 1)
                )
                
                if !searchController.isSearching {
                    // Main heatmap grid with modern styling
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(filteredCryptocurrencies, id: \.crypto.id) { index, crypto in
                                Button(action: {
                                    selectedIndex = index
                                    showingDetail = true
                                }) {
                                    CryptoHeatmapTile(
                                        cryptocurrency: crypto,
                                        color: getPriceChangeColor(for: crypto),
                                        isSelected: selectedIndex == index
                                    )
                                }
                                .buttonStyle(TVOSSelectionButtonStyle())
                                .focusable(true)
                                .onFocusChanged { isFocused in
                                    if isFocused {
                                        selectedIndex = index
                                    }
                                }
                                .onLongPressGesture(minimumDuration: 0.1) {
                                    selectedIndex = index
                                    showingDetail = true
                                }
                            }
                        }
                        .padding(12)
                    }
                    
                    // Status bar with modern styling
                    HStack {
                        if viewModel.lastUpdated != nil {
                            HStack(spacing: 6) {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("Updated: \(viewModel.formattedLastUpdated)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchData()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Refresh")
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(Color(red: 0.2, green: 0.5, blue: 0.8))
                        .disabled(viewModel.isLoading)
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }
            }
            
            if searchController.isSearching {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        searchController.endSearching()
                        isSearchFieldFocused = false
                    }
                
                SearchResultsView(
                    searchController: searchController,
                    cryptocurrencies: filteredCryptocurrencies,
                    onSelect: { index in
                        selectedIndex = index
                        showingDetail = true
                        searchController.endSearching()
                        isSearchFieldFocused = false
                    }
                )
                .transition(.move(edge: .top))
            }
        }
        .onChange(of: isSearchFieldFocused) { _, isFocused in
            if !isFocused && searchController.searchText.isEmpty {
                searchController.endSearching()
            }
        }
        .navigationBarHidden(true)
    }
    
    private func getPriceChangeColor(for cryptocurrency: Cryptocurrency) -> Color {
        let priceChange = cryptocurrency.priceChangePercentage24h
        guard let change = priceChange else {
            return Color(white: 0.3) // Default gray for missing data
        }
        
        let intensity = getNormalizedPriceChange(change)
        return createPriceChangeColor(priceChange: change, intensity: intensity)
    }
    
    private func getNormalizedPriceChange(_ priceChange: Double) -> Double {
        return min(1.0, abs(priceChange) / 10.0) // Normalize to 0-1 range, capping at 10% change
    }
    
    private func createPriceChangeColor(priceChange: Double, intensity: Double) -> Color {
        if priceChange >= 0 {
            return createPositivePriceChangeColor(intensity: intensity)
        } else {
            return createNegativePriceChangeColor(intensity: intensity)
        }
    }
    
    private func createPositivePriceChangeColor(intensity: Double) -> Color {
        let red = calculatePositivePriceChangeRed()
        let green = calculatePositivePriceChangeGreen(intensity: intensity)
        let blue = calculatePositivePriceChangeBlue(intensity: intensity)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    private func calculatePositivePriceChangeRed() -> Double {
        return 0.2
    }
    
    private func calculatePositivePriceChangeGreen(intensity: Double) -> Double {
        return 0.4 + (intensity * 0.4)
    }
    
    private func calculatePositivePriceChangeBlue(intensity: Double) -> Double {
        return 0.2 + (intensity * 0.2)
    }
    
    private func createNegativePriceChangeColor(intensity: Double) -> Color {
        let red = calculateNegativePriceChangeRed(intensity: intensity)
        let green = calculateNegativePriceChangeGreen()
        let blue = calculateNegativePriceChangeBlue(intensity: intensity)
        
        return Color(red: red, green: green, blue: blue)
    }
    
    private func calculateNegativePriceChangeRed(intensity: Double) -> Double {
        return 0.4 + (intensity * 0.4)
    }
    
    private func calculateNegativePriceChangeGreen() -> Double {
        return 0.2
    }
    
    private func calculateNegativePriceChangeBlue(intensity: Double) -> Double {
        return 0.2 + (intensity * 0.1)
    }
}

struct CryptoHeatmapTile: View {
    let cryptocurrency: Cryptocurrency
    let color: Color
    let isSelected: Bool
    @FocusState private var isFocused: Bool
    
    private var formattedPrice: String {
        guard let price = cryptocurrency.currentPrice else { return "N/A" }
        if price >= 1000 {
            return String(format: "$%.0f", price)
        } else {
            return String(format: "$%.2f", price)
        }
    }
    
    private var formattedRank: String {
        if let rank = cryptocurrency.marketCapRank {
            return "rank \(rank)"
        } else {
            return ""
        }
    }
    
    private var priceChange: Double? {
        cryptocurrency.priceChangePercentage24h
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top row with symbol and rank
            HStack(alignment: .center, spacing: 8) {
                AsyncImage(url: URL(string: cryptocurrency.image ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    Image(systemName: "bitcoinsign.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(isFocused || isSelected ? .black : .gray)
                }
                
                Text(cryptocurrency.symbol.uppercased())
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(isFocused || isSelected ? .black : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(formattedRank)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isFocused || isSelected ? .black.opacity(0.7) : .white.opacity(0.7))
            }
            
            // Name
            Text(cryptocurrency.name)
                .font(.system(size: 20))
                .foregroundColor(isFocused || isSelected ? .black.opacity(0.7) : .white.opacity(0.7))
                .lineLimit(1)
                .truncationMode(.tail)
            
            Spacer(minLength: 8)
            
            // Price section
            VStack(alignment: .leading, spacing: 8) {
                Text(formattedPrice)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(isFocused || isSelected ? .black : .white)
                
                if let change = priceChange {
                    HStack(spacing: 6) {
                        Image(systemName: change >= 0 ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.downtrend.xyaxis.circle.fill")
                            .font(.system(size: 24))
                        Text("\(abs(change), specifier: "%.2f")%")
                            .font(.system(size: 24, weight: .medium))
                    }
                    .foregroundColor(change >= 0 ? .green : .red)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 200)
        .background(
            ZStack {
                // Base color with gradient
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color,
                                color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Focus or Selection highlight
                if isFocused || isSelected {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.yellow.opacity(0.9))
                }
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isFocused || isSelected ? Color.yellow : Color.white.opacity(0.1), lineWidth: isFocused || isSelected ? 6 : 1)
        )
        .scaleEffect(isFocused || isSelected ? 1.15 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isFocused)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        .focused($isFocused)
    }
}

#Preview {
    HeatmapView(
        viewModel: CryptoViewModel(),
        selectedIndex: .constant(nil),
        showingDetail: .constant(false)
    )
    .background(Color.black)
} 