//
//  ShowImageViewController.swift
//  Hackaton
//
//  Created by Иван on 23.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

class ShowImageViewController: UIViewController {
    
    var url: URL?
    
    func confifure(){
        imageView.kf.setImage(with: url)
    }
        override func viewDidLoad() {
        super.viewDidLoad()
        initialize() 
        confifure()
    }

    private var imageView = UIImageView()
    private var back = UIBarButtonItem()
}

private extension ShowImageViewController{
    func initialize(){
        self.view.backgroundColor = .black
        view.addSubview(imageView)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(50)
        }
    }
}
