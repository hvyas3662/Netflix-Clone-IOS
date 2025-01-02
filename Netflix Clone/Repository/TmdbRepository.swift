import Foundation

class TmdbRepository {
    static let shared = TmdbRepository()
    
    func getTrandingMovie(completion: @escaping(Result<[Title], ApiError>) -> Void){
        fetchTitleData(path: AppConstent.trendingMovie, completion: completion)
    }
    
    func getTrandingTvShows(completion: @escaping(Result<[Title], ApiError>) -> Void) {
        fetchTitleData(path: AppConstent.trendingTv, completion: completion)
    }
    
    func getPopularMovie(completion: @escaping(Result<[Title], ApiError>) -> Void) {
        fetchTitleData(path: AppConstent.popularMovie, completion: completion)
    }
    
    func getUpcommingMovie(completion: @escaping(Result<[Title], ApiError>) -> Void) {
        fetchTitleData(path: AppConstent.upcomingMovie, completion: completion)
    }
    
    func getToRatedMovie(completion: @escaping(Result<[Title], ApiError>) -> Void) {
        fetchTitleData(path: AppConstent.topRatedMoview, completion: completion)
    }
    
    func getDiscoveredMovie(completion: @escaping(Result<[Title], ApiError>) -> Void) {
        fetchTitleData(path: AppConstent.discoverMovie, completion: completion)
    }
    
    func search(with query: String, completion: @escaping (Result<[Title], ApiError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let path = "search/movie?query=\(query)&api_key="
        fetchTitleData(path: path, completion: completion)
    }
        
    
    private func fetchTitleData(path:String, completion: @escaping(Result<[Title], ApiError>) ->Void) {
        
        guard let url = URL(string: "\(AppConstent.baseUrl)\(path)\(AppConstent.apiKey)") else  {
            completion(.failure(ApiError.URL_NOT_FOUND))
            return
        }
        print("ApiUrl: \(url.absoluteString)")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(ApiError.FAILED_TO_FETCH_DATA))
                return
            }
            
            do{
                let trendingShowResponse = try JSONDecoder().decode(TitleResponce.self, from: data)
                completion(.success(trendingShowResponse.results))
            } catch {
                print("Decoding error: \(error.localizedDescription)")
                completion(.failure(ApiError.FAILED_TO_LOAD_DATA))
            }
        }
        
        task.resume()
    }
    
}
