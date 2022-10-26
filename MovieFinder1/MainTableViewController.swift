//
//  MainTableViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var movies:[Movie] = []
    var page = 1
    
    let urlStirng = "https://openapi.naver.com/v1/search/movie.json?query=avengers&page=1"
  
    
    let clientID = "oLq9DBE3C1EBrxa3e7n0"
    let clientSecret = "6qZGV4cV8e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 180
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    func search(with query:String?, page:Int){
        guard let query = query else {return}
        let str = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&page=\(page)"
        
        //한글검색
        if let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strURL){
            var request = URLRequest(url: url)
            request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Id")
            request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
            let session = URLSession.shared
            
            let task = session.dataTask(with: request){
                data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let data = data else {return}
                
                if let result = try?
                    JSONDecoder().decode(ResultData.self, from: data){
                    self.movies = result.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                }
            }
            task.resume()
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let movie = movies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "moviecell", for: indexPath)

        let imageView = cell.viewWithTag(1) as? UIImageView
        if let url = URL(string: movie.image){
            let request = URLRequest(url: url)
            let session = URLSession.shared
            session.dataTask(with: request) { data, _, _ in
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                }
            }.resume()
        }
        
        let lblTitle = cell.viewWithTag(2) as? UILabel
        lblTitle?.text = movie.title
        
        let lblSubtitle = cell.viewWithTag(3) as? UILabel
        lblSubtitle?.text = movie.subtitle
        
        let lblPubDate = cell.viewWithTag(3) as? UILabel
        lblPubDate?.text = movie.pubDate
        
        let lblActor = cell.viewWithTag(4) as? UILabel
        lblActor?.text = movie.actor
        
        let lblUserRating = cell.viewWithTag(5) as? UILabel
        lblUserRating?.text = movie.userRating

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MainTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        page = 1
        search(with: searchBar.text, page: page)
        searchBar.resignFirstResponder()
    }
}
