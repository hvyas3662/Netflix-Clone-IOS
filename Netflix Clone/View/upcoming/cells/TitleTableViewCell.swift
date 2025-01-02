import UIKit

class TitleTableViewCell: UITableViewCell{
    
    static let identifier = "UpcomingTableViewCell"
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let label: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.numberOfLines = 0
        lable.lineBreakMode = .byWordWrapping
        return lable
    }()
    
    private let playButton: UIButton = {
        let playButton = UIButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        playButton.setImage(image, for: .normal)
        playButton.tintColor = .label
        return playButton
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterView)
        contentView.addSubview(label)
        contentView.addSubview(playButton)
        applyConstrant()
    }
    
    private func applyConstrant() {
    
        let posterViewConstrants = [
                posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                posterView.widthAnchor.constraint(equalToConstant: 100)
            ]
            NSLayoutConstraint.activate(posterViewConstrants)

            let titleLabelConstraints = [
                label.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 20),
                label.trailingAnchor.constraint(lessThanOrEqualTo: playButton.leadingAnchor, constant: -10),
                label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                label.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
            NSLayoutConstraint.activate(titleLabelConstraints)

            let playTitleButtonConstraints = [
                playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ]
            NSLayoutConstraint.activate(playTitleButtonConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(title:Title) {
        guard let url = URL(string: "\(AppConstent.imageUrlSmall)\(title.poster_path ?? "")") else { return }
        posterView.sd_setImage(with: url)
        label.text = title.titleName
    }
    
    func configure(titleEntity:TitleEntity) {
        guard let url = URL(string: "\(AppConstent.imageUrlSmall)\(titleEntity.photo_path ?? "")") else { return }
        posterView.sd_setImage(with: url)
        label.text = titleEntity.title
    }
    
}
