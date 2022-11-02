//
//  MainTableViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import UIKit

class MainTableViewController: UITableViewController {


    @IBOutlet weak var searchBar: UISearchBar!
    
    var backButton = UIButton()
    var nextButton = UIButton()
    
    // 검색 나라 설정
  
    var pickerView = UIPickerView()
    var typeValue = String()
    
    var movies:[Movie] = []
    var start = 1
    
    var urlStirng = "https://openapi.naver.com/v1/search/movie.json?"
    var genre: String?
    var country: String?
    
    
    let clientID = "oLq9DBE3C1EBrxa3e7n0"
    let clientSecret = "6qZGV4cV8e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        let firstView = "https://openapi.naver.com/v1/search/movie.json?&query=a&start=1"
        
        search(with: firstView, start: start)
        
        tableView.rowHeight = 180
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    /* 버튼 클릭시 액션시트
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
    */
    // MARK: - Table view data source

    func search(with query:String?, start:Int){
        
        
        print("urlString: \(query)")
       
        guard let query = query else {return}
        var localStirng = urlStirng.appending("query=\(query)&start=\(start)")
        
        if let genre = genre {
            localStirng = localStirng.appending("&genre=\(genre)")
        }
        if let country = country {
            localStirng = localStirng.appending("&country=\(country)")
        }
        
        //한글검색
        if let strURL = localStirng.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: strURL){
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
            print("strURL: \(strURL)")
            task.resume()
            genre = nil
            country = nil
        }
      
        backButton.isEnabled = start > 1
    }
      
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        
        footerView.backgroundColor = .white
        
        
        backButton = UIButton(frame: CGRect(x: 20, y: 5, width: 40, height: 40))
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        backButton.tintColor = .systemBlue
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        
        nextButton = UIButton(frame: CGRect(x: 340, y: 5, width: 40, height: 40))
        nextButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        nextButton.setPreferredSymbolConfiguration(.init(pointSize: 20), forImageIn: .normal)
        nextButton.tintColor = .systemBlue
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        
        footerView.addSubview(backButton)
        footerView.addSubview(nextButton)
        return footerView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    @objc func backButtonClick(_sender: UIButton){
        start -= 1
        search(with: searchBar.text, start: start)
        
        
        print("backbuttonClicked")
    }
    @objc func nextButtonClick(_sender: UIButton){
        start += 1
        
        search(with: searchBar.text, start: start)
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
        //DetailView 로 데이터 전송
        if segue.identifier == "detailsegue"{
            guard let indexPath = tableView.indexPathForSelectedRow else {return}
            let movie = self.movies[indexPath.row]
            let vc = segue.destination as? DetailViewController
            vc?.movie = movie
        } else {
            //modal로 데이터 이동
            guard let modalVc = self.storyboard?.instantiateViewController(withIdentifier: "modal") as? PickerViewController else {return}
            modalVc.mainVC = self
            present(modalVc, animated: true)
        }
    }


}
extension MainTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        start = 1
        search(with: searchBar.text, start: start)
        searchBar.resignFirstResponder()
    }
}

