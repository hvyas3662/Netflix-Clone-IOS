import UIKit

class DownloadController: UIViewController {
    
    private var titleList: [TitleEntity] = [TitleEntity]()

    let tableView: UITableView = {
        let tabelView = UITableView()
        tabelView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tabelView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpLargeNavigationTitle()
        setTable()
        fetechDownloadingTitle()
        attachNotificationObserver()
    }
    
    private func setUpLargeNavigationTitle(){
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setTable() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetechDownloadingTitle() {
        DownloadRepository.shared.fetchDownloadList { result in
            switch result {
            case .success(let titleList):
                self.titleList = titleList
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func attachNotificationObserver(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(AppConstent.downloadNotificationName), object: nil, queue: nil) { _ in
            self.fetechDownloadingTitle()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension DownloadController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let titleEntry = titleList[indexPath.row]
        cell.configure(titleEntity: titleEntry)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DownloadRepository.shared.deleteFromDownload(title: titleList[indexPath.row]) { result in
                switch result {
                case .success():
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.titleList.remove(at: indexPath.row)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
