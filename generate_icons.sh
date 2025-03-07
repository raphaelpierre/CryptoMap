#!/bin/bash

# Create directory for icons
mkdir -p CryptoMap/Assets.xcassets/AppIcon.appiconset

# Generate primary app icons
convert -size 400x240 -background black -fill green -gravity center \
  -font Arial -pointsize 40 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Front-400x240.png

convert -size 800x480 -background black -fill green -gravity center \
  -font Arial -pointsize 80 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Front-800x480.png

# Generate top shelf images
convert -size 1920x720 -background black -fill green -gravity center \
  -font Arial -pointsize 100 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Top-Shelf-1920x720.png

convert -size 3840x1440 -background black -fill green -gravity center \
  -font Arial -pointsize 200 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Top-Shelf-3840x1440.png

# Generate wide top shelf images
convert -size 2320x720 -background black -fill green -gravity center \
  -font Arial -pointsize 120 label:"Cryptomap - Real-time Crypto Heatmap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Top-Shelf-Wide-2320x720.png

convert -size 4640x1440 -background black -fill green -gravity center \
  -font Arial -pointsize 240 label:"Cryptomap - Real-time Crypto Heatmap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Top-Shelf-Wide-4640x1440.png

# Remove old icons if they exist
rm -f CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Small-*.png
rm -f CryptoMap/Assets.xcassets/AppIcon.appiconset/App-Icon-Large-*.png

echo "App icons generated successfully!" 