//
//  FilmDetailViewController.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 29/06/2021.
//

import UIKit
import GoogleMobileAds

class FilmDetailViewController: UIViewController {

    var trackId:Int?
    
    var filmListManager = FilmListManager()
    var dataManager = DataManager()
    var films:FilmListData?
    
    var gadBannerView: GADBannerView!
    
    let nc = NotificationCenter.default
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        
      // Note loadBannerAd is called in viewDidAppear as this is the first time that
      // the safe area is known. If safe area is not a concern (e.g., your app is
      // locked in portrait mode), the banner can be loaded in viewWillAppear.
      loadBannerAd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nc.addObserver(self, selector: #selector(didAddNote), name: Notification.Name("didAddNote"), object: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        filmListManager.delegate = self
        
        filmListManager.fetchFilmList(for: trackId!)
        
        createBannerView()
        
    }
    
    
    @objc func didAddNote() {
        
        tableView.reloadData()
        
    }

}



extension FilmDetailViewController: FilmListManagerDelegate {
    func didUpdateFilmList(filmList: FilmListData) {
        
        films = filmList
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
    }
    
    func didFailWithError(error: Error) {
        
        print ("**** JSON decoding Error \(error)")
        
    }
    
}

// MARK:- Tableview delegate methods

extension FilmDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print (indexPath.row)
        
        switch indexPath.row {
        
        
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilmDetailArtworkCell", for: indexPath) as! FilmDetailArtworkCell
            
            let url = (films?.results[0].artworkUrl100) ?? "nil"

            let modifiedUrl = url.replacingOccurrences(of: "100x100", with: "800x800")


            ImageService.loadImage(url: modifiedUrl) { (image) in
                guard let image = image else { return }

                cell.kenBurns.addImage(image: image)
                cell.kenBurns.animateWithImages([image], imageAnimationDuration: 7, initialDelay: 0, shouldLoop: true)
            }
            
            return cell
            
        case 1:
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmDetailInfoCell", for: indexPath) as! FilmDetailInfoCell
        
            let releaseDateString = films?.results[0].releaseDate.stringDateAsFormattedString() ?? "Loading ..."
            
            let durationMilliseconds = films?.results[0].trackTimeMillis ?? 0
            let filmDesc = films?.results[0].longDescription ?? "Loading ..."
            cell.filmTitle.text = films?.results[0].trackName
            let dateDurationText = "\(releaseDateString) - \(filmDuration(milliseconds: durationMilliseconds))"
            cell.dateDuration.text = dateDurationText
            cell.filmDescription.text = filmDesc
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilmDetailButtonsCell", for: indexPath) as! FilmDetailButtonsCell
            
            cell.delegate = self
            
            let filmId = films?.results[0].trackId ?? 0
            
            // print ("FilmId = ", filmId as Any)
            
            let film = dataManager.returnFilm(filmId: Int64(filmId))
            
            cell.watchedButton.isSelected = film.watched
            cell.bookmarkButton.isSelected = film.bookmarked
            cell.noteButton.isSelected = film.note != ""
            
            return cell
            
        case 3:
            let cell = FilmDetailAdmobCell()
            cell.addBannerViewToView(gadBannerView)
            return cell
            
        default:
            break
        }
        

        return UITableViewCell.init()
    }
    
    func filmDuration(milliseconds: Int) -> String {
    
        let minutes = (milliseconds / (1000*60) % 60)
        let hours = (milliseconds / (1000*60*60)) % 24
        
        let hoursplural = hours == 1 ? "" : "s"
        let minutesplural = minutes == 1 ? "" : "s"
        
        return "\(hours) hour\(hoursplural) \(minutes) minute\(minutesplural)"

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNoteVC" {
            
            let nav = segue.destination as! UINavigationController
            let addNoteVC = nav.topViewController as! AddNoteViewController
            
            addNoteVC.trackId = trackId
        }
    }
}

// MARK:- DetailButtonActionsDelegate

extension FilmDetailViewController: DetailButtonActionsDelegate {
    
    func didTapNoteButton() {
        
        performSegue(withIdentifier: "addNoteVC", sender: self)
        
    }
    
    
    func updateFilm(watched: Bool, bookmarked: Bool) {
        
        let filmId = films?.results[0].trackId
        
        dataManager.updateFilm(id: Int64(filmId!), watched: watched, bookmarked: bookmarked)
    }
    
}

extension FilmDetailViewController: GADBannerViewDelegate {
    
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
      gadBannerView.alpha = 0
      UIView.animate(withDuration: 1, animations: {
        bannerView.alpha = 1
      })
    }
    
    func createBannerView() {
        gadBannerView = GADBannerView()
        gadBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        gadBannerView.rootViewController = self
        gadBannerView.delegate = self
        gadBannerView.backgroundColor = .clear
    }
    
    func loadBannerAd() {
      // Step 2 - Determine the view width to use for the ad width.
      let frame = { () -> CGRect in
        // Here safe area is taken into account, hence the view frame is used
        // after the view has been laid out.
        if #available(iOS 11.0, *) {
          return view.frame.inset(by: view.safeAreaInsets)
        } else {
          return view.frame
        }
      }()
       let viewWidth = frame.size.width

      // Step 3 - Get Adaptive GADAdSize and set the ad view.
      // Here the current interface orientation is used. If the ad is being preloaded
      // for a future orientation change or different orientation, the function for the
      // relevant orientation should be used.
      gadBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

      // Step 4 - Create an ad request and load the adaptive banner ad.
      gadBannerView.load(GADRequest())
    }
    
    override func viewWillTransition(to size: CGSize,
                            with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to:size, with:coordinator)
      coordinator.animate(alongsideTransition: { _ in
        self.loadBannerAd()
      })
    }
    
}

