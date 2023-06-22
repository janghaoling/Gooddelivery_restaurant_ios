//
//  ChangeLanguageViewController.swift
//  OrderAroundRestaurant
//
//  Created by ZhangXH on 7/3/20.
//  Copyright © 2020 CSS. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: BaseViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var languageListTableView: UITableView!
    
    var selectedIndex = -1
    
    private var selectedLanguage : Language = .spanish {
        didSet{
            setLocalization(language: selectedLanguage)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialLoad()
    }
    
    //MARK:- viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        enableKeyboardHandling()
        self.navigationController?.isNavigationBarHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        disableKeyboardHandling()

        self.navigationController?.isNavigationBarHidden = true
    }
}


extension ChangeLanguageViewController {
    
    private func initialLoad() {
        setNavigationController()
        
        languageListTableView.tableFooterView = UIView()
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        if let lang = UserDefaults.standard.value(forKey: Constant.string.language) as? String, let language = Language(rawValue: lang) {
            selectedLanguage = language
        }
        
        titleLabel.text = APPLocalize.localizestring.changeLanguage.localize()
        
    }
    
    private func setNavigationController(){
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.primary
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.bold(size: 18), NSAttributedString.Key.foregroundColor : UIColor.white]
        self.title = APPLocalize.localizestring.changeLanguage.localize()
        let btnBack = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: "back-white"), for: .normal)
        btnBack.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnBack.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        let item = UIBarButtonItem(customView: btnBack)
        self.navigationItem.setLeftBarButtonItems([item], animated: true)
        
    }
    
    private func switchSettingPage() {
        self.navigationController?.isNavigationBarHidden = true // For Changing backbutton direction on RTL Changes
        guard let transitionView = self.navigationController?.view else {return}
        let settingVc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.RestaurantMenuViewController)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationCurve(.easeInOut)
//        UIView.setAnimationTransition(selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
        self.navigationController?.pushViewController(settingVc, animated: true)
//        self.navigationController?.popViewController(animated: true)
        self.navigationController?.isNavigationBarHidden = true
        UIView.commitAnimations()
        if (navigationController?.viewControllers.count)! > 2 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: Tableview Datasource and Delegate
// UItableView Datasource
extension ChangeLanguageViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Language.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingPageCell", for: indexPath) as! settingPageCell
        cell.textLabel?.textAlignment = .left
        
        cell.textLabel?.text = Language.allCases[indexPath.row].title.localize()
        cell.accessoryType = selectedLanguage == Language.allCases[indexPath.row] ? .checkmark : .none
                
        return cell
    }
    
}

// UItableView Delegate
extension ChangeLanguageViewController: UITableViewDelegate {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let language = Language.allCases[indexPath.row]
        //   var languageObject = LocalizationEntity()
        //   languageObject.language = language
        //     self.presenter?.post(api: .updateLanguage, data: languageObject.toData()) // Sending selected language to backend
        guard language != self.selectedLanguage else {return}
        self.selectedLanguage = language
        UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: Constant.string.language)
        self.languageListTableView.reloadRows(at: (0..<Language.allCases.count).map({IndexPath(row: $0, section: 0)}), with: .automatic)
        selectedIndex = indexPath.row
        self.languageListTableView.reloadData()
        self.switchSettingPage()
    }
}

class settingPageCell : UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
