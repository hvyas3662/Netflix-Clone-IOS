import UIKit;
import WebKit;

class TitlePreviewViewController: UIViewController {
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
       return webView
    }()
    
    private let titleView:UILabel = {
        let titleLable = UILabel()
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        titleLable.font = .systemFont(ofSize: 20, weight: .bold)
        titleLable.text = "this is title"
        titleLable.numberOfLines = 0
        return titleLable
    }()
    
    private let detailView: UILabel = {
        let detailLabel = UILabel()
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.font = .systemFont(ofSize: 16, weight: .regular)
        detailLabel.numberOfLines = 0
        detailLabel.text = "this is detaol and thes going to be of multi ple lines"
        return detailLabel
    }()
    
    private let downloadButton: UIButton = {
        let button  = UIButton()
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleView)
        view.addSubview(detailView)
        view.addSubview(downloadButton)
        applyConstrants()
    }
    
    private func applyConstrants() {
        let webViewConstraint = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 200)
        ]
        
        let titleConstraint = [
            titleView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 16),
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ]
        
        let detailConstraint = [
            detailView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 8),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: detailView.bottomAnchor, constant: 32),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        NSLayoutConstraint.activate(webViewConstraint)
        NSLayoutConstraint.activate(titleConstraint)
        NSLayoutConstraint.activate(detailConstraint)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(model:TitlePreviewModel) {
        titleView.text = model.titleName
        detailView.text = model.titleDetail
        guard let url = URL(string: "\(AppConstent.youtybePlayer)\(model.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
    
}
