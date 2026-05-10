#!/bin/bash
# Downloads twemoji icons for Telugu Varnamala app
# Icons are free to use (CC BY 4.0 - Twitter/Twemoji)

DEST=~/Desktop/AndroidApps/telugu_varnamala/assets/images
BASE="https://api.iconify.design/twemoji"

declare -A ICONS=(
  ["amma.png"]="woman"
  ["cow.png"]="cow"
  ["house.png"]="house"
  ["fly.png"]="fly"
  ["squirrel.png"]="chipmunk"
  ["village.png"]="cityscape"
  ["sage.png"]="man-in-lotus-position"
  ["bull.png"]="ox"
  ["elephant.png"]="elephant"
  ["five.png"]="keycap-5"
  ["camel.png"]="two-hump-camel"
  ["ship.png"]="ship"
  ["medicine.png"]="pill"
  ["sky.png"]="cloud"
  ["wow.png"]="star-struck"
  ["lha.png"]="letter-a"
  ["lha2.png"]="letter-b"
  ["nga.png"]="letter-c"
  ["nya.png"]="letter-d"
  ["na2.png"]="letter-e"
  ["moment.png"]="hourglass-not-done"
  ["dignity.png"]="crown"
  ["lotus.png"]="lotus"
  ["bird.png"]="bird"
  ["clock.png"]="alarm-clock"
  ["bell.png"]="bell"
  ["fish.png"]="fish"
  ["umbrella.png"]="umbrella"
  ["waterfall.png"]="water-wave"
  ["sieve.png"]="basket"
  ["tomato.png"]="tomato"
  ["head.png"]="bust-in-silhouette"
  ["plate.png"]="plate-with-cutlery"
  ["thread.png"]="thread"
  ["money.png"]="money-bag"
  ["drum.png"]="drum"
  ["river.png"]="water-wave"
  ["snake.png"]="snake"
  ["fruit.png"]="grapes"
  ["duck.png"]="duck"
  ["earth.png"]="globe-showing-asia-australia"
  ["mango.png"]="mango"
  ["vehicle.png"]="automobile"
  ["king.png"]="crown"
  ["laddu.png"]="doughnut"
  ["cooking.png"]="pot-of-food"
  ["conch.png"]="spiral-shell"
  ["hexagon.png"]="large-blue-diamond"
  ["sun.png"]="sun"
  ["swan.png"]="swan"
  ["stone.png"]="rock"
)

echo "Downloading ${#ICONS[@]} icons..."
for filename in "${!ICONS[@]}"; do
  icon="${ICONS[$filename]}"
  url="${BASE}/${icon}.svg"
  svg_file="${DEST}/${filename%.png}.svg"
  
  # Download SVG
  if curl -sf "$url" -o "$svg_file"; then
    echo "✓ $filename"
  else
    # Try alternate name with colon format
    echo "✗ $filename (not found: $icon)"
    # Create a simple colored placeholder SVG
    cat > "$svg_file" << EOF
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
  <rect width="100" height="100" rx="10" fill="#FFE0B2"/>
  <text x="50" y="65" font-size="50" text-anchor="middle">?</text>
</svg>
EOF
  fi
done

echo ""
echo "Done! SVG files saved to $DEST"
echo "Note: Flutter can use SVG files with flutter_svg package, or convert to PNG."
echo "To use directly, add 'flutter_svg' to pubspec.yaml"
