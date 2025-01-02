import UIKit

class SearchResultViewController: UIViewController {
    
    private var titleList:[Title] = [Title]()

    var delegate: SearchResultViewControllerDelegate? = nil
    
    private let collectionView: UICollectionView = {
        let column: CGFloat = 3
        let gap: CGFloat = 8
        let screenWidth = UIScreen.main.bounds.width
        
        let layout = UICollectionViewFlowLayout()
        
        let itemWidth = (screenWidth - ((column - 1) * gap)) / column
        layout.itemSize = CGSize(width: itemWidth ,  height: 180)
        layout.minimumInteritemSpacing = gap
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.idntifier)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func updateSearchResult(titleList: [Title]){
        self.titleList = titleList
        collectionView.reloadData()
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
        
        let title = titleList[indexPath.row]
        
        YoutubeRepository.shared.getYoutubVideoId(videoTitle: title.titleName) { result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    self.delegate?.titleDidTap(model: TitlePreviewModel(titleName: title.titleName, titleDetail: title.overview ?? "", videoId: videoElement.id.videoId))
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

protocol SearchResultViewControllerDelegate{
    func titleDidTap(model:TitlePreviewModel)
}

