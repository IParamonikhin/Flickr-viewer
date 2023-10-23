//
//  ViewController.swift
//  Hackaton
//
//  Created by Иван on 20.10.2023.
//

import UIKit
import SnapKit


class ImageCollectionViewController: UIViewController {
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad() 
             
        initialize()
        uploadData()
    }
    lazy var searchBar:UISearchBar = UISearchBar()
    private var collectionView : UICollectionView!
    
}

private extension ImageCollectionViewController{
    
    private func initialize(){
        self.view.backgroundColor = .black
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
        }
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.barTintColor = .black
        searchBar.searchTextField.backgroundColor = .green
        searchBar.tintColor = .red
        searchBar.delegate = self
        searchBar.showsSearchResultsButton = true
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(100)
            make.bottom.equalToSuperview()
        }
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func uploadData(){
        if model.loadedPhoto.loadedPage == 0 || (model.loadedPhoto.loadedPage < model.loadedPhoto.pages && model.loadedPhoto.loadedPage == model.loadedPhoto.currentPage){
            
            model.loadedPhoto.loadedPage += 1
            
            switch model.typeFeed{
            case .getRecent:
                self.model.getRequest(page: model.loadedPhoto.loadedPage) {
                    self.collectionView.reloadData()
                }
            case .search:
                self.model.getRequest(searchString: model.searchString ,page: model.loadedPhoto.loadedPage) {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ImageCollectionViewController:UISearchBarDelegate{
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let search = searchBar.text!
        searchBar.resignFirstResponder()
        model.photos.removeAll()
        model.loadedPhoto = ImageLoadingStatistic()
        model.searchString = search
        model.typeFeed = .search
        uploadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if model.typeFeed == .search{
            model.photos.removeAll()
            model.loadedPhoto = ImageLoadingStatistic()
            model.searchString = ""
            model.typeFeed = .getRecent
            uploadData()
        }
    }
    
    
    
}

extension ImageCollectionViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.loadedPhoto.loadedCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCell
        cell.confifure(model.imageURL(photo: model.photos[indexPath.row], size: imgSize.thumbnail))
        return cell
    }
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width - 20) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ShowImageViewController()
        vc.url = model.imageURL(photo: model.photos[indexPath.row], size: imgSize.full)
        navigationController?.navigationBar.tintColor = .green
        navigationController?.pushViewController(vc, animated: true)
    }
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.y + scrollView.frame.height >= scrollView.contentSize.height {
             uploadData()
         }
    }
}
