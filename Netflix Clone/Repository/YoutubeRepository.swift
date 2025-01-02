import Foundation

class YoutubeRepository{
    
    static let shared = YoutubeRepository()
    
    func getYoutubVideoId(videoTitle:String, completion: @escaping(Result<YoutubeVideo, ApiError>) -> Void) {
        guard let searchQuery = videoTitle.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            completion(.failure(ApiError.URL_NOT_FOUND))
            return
        }
        
        guard let url = URL(string: "\(AppConstent.youtubeBaseUrl)\(AppConstent.youtybeSearch)\(searchQuery)") else {
            completion(.failure(ApiError.URL_NOT_FOUND))
            return
        }
        
        print("ApiUrl:\(url.absoluteString)")
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.FAILED_TO_FETCH_DATA))
                return
            }
            
            do {
                let youtubeResponse = try JSONDecoder().decode(YoutubeVideoSearchResponse.self, from: data)
                completion(.success(youtubeResponse.items[0]))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(ApiError.FAILED_TO_LOAD_DATA))
            }
        }
        
        task.resume()
    }
    
}
