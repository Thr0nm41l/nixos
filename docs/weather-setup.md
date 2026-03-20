# Weather Widget Setup

The center bar weather widget requires an OpenWeatherMap API key.

## 1. Get an API key

Create a free account at https://openweathermap.org, then go to your profile → **API keys**.
The free tier is sufficient.

## 2. Find your city ID

Search your city on openweathermap.org, open its page, and grab the number from the URL:
`https://openweathermap.org/city/2988507` → city ID is `2988507`

## 3. Create the .env file

Create the file at:
```
/etc/nixos/nixos-config/nixos/config/sessions/hyprland/scripts/quickshell/calendar/.env
```

With the following content:
```bash
OPENWEATHER_KEY=your_api_key_here
OPENWEATHER_CITY_ID=your_city_id_here
OPENWEATHER_UNIT=metric
```

No rebuild needed — the script picks it up immediately.

## Notes

- This file is **not tracked by git** (contains a private API key) — keep it out of version control.
- `OPENWEATHER_UNIT` accepts `metric` (°C), `imperial` (°F), or `standard` (Kelvin).
