import UIKit

class UpComingController: UIViewController {
    
    private var titleList: [Title] = [Title]()
    
    private let upcomingTableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLargeNavigationTitle()
        setUpUpCommingTable()
        fetechUpCommingMoview()
    }
    
    private func setUpLargeNavigationTitle(){
        title = "Upcomimng"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpUpCommingTable(){
        view.addSubview(upcomingTableView)
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
    }
    
    private func fetechUpCommingMoview(){
        TmdbRepository.shared.getUpcommingMovie { [weak self] result in
            switch result {
                case .success(let titleList):
                    self?.titleList = titleList
                case .failure(let error):
                    print(error)
            }
            
            DispatchQueue.main.async {
                self?.upcomingTableView.reloadData()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableView.frame = view.bounds
    }
    
}

extension UpComingController : UITableViewDelegate, UITableViewDataSource {
    
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
