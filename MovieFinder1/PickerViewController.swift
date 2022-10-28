//
//  PickerViewController.swift
//  MovieFinder1
//
//  Created by Eunchan Kim on 2022/10/28.
//

import UIKit

class PickerViewController: UIViewController {
    var mainVC:MainTableViewController?
    var urlString:String?
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let pickerListCountry = ["전체", "프랑스", "영국", "홍콩", "일본", "한국", "미국", "기타"]
    let countryCode = ["", "FR", "GB", "HK", "JP", "KR", "US", "ETC"]
    let pickerListGenre = ["전체", "드라마", "판타지", "서부", "공포", "로맨스", "모험", "스릴러", "느와르", "컬트", "다큐멘터리", "코미디", "가족", "미스터리", "전쟁", "애니메이션", "범죄", "뮤지컬", "SF", "액션", "무협", "에로", "서스펜스", "서사", "블랙코미디", "실험", "영화카툰", "영화음악", "영화패러디포스터"]
    let genreCode = ["","1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28"]
    
//    let pickerView = UIPickerView()
    var typeValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
    }
    
    @IBAction func actSearch(_ sender: Any) {
       
        let index0 = pickerView.selectedRow(inComponent: 0)
        if index0 > 0 {
            let country = countryCode[index0]
            mainVC?.country = country
        }
        let index1 = pickerView.selectedRow(inComponent: 1)
        if index1 > 0 {
            let genre = pickerListGenre[index1]
            mainVC?.genre = genre
        }
            dismiss(animated: true)
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

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerListCountry.count
        } else {
            return pickerListGenre.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
           
            return pickerListCountry[row]
           
        } else {
            return pickerListGenre[row]
        }
    }
}
