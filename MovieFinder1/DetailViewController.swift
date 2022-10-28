//
//  DetailViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import UIKit


class DetailViewController: UIViewController {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieSubTitle: UILabel!
    @IBOutlet weak var movieActor: UILabel!
    @IBOutlet weak var movieUserRating: UILabel!
    @IBOutlet weak var moviePubDate: UILabel!
    @IBOutlet weak var movieDirector: UILabel!
    
    
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var str1 = movie?.title
        str1 = str1?.replacingOccurrences(of: "<b>", with: "")
        str1 = str1?.replacingOccurrences(of: "</b>", with: "")
        movieTitle.text = str1
        
        
        var str2 = movie?.subtitle
        str2 = str2?.replacingOccurrences(of: "<b>", with: "")
        str2 = str2?.replacingOccurrences(of: "</b>", with: "")
        movieSubTitle.text = movie?.subtitle
        movieUserRating.text = "평점: \(movie?.userRating ?? "")"
        
        
        
        movieActor.text = "출연: \(movie?.actor ?? "")"
        moviePubDate.text = "개봉일: \(movie?.pubDate ?? "")"
        movieDirector.text = "감독: \(movie?.director ?? "")"
        
        if let imgURL = URL(string: movie?.image ?? ""){
            let request = URLRequest(url: imgURL)
            let session = URLSession.shared
            session.dataTask(with: request){data, _, _ in
                if let data = data{
                    let img = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.movieImageView.image = img
                    }
                }
            }.resume()
        }
//        movieImageView.image = UIImage(named: movie?.image ?? "")
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movie = self.movie
        let vc = segue.destination as? WebViewController
        vc?.movieURL = movie
    }
   

}
