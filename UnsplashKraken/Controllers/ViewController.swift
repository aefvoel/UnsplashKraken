//
//  ViewController.swift
//  UnsplashKraken
//
//  Created by Toriq Wahid Syaefullah on 30/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var seachBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    private var params = Parameter()
    private let apiRequest = APIRequest()
    private var searchResults = [JSON](){
        didSet {
            for img in searchResults {
                if let url = img["urls"]["thumb"].string {
                    apiRequest.fetchImage(url: url, completionHandler: { image, _ in
                        self.imgResults.append(image!)
                    })
                }
            }
        }
    }
    private var imgResults = [UIImage](){
        didSet {
            collectionView.reloadData()
        }
    }
    private var isSearch : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        fetchData(params: params)
    }
    
    func registerNib() {
        self.title = "Unsplash Kraken"
        let nib = UINib(nibName: PhotoCell.nibName, bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
    
    func fetchData(params: Parameter){
        apiRequest.searchImage(params: params, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            self?.searchResults.append(contentsOf: results)
        })
    }
}
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return imgResults[indexPath.item].size.height
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseIdentifier,
                                                         for: indexPath) as? PhotoCell {
            cell.indicatorView.stopAnimating()
            cell.configureCell(image: imgResults[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            params.page = String(Int(params.page)! + 1)
            fetchData(params: params)
        }
    }
}
extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults.removeAll()
        imgResults.removeAll()
        params.page = "1"
        fetchData(params: params)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        params.query = searchText
    }
}


