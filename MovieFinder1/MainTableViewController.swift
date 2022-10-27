//
//  MainTableViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import UIKit

class MainTableViewController: UITableViewController {

    @IBOutlet weak var prevBtn: UIBarButtonItem!
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // 검색 나라 설정
    let pickerList = ["프랑스", "영국", "홍콩", "일본", "한국", "미국", "기타"]
    var pickerView = UIPickerView()
    var typeValue = String()
    
    var movies:[Movie] = []
    var start = 1
    
    let urlStirng = "https://openapi.naver.com/v1/search/movie.json?query=avengers&start=1"
  
    
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
    
    @IBAction func actPick(_ sender: Any) {
        let alert = UIAlertController(title: "국가를 선택하세요", message: "\n\n\n\n\n\n", preferredStyle: .actionSheet)
        alert.modalPresentationCapturesStatusBarAppearance = true
        let pickerFrame = UIPickerView(frame: CGRect(x: -8, y: 20, width: self.view.frame.width, height: 140))
        alert.view.addSubview(pickerFrame)
        pickerFrame.delegate = self
        pickerFrame.dataSource = self
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: {(UIAlertAction) in print("\(self.typeValue)")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    func search(with query:String?, start:Int){
        guard let query = query else {return}
        let str = "https://openapi.naver.com/v1/search/movie.json?query=\(query)&start=\(start)"
        
        //한글검색
        if let strURL = str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strURL){
            var request = URLRequest(url: url)
            request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
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
        prevBtn.isEnabled = start > 1
    }
    
    
    @IBAction func actNext(_ sender: Any) {
        start += 1
        search(with: searchBar.text, start: start)
    }
    @IBAction func actPrev(_ sender: Any) {
        start -= 1
        search(with: searchBar.text, start: start)
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
       
        var str1 = movie.title.replacingOccurrences(of: "<b>", with: "")
        str1 = str1.replacingOccurrences(of: "</b>", with: "")
        lblTitle?.text = str1
       
        
        let lblSubtitle = cell.viewWithTag(3) as? UILabel
        var str2 = movie.subtitle.replacingOccurrences(of: "<b>", with: "")
        str2 = str2.replacingOccurrences(of: "</b>", with: "")
        lblSubtitle?.text = str2
        
        let lblPubDate = cell.viewWithTag(4) as? UILabel
        lblPubDate?.text = movie.pubDate
        
        let lblDirector = cell.viewWithTag(5) as? UILabel
        lblDirector?.text = movie.director
        
        let lblUserRating = cell.viewWithTag(6) as? UILabel
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let movie = self.movies[indexPath.row]
        let vc = segue.destination as? DetailViewController
        vc?.movie = movie
    }


}
extension MainTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        start = 1
        search(with: searchBar.text, start: start)
        searchBar.resignFirstResponder()
    }
}

extension MainTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            typeValue = "FR"
        } else if row == 1 {
            typeValue = "GB"
        }else if row == 2 {
            typeValue = "HK"
        }else if row == 3 {
            typeValue = "JP"
        }else if row == 4 {
            typeValue = "KR"
        }else if row == 5 {
            typeValue = "US"
        }else if row == 6 {
            typeValue = "ETC"
        }
    }
    
}
