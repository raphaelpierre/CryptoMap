#!/bin/bash

# Create directory for icons
mkdir -p CryptoMap/Assets.xcassets/AppIcon.appiconset

# Generate primary app icons
convert -size 400x240 -background black -fill green -gravity center \
  -font Arial -pointsize 40 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/icon_400x240.png

convert -size 800x480 -background black -fill green -gravity center \
  -font Arial -pointsize 80 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/AppIcon.appiconset/icon_800x480.png

# Update Contents.json
cat > CryptoMap/Assets.xcassets/AppIcon.appiconset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "icon_400x240.png",
      "idiom" : "tv",
      "scale" : "1x",
      "size" : "400x240"
    },
    {
      "filename" : "icon_800x480.png",
      "idiom" : "tv",
      "scale" : "2x",
      "size" : "400x240"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "Basic app icons generated successfully!" 