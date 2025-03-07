//
//  ContentView.swift
//  CryptoMap
//
//  Created by Raphael PIERRE on 05.03.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = CryptoViewModel()
    @State private var selectedIndex: Int?
    @State private var showingDetail = false
    
    var body: some View {
        NavigationView {
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
                    if viewModel.isLoading {
                        loadingView
                    } else if !viewModel.errorMessage.isEmpty {
                        errorView
                    } else if viewModel.cryptocurrencies.isEmpty {
                        emptyStateView
                    } else {
                        // Main heatmap view
                        HeatmapView(
                            viewModel: viewModel,
                            selectedIndex: $selectedIndex,
                            showingDetail: $showingDetail
                        )
                    }
                }
            }
            //.navigationTitle("Cryptomap")
            .sheet(isPresented: $showingDetail) {
                Group {
                    if let index = selectedIndex,
                       index < viewModel.cryptocurrencies.count {
                        TokenDetailView(cryptocurrency: viewModel.cryptocurrencies[index])
                    } else {
                        // Provide a fallback view to ensure View conformance
                        Text("No cryptocurrency selected")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
                    }
                }
            }
            .onChange(of: showingDetail) { oldValue, newValue in
                print("Sheet presentation changed: \(oldValue) -> \(newValue)")
                if newValue, selectedIndex == nil {
                    // If trying to show detail but no selection, reset the state
                    showingDetail = false
                }
            }
        }
        .onAppear {
            // Force an initial data fetch when the view appears
            Task {
                await viewModel.fetchData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.2, green: 0.5, blue: 0.8)))
            
            Text("Loading cryptocurrency data...")
                .font(.headline)
                .foregroundColor(.white.opacity(0.7))
            
            Text("Fetching the latest market information")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(16)
        .padding(.horizontal, 24)
    }
    
    private var errorView: some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(.yellow)
                .padding(.bottom, 8)
            
            Text("Unable to Load Data")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(viewModel.errorMessage)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.fetchData()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Try Again")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.2, green: 0.5, blue: 0.8))
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.gray)
                .padding(.bottom, 8)
            
            Text("No Cryptocurrencies Found")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text("Try adjusting your search or refresh to see the latest data")
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            Button(action: {
                Task {
                    await viewModel.fetchData()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Refresh")
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(red: 0.2, green: 0.5, blue: 0.8))
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 24)
    }
}

#Preview {
    ContentView()
}
