#!/bin/bash

# Create directory for icons
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset

# Generate App Icon layers
# Back layer
convert -size 400x240 -background black -fill darkgreen -gravity center \
  -font Arial -pointsize 40 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset/back.png

convert -size 800x480 -background black -fill darkgreen -gravity center \
  -font Arial -pointsize 80 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset/back@2x.png

# Middle layer
convert -size 400x240 -background transparent -fill green -gravity center \
  -font Arial -pointsize 40 label:"Crypto" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset/middle.png

convert -size 800x480 -background transparent -fill green -gravity center \
  -font Arial -pointsize 80 label:"Crypto" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset/middle@2x.png

# Front layer
convert -size 400x240 -background transparent -fill lightgreen -gravity center \
  -font Arial -pointsize 40 label:"Map" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset/front.png

convert -size 800x480 -background transparent -fill lightgreen -gravity center \
  -font Arial -pointsize 80 label:"Map" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset/front@2x.png

# Generate Top Shelf Image
convert -size 1920x720 -background black -fill green -gravity center \
  -font Arial -pointsize 100 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf.png

convert -size 3840x1440 -background black -fill green -gravity center \
  -font Arial -pointsize 200 label:"Cryptomap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf@2x.png

# Generate Wide Top Shelf Image
convert -size 2320x720 -background black -fill green -gravity center \
  -font Arial -pointsize 120 label:"Cryptomap - Real-time Crypto Heatmap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide.png

convert -size 4640x1440 -background black -fill green -gravity center \
  -font Arial -pointsize 240 label:"Cryptomap - Real-time Crypto Heatmap" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide@2x.png

# Create Contents.json files
# Brand Assets
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Contents.json << EOF
{
  "assets" : [
    {
      "filename" : "App Icon.imagestack",
      "idiom" : "tv",
      "role" : "primary-app-icon",
      "size" : "400x240"
    },
    {
      "filename" : "Top Shelf Image.imageset",
      "idiom" : "tv",
      "role" : "top-shelf-image",
      "size" : "1920x720"
    },
    {
      "filename" : "Top Shelf Image Wide.imageset",
      "idiom" : "tv",
      "role" : "top-shelf-image-wide",
      "size" : "2320x720"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# App Icon Imagestack
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Contents.json << EOF
{
  "layers" : [
    {
      "filename" : "Front.imagestacklayer"
    },
    {
      "filename" : "Middle.imagestacklayer"
    },
    {
      "filename" : "Back.imagestacklayer"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Back Layer
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Contents.json << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Middle Layer
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Contents.json << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Front Layer
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Contents.json << EOF
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Back Content
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "back.png",
      "idiom" : "tv",
      "scale" : "1x"
    },
    {
      "filename" : "back@2x.png",
      "idiom" : "tv",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Middle Content
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "middle.png",
      "idiom" : "tv",
      "scale" : "1x"
    },
    {
      "filename" : "middle@2x.png",
      "idiom" : "tv",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Front Content
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "front.png",
      "idiom" : "tv",
      "scale" : "1x"
    },
    {
      "filename" : "front@2x.png",
      "idiom" : "tv",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Top Shelf Image
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "top-shelf.png",
      "idiom" : "tv",
      "scale" : "1x"
    },
    {
      "filename" : "top-shelf@2x.png",
      "idiom" : "tv",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

# Top Shelf Image Wide
cat > CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/Contents.json << EOF
{
  "images" : [
    {
      "filename" : "top-shelf-wide.png",
      "idiom" : "tv",
      "scale" : "1x"
    },
    {
      "filename" : "top-shelf-wide@2x.png",
      "idiom" : "tv",
      "scale" : "2x"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF

echo "tvOS app icons generated successfully!" 