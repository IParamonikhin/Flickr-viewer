//
//  ImageCell.swift
//  Hackaton
//
//  Created by Иван on 22.10.2023.
//

import UIKit
import SnapKit
import Kingfisher

class ImageCell: UICollectionViewCell{
    
    func confifure(_ url: URL?){
        self.url = url
        imageView.kf.setImage(with: url)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var url: URL?
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
}

private extension ImageCell{
    func initialize(){
        contentView.isUserInteractionEnabled = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}
