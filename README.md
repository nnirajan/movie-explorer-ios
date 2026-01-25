# Movie Explorer iOS App

A simple iOS app that allows users to search for movies and view their details using **The Movie Database (TMDb) API**. The app supports offline caching and smooth browsing of movies.

---

## Features

- **Search Movies:**
- **Movie Details:**
- **Offline Mode:**
- **Favorites:**
- **Pagination:**

---

## Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/movie-search-ios.git

2. Open the project in Xcode:
    ```bash
    cd movie-search-ios
    open MovieSearchApp.xcodeproj

3. Copy Secrets.example.xcconfig to Secrets.xcconfig and add your TMDb API key:
    API_KEY = your_api_key

4. Build and run the app on a simulator or device.

---

## Technologies

- Swift & SwiftUI
- Combine / Async-Await for network calls
- URLSession for API requests
- Codable for JSON parsing
- SwiftData for offline support
- Kingfisher for image loading and caching

---

## Architecture
- MVVM: Separates UI and business logic.
- Offline Caching: Stores search results locally.
- Error Handling: Shows alerts for network errors or empty results.