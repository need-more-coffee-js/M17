//
//  ViewController.swift
//  m17
//
//  Created by Денис Ефименков on 24.12.2024.
//

import UIKit
import SnapKit
class ViewController: UIViewController {
    
    let service = Service()
    
    var images: [UIImage] = []
    
    private lazy var stackView: UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5
        view.backgroundColor = .systemCyan
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 140, height: 140))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        activityIndicator.startAnimating()
        onLoad()
        setups()
    }

    private func onLoad() {
        let dispatchGroup = DispatchGroup()
        for _ in 0...4{
            dispatchGroup.enter()
            self.service.getImageURL { urlString, error in
                guard let urlString = urlString else {return}
                let image = self.service.loadImage(urlString: urlString)
                self.images.append(image!)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            
            for i in 0...4{
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                imageView.contentMode = .scaleAspectFit
                imageView.image = self.images[i]
                self.stackView.addArrangedSubview(imageView)
            }
        }
    }
    
// MARK: - Constraints
    
    func setups(){
        stackView.snp.makeConstraints { sv in
            sv.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
            sv.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin)
            sv.left.right.equalToSuperview()
        }
    }
}


