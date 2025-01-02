import UIKit

class HomeFeedCell: UITableViewCell {
    
    static let identifier:String = "HomeFeedCell"
    
    private var titleList:[Title] = [Title]()
    
    var delegate: HomeFeedCellDelegate? =  nil
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 180)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.idntifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(titleList:[Title]) {
        self.titleList = titleList
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func downloadAt(indexPath: IndexPath){
        DownloadRepository.shared.addToDownload(title: titleList[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name(AppConstent.downloadNotificationName), object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension HomeFeedCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.idntifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(title: titleList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("title: \(titleList[indexPath.row].titleName)")
        let query = titleList[indexPath.row].titleName
        
        YoutubeRepository.shared.getYoutubVideoId(videoTitle: "\(query) trailer") { result in
            switch(result){
            case .success(let youtubeVideo):
                print(youtubeVideo.id)
                guard let title = self.titleList[indexPath.row] as Title? else {return}
                guard let titleDetail = title.overview  else {return}
                let titlePreviewModel = TitlePreviewModel(titleName: title.titleName, titleDetail: titleDetail, videoId: youtubeVideo.id.videoId )
                self.delegate?.titleDidTap(model: titlePreviewModel)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let contextMenu = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { [weak self] _ in
                let downloadAction = UIAction(title: "Download") { _ in
                    self?.downloadAt(indexPath: indexPath)
                }
                return UIMenu(title: "", children: [downloadAction])
            }
        return contextMenu
    }
}

protocol HomeFeedCellDelegate {
    func titleDidTap(model:TitlePreviewModel)
}
