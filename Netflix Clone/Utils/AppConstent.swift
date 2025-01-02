struct AppConstent {
    
    static let apiKey = "40a8326940b3ae2cdccec503626ea7ba"
    static let youtybeApiKey = "AIzaSyD-7x6oKaWrH9BozDdkRssxRYjtQIc8KRA"

    static let baseUrl = "https://api.themoviedb.org/3/"
    static let trendingMovie = "trending/movie/day?api_key="
    static let trendingTv = "trending/tv/day?api_key="
    static let upcomingMovie = "movie/upcoming?api_key="
    static let popularMovie = "movie/popular?api_key="
    static let topRatedMoview = "movie/top_rated?api_key="
    static let discoverMovie = "discover/movie?language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate&api_key="
    
    static let youtubeBaseUrl = "https://www.googleapis.com/youtube/v3/"
    static let youtybeSearch = "search?key=\(youtybeApiKey)&q="
    static let youtybePlayer = "https://www.youtube.com/embed/"
    static let imageUrlSmall = "https://image.tmdb.org/t/p/w500"
    static let imageUrl = "https://image.tmdb.org/t/p/original"
    
    static let downloadNotificationName = "title_added_to_downloads"
}
