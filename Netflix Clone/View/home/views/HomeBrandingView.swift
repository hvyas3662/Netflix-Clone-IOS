import UIKit

class HomeBrandingView: UIView{
    
    private let playButton: UIButton  = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let downloadButton: UIButton  = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    
    private let movieName: UILabel = {
        let movieLable = UILabel();
        movieLable.translatesAutoresizingMaskIntoConstraints = false
        movieLable.font = .systemFont(ofSize: 18, weight: .bold)
        movieLable.textColor = UIColor.red
        movieLable.textAlignment = .center
        return movieLable
    }()
    
    private let branding: UIImageView  = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func addGradient() {
        let gradienteLayer  = CAGradientLayer()
        gradienteLayer.frame = bounds
        gradienteLayer.colors = [ UIColor.clear.cgColor, UIColor.black.cgColor ]
        layer.addSublayer(gradienteLayer)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(branding)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        addSubview(movieName)
        applyConstrent()
        attachClickListener()
    }
    
    private func applyConstrent() {
        
        let playButtonConstrant = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstrant = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let movieNameConstraint = [
            movieName.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12),
            movieName.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            movieName.widthAnchor.constraint(equalToConstant: 250)
        ]
        
        NSLayoutConstraint.activate(playButtonConstrant)
        NSLayoutConstraint.activate(downloadButtonConstrant)
        NSLayoutConstraint.activate(movieNameConstraint)
    }
    
    private func attachClickListener(){
        playButton.addTarget(self, action: #selector(onPlayButtonClicked), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(onDownloadClicked), for: .touchUpInside)
    }
    
    @objc func onPlayButtonClicked(){
        let alertController = UIAlertController(title: "Alret", message: "player button click", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }),
           let rootViewController = keyWindow.rootViewController {
            rootViewController.present(alertController, animated: true)
        }
    }
    
    @objc func onDownloadClicked(){
        
    }
    
    func configure(title:Title) {
        DispatchQueue.main.async {
            guard let url = URL(string: "\(AppConstent.imageUrl)\(title.poster_path ?? "")") else { return }
            self.branding.sd_setImage(with: url)
            self.movieName.text = title.titleName
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        branding.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
