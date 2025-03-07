#!/bin/bash

# Create directory for icons
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset
mkdir -p CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset

# Generate App Icon layers
# Back layer - Solid background that fills the entire space
convert -size 400x240 xc:black \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset/back.png

convert -size 800x480 xc:black \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Back.imagestacklayer/Content.imageset/back@2x.png

# Middle layer - Gradient background
convert -size 400x240 -define gradient:angle=45 gradient:darkgreen-green \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset/middle.png

convert -size 800x480 -define gradient:angle=45 gradient:darkgreen-green \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Middle.imagestacklayer/Content.imageset/middle@2x.png

# Front layer - Large, bold text that fills most of the icon
convert -size 400x240 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 60 label:"CRYPTO\nMAP" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset/front.png

convert -size 800x480 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 120 label:"CRYPTO\nMAP" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/App\ Icon.imagestack/Front.imagestacklayer/Content.imageset/front@2x.png

# Generate Top Shelf Image - More visually appealing banner
convert -size 1920x720 -define gradient:angle=45 gradient:black-darkgreen \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf.png

convert -size 1920x720 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 120 label:"CRYPTOMAP" -draw "gravity center fill white rectangle 0,340 1920,380" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text.png

convert CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf.png \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text.png \
  -composite CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf.png

rm CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text.png

# 2x version
convert -size 3840x1440 -define gradient:angle=45 gradient:black-darkgreen \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf@2x.png

convert -size 3840x1440 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 240 label:"CRYPTOMAP" -draw "gravity center fill white rectangle 0,680 3840,760" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text@2x.png

convert CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf@2x.png \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text@2x.png \
  -composite CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf@2x.png

rm CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image.imageset/top-shelf-text@2x.png

# Generate Wide Top Shelf Image
convert -size 2320x720 -define gradient:angle=45 gradient:black-darkgreen \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide.png

convert -size 2320x720 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 100 label:"CRYPTOMAP\nReal-time Cryptocurrency Heatmap" -draw "gravity center fill white rectangle 0,340 2320,380" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text.png

convert CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide.png \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text.png \
  -composite CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide.png

rm CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text.png

# 2x version
convert -size 4640x1440 -define gradient:angle=45 gradient:black-darkgreen \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide@2x.png

convert -size 4640x1440 -background none -fill white -gravity center \
  -font Arial-Bold -pointsize 200 label:"CRYPTOMAP\nReal-time Cryptocurrency Heatmap" -draw "gravity center fill white rectangle 0,680 4640,760" \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text@2x.png

convert CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide@2x.png \
  CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text@2x.png \
  -composite CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide@2x.png

rm CryptoMap/Assets.xcassets/App\ Icon\ \&\ Top\ Shelf\ Image.brandassets/Top\ Shelf\ Image\ Wide.imageset/top-shelf-wide-text@2x.png

# Create Contents.json files (same as before)
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

echo "Improved tvOS app icons generated successfully!" 