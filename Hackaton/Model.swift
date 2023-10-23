//
//  Model.swift
//  Hackaton
//
//  Created by Иван on 23.10.2023.
//

import Foundation
import Alamofire
import SwiftyJSON

struct ImageLoadingStatistic{
    var currentPage = 0
    var pages = 0
    var loadedPage = 0
    var totalCount = 0
    var loadedCount = 0
    
    init(currentPage: Int = 0, pages: Int = 0, loadedPage: Int = 0, totalCount: Int = 0, loadedCount: Int = 0) {
        self.currentPage = currentPage
        self.pages = pages
        self.loadedPage = loadedPage
        self.totalCount = totalCount
        self.loadedCount = loadedCount
    }
}

struct PhotoData{
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    let farm: Int
    let ispublic: Int
    let isfriend: Int
    let isfamily: Int
    
    init(photoDictionary: JSON) {
        title = photoDictionary["title"].stringValue
        id = photoDictionary["id"].stringValue
        owner = photoDictionary["owner"].stringValue
        secret = photoDictionary["secret"].stringValue
        server = photoDictionary["server"].stringValue
        farm = photoDictionary["farm"].intValue
        ispublic = photoDictionary["ispublic"].intValue
        isfriend = photoDictionary["isfriend"].intValue
        isfamily = photoDictionary["isfamily"].intValue
    }
}

enum TypeFeed: String{
    case getRecent = "getRecent"
    case search = "search"
}

enum imgSize: String{
    case thumbnail = "_q"
    case full = "_b"
}


class Model{
    
    private let apiKey = "85f21a1cc05e9ea08463d363c0049ed1"
    
    var typeFeed = TypeFeed.getRecent
    
    var searchString = ""
    
    var loadedPhoto = ImageLoadingStatistic()
    var photos: [PhotoData] = []
    
    func getRequest(searchString: String, page: Int, success: @escaping() -> Void){
        let url = getFlickrSearchUrl(searchString: searchString, page: page)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (apiResponse) in
            guard let unwrResponse = apiResponse.value else { return }
            let json = JSON(unwrResponse)["photos"]
            
            self.loadedPhoto.currentPage = json["page"].intValue
            self.loadedPhoto.pages = json["pages"].intValue
            self.loadedPhoto.totalCount = json["total"].intValue
            
            let mapper_photos = JSON(rawValue: json["photo"].arrayValue)
            self.loadedPhoto.loadedCount += mapper_photos!.count
            for index in 0..<mapper_photos!.count{
                self.photos.append(PhotoData(photoDictionary: JSON(rawValue: mapper_photos![index])!))
            }
            success()
        }
    }
    
    func getRequest(page: Int, success: @escaping() -> Void){
        let url = getFlickrRecentUrl(page: page)
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (apiResponse) in
            guard let unwrResponse = apiResponse.value else { return }
            let json = JSON(unwrResponse)["photos"]
            
            self.loadedPhoto.currentPage = json["page"].intValue
            self.loadedPhoto.pages = json["pages"].intValue
            self.loadedPhoto.totalCount = json["total"].intValue
            
            let mapper_photos = JSON(rawValue: json["photo"].arrayValue)
            self.loadedPhoto.loadedCount += mapper_photos!.count
            for index in 0..<mapper_photos!.count{
                self.photos.append(PhotoData(photoDictionary: JSON(rawValue: mapper_photos![index])!))
            }
            success()
        }
    }
    
    func imageURL(photo: PhotoData, size: imgSize) -> URL? {
        if let url =  URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)\(size.rawValue).jpg") {
            return url
        }
        return nil
    }
}

private extension Model{
    
    func getFlickrRecentUrl ( page: Int) -> String{
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=\(apiKey)&per_page=25&page=\(page)&format=json&nojsoncallback=1"
        return URLString
    }
    func getFlickrSearchUrl (searchString: String, page: Int) -> String{
        let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(searchString)&per_page=25&page=\(page)&format=json&nojsoncallback=1"
        return URLString
    }

}
