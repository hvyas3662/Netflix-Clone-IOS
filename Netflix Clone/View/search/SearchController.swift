import UIKit

class SearchController: UIViewController{
    
    private let searchView: UISearchController  = {
        let searchView = UISearchController(searchResultsController: SearchResultViewController())
        searchView.searchBar.placeholder = "Search Movies Or Tv Shows"
        searchView.searchBar.searchBarStyle = .prominent
        return searchView
    }()
    
    private var titleList: [Title] = [Title]()
    
    private let discoverTableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTopNavigationBar()
        setUpDiscoverTableView()
        fetechDiscoverMovie()
    }
    
    private func setUpTopNavigationBar(){
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .accent
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchView
        searchView.searchResultsUpdater = self
    }
    
    private func setUpDiscoverTableView(){
        view.addSubview(discoverTableView)
        discoverTableView.dataSource = self
        discoverTableView.delegate = self
    }
    
    private func fetechDiscoverMovie(){
        TmdbRepository.shared.getDiscoveredMovie { [weak self] result in
            switch result {
                case .success(let titleList):
                    self?.titleList = titleList
                case .failure(let error):
                    print(error)
            }
            
            DispatchQueue.main.async {
                self?.discoverTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTableView.frame = view.bounds
    }
}

extension SearchController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(title: titleList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titleList[indexPath.row]
        
        YoutubeRepository.shared.getYoutubVideoId(videoTitle: title.titleName) { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(model: TitlePreviewModel(titleName: title.titleName, titleDetail: title.overview ?? "", videoId: videoElement.id.videoId))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension SearchController : UISearchResultsUpdating, SearchResultViewControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
                
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 3,
                let resultsController = searchController.searchResultsController as? SearchResultViewController else {
              return
        }
        resultsController.delegate = self
        TmdbRepository.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.updateSearchResult(titleList: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func titleDidTap(model: TitlePreviewModel) {
        let vc = TitlePreviewViewController()
        vc.configure(model: model)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
