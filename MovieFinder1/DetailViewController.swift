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
        
        movieTitle.text = movie?.title
        movieSubTitle.text = movie?.subtitle
        movieUserRating.text = "평점: \(movie?.userRating ?? "")"
        movieActor.text = "출연: \(movie?.actor ?? "")"
        moviePubDate.text = "개봉일: \(movie?.pubDate ?? "")"
        movieDirector.text = "감독: \(movie?.director ?? "")"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionLink(_ sender: UIButton) {
       
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movie = self.movie
        let vc = segue.destination as? WebViewController
        vc?.movieURL = movie
//        let movieURL = self.movie?.link
//        let vc = segue.destination as? WebViewController
//        vc?.movieURL = movieURL
    }
   

}
