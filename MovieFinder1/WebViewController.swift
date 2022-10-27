//
//  WebViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/26.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var movieURL: Movie?
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let movieURL = self.movieURL, let url = URL(string: movieURL.link) else {return}
        let request = URLRequest(url: url)
        webView.load(request)
        
        print("request: \(request)")
        
        //        if let movieURL = URL(string: movie?.link ?? "https://www.naver.com"){
//            let request = URLRequest(url: movieURL)
//            webView.load(request)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


