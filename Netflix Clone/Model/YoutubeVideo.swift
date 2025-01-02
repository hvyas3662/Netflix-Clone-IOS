struct YoutubeVideoSearchResponse :Codable{
    let items: [YoutubeVideo]
}


struct YoutubeVideo : Codable{
    let id: YoutubeVideoId
    let kind:String
    let etag:String
}

struct YoutubeVideoId : Codable {
    let kind: String
    let videoId: String
}
