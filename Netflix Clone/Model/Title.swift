struct TitleResponce : Codable{
    let results : [Title]
}


struct Title: Codable {
    var id: Int
    var media_type: String?
    var poster_path: String?
    var overview: String?
    var vote_count: Int
    var vote_average: Double
    
    private var original_title: String?
    private var original_name: String?
    var titleName: String {
        return original_title ?? original_name ?? ""
    }
}
