//
//  FilmsViewController.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 22/06/2021.
//

import UIKit
import Network

class FilmsViewController: UIViewController {
    
    var filmListManager = FilmListManager()
    var dataManager = DataManager()
    
    var films:FilmListData?
    var watchedButtonState = [Bool]()
    
    var trackId:Int?
    let reuseIdentifier = "filmCell"
    
    let nc = NotificationCenter.default
    
    let nwCheck = NetworkCheck()

    
    var offLineToast: ToastView?
    
    var online = false {
        didSet {
            
            guard online != oldValue else {
                return
            }
            
            if online == true {
                print ("****** online observer says online state = True")

                offLineToast?.hide(after: 0)
                
                setUpOfflineToast()
                
            } else {
                print ("****** online observer says online = false")
                
                offLineToast?.show()

            }
        }
    }
    
    private let cache = NSCache<NSNumber, UIImage>()
    
    @IBOutlet weak var filmListCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        nc.addObserver(self, selector: #selector(reloadCollectionView), name: Notification.Name("reloadCollectionView"), object: nil)
        
        overrideUserInterfaceStyle = .dark
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        
        filmListCollectionView!.collectionViewLayout = layout
        filmListManager.delegate = self
        filmListManager.fetchFilmList()
        
        nwCheck.networkCheckDelegate = self
        
        setUpOfflineToast()
        
    }
    

    
    func setUpOfflineToast() {
        
        DispatchQueue.main.async { [self] in
            
            offLineToast = ToastView(title: "Off-Line",
                                          titleFont: .systemFont(ofSize: 15, weight: .semibold),
                                          subtitle: "Please verify your network connection",
                                          subtitleFont: .systemFont(ofSize: 12, weight: .light)
                                          )
            offLineToast?.willAutoHide = false
            
            
        }
        
    }
}

extension FilmsViewController: FilmListManagerDelegate {
    func didUpdateFilmList(filmList: FilmListData) {
        
        films = filmList
        
        DispatchQueue.main.async {
            
            self.filmListCollectionView.reloadData()
            
        }
    }
    
    func didFailWithError(error: Error) {
        
        print ("**** JSON decoding Error \(error)")
        
    }
    
    @objc func reloadCollectionView() {
        
        DispatchQueue.main.async {

           self.filmListCollectionView.reloadData()

        }
    }
}

// MARK:- CollectionView Delegate methods

extension FilmsViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var columns: Int
        columns = (Int(filmListCollectionView.frame.size.width) - 20) / 152
        let width = (filmListCollectionView.frame.size.width - (20 * (CGFloat(columns) + 1))) / CGFloat(columns)
        let height = (width * 1.5) + 44
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return films?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        guard let cell = cell as? FilmCollectionViewCell else { return }

        let itemNumber = NSNumber(value: indexPath.item)

        if let cachedImage = self.cache.object(forKey: itemNumber) {
            cell.filmArtwork.image = cachedImage
        } else {

            let url = (films?.results[indexPath.row].artworkUrl100)!
            let modifiedUrl = url.replacingOccurrences(of: "100x100", with: "600x600")

            ImageService.loadImage(url: modifiedUrl) { [weak self] (image) in
                guard let self = self, let image = image else { return }

                cell.filmArtwork.image = image
                cell.delegate = self
                self.cache.setObject(image, forKey: itemNumber)

            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FilmCollectionViewCell
        
        cell.spinner.startAnimating()
        
        let filmId = films?.results[indexPath.row].trackId
        let film = dataManager.returnFilm(filmId: Int64(filmId!))

        cell.watchedButton.isSelected = film.watched
        cell.bookmarkButton.isSelected = film.bookmarked
        cell.noteButton.isSelected = film.note != ""
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        trackId = films?.results[indexPath.item].trackId
        performSegue(withIdentifier: "FilmDetailVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilmDetailVC" {
            
            let destinationVC = segue.destination as! FilmDetailViewController
            destinationVC.trackId = trackId
            
        } else
        
            if segue.identifier == "addNoteVC" {
                
                let nav = segue.destination as! UINavigationController
                let addNoteVC = nav.topViewController as! AddNoteViewController
                
                addNoteVC.trackId = trackId
        }
    }
}

// MARK:- ButtonActionsDelegate methods


extension FilmsViewController: ButtonActionsDelegate {
    
    func didTapNote(cell: UICollectionViewCell) {
        
        let indexPathItem = filmListCollectionView.indexPath(for: cell)?.item
        
        trackId = films?.results[indexPathItem!].trackId
        
        performSegue(withIdentifier: "addNoteVC", sender: self)
        
    }
    
    
    func updateFilm(cell: UICollectionViewCell, watched: Bool, bookmarked: Bool) {
        
        let indexPathItem = filmListCollectionView.indexPath(for: cell)?.item
        let filmId = films?.results[indexPathItem!].trackId
        
        dataManager.updateFilm(id: Int64(filmId!), watched: watched, bookmarked: bookmarked)
    }
     
}

extension FilmsViewController: NetworkCheckDelegate {
    
    
    func statusDidChange(status: NWPath.Status) {
        
        
        switch status {
        case .unsatisfied:
            
           online = false
            
            
        default:
            
            online = true
            
            
        }
        
    }
    
    
    
    
}
