//
//  ChosenTableViewController.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 19/07/2021.
//

import UIKit

class ChosenTableViewController: UITableViewController {

    let dataManager = DataManager()
    var filmListManager = FilmListManager()
    var chosenFilmList = [Film]()
    var films:FilmListData?
    var filmsToDisplay = [DisplayFilms]()
    var filmsToDisplayFiltered = [DisplayFilms]()
    var trackId:Int?
    var removeMessage:String?
    
    let nc = NotificationCenter.default
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        filmListManager.fetchFilmList()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nc.addObserver(self, selector: #selector(reloadTableView), name: Notification.Name("reloadTableView"), object: nil)
        
        overrideUserInterfaceStyle = .dark
        
        filmListManager.delegate = self
        
        // get all films from iTunes
        
        filmListManager.fetchFilmList()
      
    }
    
    
    func filterFilms() {
        
        let selectedIndex = tabBarController!.selectedIndex
        
        switch selectedIndex {
        
        case 1:
            
            filmsToDisplayFiltered = filmsToDisplay.filter{ $0.bookmarked
                == true }
        case 2 :
        
        filmsToDisplayFiltered = filmsToDisplay.filter{ $0.watched == true }
            
        default:
            break
        }
        
    }
    
    @objc func reloadTableView() {
        
        filmListManager.fetchFilmList()
        
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filmsToDisplayFiltered.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chosenCell", for: indexPath) as! ChosenTableViewCell
        
        let url = filmsToDisplayFiltered[indexPath.row].artworkURL
        
        ImageService.loadImage(url: url) { (image) in
            guard let image = image else { return }
            cell.artwork.image = image

        }
        
        cell.title.text = filmsToDisplayFiltered[indexPath.row].title
        cell.detail.text = filmsToDisplayFiltered[indexPath.row].detail
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        trackId = filmsToDisplayFiltered[indexPath.row].filmId
        performSegue(withIdentifier: "FilmDetailVC", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilmDetailVC" {
            
            let destinationVC = segue.destination as! FilmDetailViewController
            destinationVC.trackId = trackId
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
        let selectedIndex = tabBarController!.selectedIndex
        
        switch selectedIndex {
        
        case 1:
            
            removeMessage = "Remove from Bookmarked"
            
        case 2 :
        
            removeMessage = "Remove from Watched"
            
        default:
            break
        }
        
        let delete = UIContextualAction(style: .destructive, title: removeMessage) { [self] (action, view, completion) in
            
            deleteFilm(at: indexPath)

        }
    
        return UISwipeActionsConfiguration.init(actions: [delete])
        
    }
    
    func deleteFilm(at indexPath: IndexPath) {
      
        tableView.beginUpdates()
        
        let filmId = filmsToDisplayFiltered[indexPath.row].filmId
        
        // Update in core data
        
        let selectedIndex = tabBarController!.selectedIndex
        let film = dataManager.returnFilm(filmId: Int64(filmId))
        let bookmarked = film.bookmarked
        let watched = film.watched
        
        switch selectedIndex {
        
        case 1:
            
            dataManager.updateFilm(id: Int64(filmId), watched: watched, bookmarked: false)
            
        case 2 :
        
            dataManager.updateFilm(id: Int64(filmId), watched: false, bookmarked: bookmarked)
            
        default:
            break
        }
        
        filmsToDisplayFiltered.removeAll(where: {( $0.filmId == filmId )})
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
        
        nc.post(name: Notification.Name("reloadCollectionView"), object: nil)
    }
    
}


extension ChosenTableViewController: FilmListManagerDelegate {
    
    func didUpdateFilmList(filmList: FilmListData) {
        
        chosenFilmList = dataManager.returnFilmList()
        
        films = filmList
        
        filmsToDisplay.removeAll()
        
        // Build an array of films with their details to display
        
        guard chosenFilmList.count != 0 else { return }
        
        for i in 0 ... chosenFilmList.count - 1 {
            
            for x in 0 ... (films?.results.count)! - 1 {
                
                if chosenFilmList[i].filmId == (films?.results[x].trackId)! {
                    
                    let filmId = films?.results[x].trackId
                    let title = films?.results[x].trackName
                    let detail = films?.results[x].longDescription
                    let url = films?.results[x].artworkUrl100
                    let modifiedUrl = url!.replacingOccurrences(of: "100x100", with: "200x200")
                    let watched = chosenFilmList[i].watched
                    let bookmarked = chosenFilmList[i].bookmarked
                    
                    let tmp = DisplayFilms(filmId: filmId!, title: title!, detail: detail!, artworkURL: modifiedUrl, watched: watched, bookmarked: bookmarked)
                    
                    filmsToDisplay.append(tmp)
                    
                }
            }
        }
        
        DispatchQueue.main.async { [self] in
           filterFilms()
           tableView.reloadData()
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        print ("**** JSON decoding Error \(error)")
    }
    
}
