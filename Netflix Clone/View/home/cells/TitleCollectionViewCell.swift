import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell{
    
    static let idntifier = "TitleCollectionViewCell"
    
    private let imaveView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imaveView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imaveView.frame = contentView.bounds
    }
    
    func configure(title:Title) {
        guard let url = URL(string: "\(AppConstent.imageUrlSmall)\(title.poster_path ?? "")") else {return}
        imaveView.sd_setImage(with: url, completed: nil)
    }
}
