import UIKit

class HomeController: UIViewController{
    
    let sectionTitle = ["Tranding Movies","Tranding Tv Show", "Pouplar", "Upcomming Movies", "Top Rated"]
    
    private var headerView : HomeBrandingView? = nil
    private var trandingMovieList = [Title]()
    
    private let homeFeedTable:UITableView  = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeFeedCell.self, forCellReuseIdentifier: HomeFeedCell.identifier)
        tableView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setUpHomeFeedTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateHeaderView()
    }
    
    private func configureNavigationBar() {
        let netflixLogo = UIImage(named: "netflixLogo")?.withRenderingMode(.alwaysOriginal)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setUpHomeFeedTableView(){
        view.addSubview(homeFeedTable)
        homeFeedTable.dataSource = self
        homeFeedTable.delegate = self
        headerView = HomeBrandingView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: (view.bounds.height * 0.45)))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func updateHeaderView(){
        if(trandingMovieList.isEmpty){
            fetchTrendingMovieList{ movieList in
                self.trandingMovieList = movieList
                self.loadRendomMovieInHomeBanner()
            }
        } else {
            loadRendomMovieInHomeBanner()
        }
    }
    
   private func  loadRendomMovieInHomeBanner(){
       guard let remdomMovie = trandingMovieList.randomElement() else {return}
        self.headerView?.configure(title: remdomMovie)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    private func fetchTrendingMovieList(callback: @escaping([Title])->Void) {
        TmdbRepository.shared.getTrandingMovie { result in
            callback(self.handleTitleResponse(result: result))
        }
    }
    
    private func fetchTrendingTvShows(callback: @escaping([Title])->Void){
        TmdbRepository.shared.getTrandingTvShows { result in
            callback(self.handleTitleResponse(result: result))
        }
    }
    
    private func fetchUpCommingMovie(callback: @escaping([Title])->Void){
        TmdbRepository.shared.getUpcommingMovie { result in
            callback(self.handleTitleResponse(result: result))
        }
    }
    
    private func fetchPopularMovie(callback: @escaping([Title])->Void){
        TmdbRepository.shared.getPopularMovie { result in
            callback(self.handleTitleResponse(result: result))
        }
    }
        
    private func fetchTopRatedMovie(callback: @escaping([Title])->Void){
        TmdbRepository.shared.getToRatedMovie { result in
            callback(self.handleTitleResponse(result: result))
        }
    }
    
    private func handleTitleResponse(result: Result<[Title], ApiError>) -> [Title] {
        switch result {
        case .success(let  movieList):
            return movieList
        case.failure(let error):
            print(error)
        }
        return [Title]()
    }
    
}


extension HomeController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else  { return }
        header.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capFristLetter()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeedCell.identifier, for: indexPath) as? HomeFeedCell else { return UITableViewCell() }
        cell.delegate = self
        switch indexPath.section {
            case 0: fetchTrendingMovieList{ titleList in cell.configure(titleList: titleList) }
            case 1: fetchTrendingTvShows{ titleList in cell.configure(titleList: titleList) }
            case 2: fetchPopularMovie{ titleList in cell.configure(titleList: titleList) }
            case 3: fetchUpCommingMovie{ titleList in cell.configure(titleList: titleList) }
            case 4: fetchTopRatedMovie{ titleList in cell.configure(titleList: titleList) }
            default: cell.configure(titleList: [Title]())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset =  scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))
    }
    
}

extension HomeController: HomeFeedCellDelegate{
    func titleDidTap(model: TitlePreviewModel) {
        DispatchQueue.main.async {
            let vc = TitlePreviewViewController()
            vc.configure(model: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
