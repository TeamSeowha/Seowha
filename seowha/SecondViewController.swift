//
//  SecondViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 20/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

import Firebase

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var db: Firestore!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var filtered:[DocumentSnapshot] = []
    
    let typeDictionary: Dictionary = [
        "play": "연극",
        "musical": "뮤지컬",
        "classical": "클래식/무용",
        "concert": "콘서트",
        "festival": "페스티벌/축제",
        "exhibition": "전시",
        "event": "행사",
        "sport": "스포츠"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(rgb: 0xEF706A),
            NSAttributedString.Key.font: UIFont(name: "YunTaemin", size: 40)!
        ]
        self.navigationController?.navigationBar.tintColor = UIColor(rgb: 0xEF706A)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor(rgb: 0xCCCCCC).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
        
        tableView.separatorStyle = .none
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
//        let customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab2_search_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab2_search_on"))
//        self.tabBarItem = customTabBarItem
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        searchBar.endEditing(true)
        
        self.filtered.removeAll()
        
        let activitiesRef = db.collection("activities")
        
        let searchQuery = activitiesRef.whereField("name", isGreaterThanOrEqualTo: searchBar.text ?? "")
        
        searchQuery.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            
            for document in querySnapshot!.documents {
                self.filtered.append(document)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtered.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = filtered[indexPath.row].data()!
        
        let cell = UITableViewCell()
        
        let cardView: UICardView = UICardView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        if activity["image_url"] is NSNull || activity["image_url"] == nil {
            cardView.setThumnail(UIImage(named: "launch.jpg")!)
        } else {
            cardView.setThumnail(activity["image_url"] as! String)
        }
        
        cardView.setTitle(activity["name"] as! String)
        cardView.setLocation(activity["location"] as! String)
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy.MM.dd"
        
        let start_at: String = formatter.string(from: (activity["start_at"] as! NSDate) as Date)
        
        var end_at: String = ""
        if activity["end_at"] is NSNull {
            end_at = "미정"
        } else {
            end_at = formatter.string(from: (activity["end_at"] as! NSDate) as Date)
        }
        
        cardView.setAt(start_at + "-" + end_at)
        cardView.setType(typeDictionary[activity["type"] as! String] ?? "")
        
        var tags: String = ""
        
        for with in activity["with"] as? [String] ?? [] {
            tags += "#" + with + " "
        }
        
        cardView.setTags(tags)

        cell.addSubview(cardView)

        cardView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 30).isActive = true
        cardView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -30).isActive = true
        cardView.topAnchor.constraint(equalTo: cell.topAnchor, constant: 10).isActive = true
        cardView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: -10).isActive = true
        
        return cell;
    }
}

