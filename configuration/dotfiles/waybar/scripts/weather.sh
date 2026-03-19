#!/usr/bin/env bash
# Fetches weather from wttr.in (auto-detects location)

data=$(curl -sf "https://wttr.in/?format=j1" 2>/dev/null)

if [ -z "$data" ]; then
    echo '{"text": " N/A", "tooltip": "Weather unavailable"}'
    exit 0
fi

condition=$(echo "$data" | jq -r '.current_condition[0].weatherDesc[0].value')
temp=$(echo "$data" | jq -r '.current_condition[0].temp_C')
feels=$(echo "$data" | jq -r '.current_condition[0].FeelsLikeC')
humidity=$(echo "$data" | jq -r '.current_condition[0].humidity')

# Pick icon based on condition
case "$condition" in
    *Sun*|*Clear*)       icon="" ;;
    *Cloud*|*Overcast*)  icon="" ;;
    *Rain*|*Drizzle*)    icon="" ;;
    *Snow*)              icon="" ;;
    *Thunder*)           icon="" ;;
    *Fog*|*Mist*)        icon="" ;;
    *)                   icon="" ;;
esac

echo "{\"text\": \"$icon $temp°C\", \"tooltip\": \"$condition\\nFeels like: $feels°C\\nHumidity: $humidity%\"}"
