//
//  FirstViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 20/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit
import iCarousel

import Firebase

class FirstViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    class TypeUILabel : UILabel {
        override func drawText(in rect: CGRect) {
            let insets = UIEdgeInsets.init(top: 3, left: 7, bottom: 3, right: 7)
            super.drawText(in: rect.inset(by: insets))
        }
    }
    
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
    
    var db: Firestore!
    var items: [DocumentSnapshot] = []
    @IBOutlet weak var activitiesCarousel: iCarousel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
        
        let backItem = UIBarButtonItem()
        backItem.title = "뒤로가기"
        navigationItem.backBarButtonItem = backItem
        
//        let customTabBarItem: UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab1_home_off")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: UIImage(named: "tab1_home_on"))
//        self.tabBarItem = customTabBarItem
        
        activitiesCarousel.type = .rotary
        
        let userRef = db.collection("users").document(Auth.auth().currentUser!.uid)
        let activitiesRef = db.collection("activities")
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let interests = document.data()?["interests"] as! [String]
                
                for interest in interests {
                    let recommendationsQuery = activitiesRef.whereField("type", isEqualTo: interest)
                    
                    recommendationsQuery.getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                            return
                        }
                        
                        for document in querySnapshot!.documents {
                            self.items.append(document)
                            self.activitiesCarousel.reloadData()
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return items.count
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Pressed")
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let activityViewController = ActivityViewController(nibName: "ActivityViewController", bundle: nil)
        activityViewController.activity = items[tappedImage.tag].data()
        self.navigationController?.pushViewController(activityViewController, animated: true)
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var nameLabel: UILabel
        var typeLabel: UILabel
        var itemView: UIImageView
        
        let recommendation = items[index].data()
        
        //reuse view if available, otherwise create a new view
        if let view = view as? UIImageView {
            itemView = view
            //get a reference to the label in the recycled view
            nameLabel = itemView.viewWithTag(-1) as! UILabel
            typeLabel = itemView.viewWithTag(-2) as! UILabel
        } else {
            //don't do anything specific to the index within
            //this `if ... else` statement because the view will be
            //recycled and used with other index values later
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 350))
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            itemView.addGestureRecognizer(tapGestureRecognizer)
            
            itemView.contentMode = .scaleAspectFill
            itemView.isUserInteractionEnabled = true
            
            for i in 0 ... 2 {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                
                var image: UIImage!
                
                if i == 0 {
                    image = UIImage(named: "button_arrow.png")
                } else if i == 1 {
                    image = UIImage(named: "button_wishlist.png")
                } else if i == 2 {
                    image = UIImage(named: "button_x-in-circle.png")
                }
                
                button.setImage(image, for: .normal)
                itemView.addSubview(button)
                
                let buttonSize: CGFloat = 50.0
                
                button.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
                button.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
                button.centerXAnchor.constraint(equalTo: itemView.centerXAnchor, constant: CGFloat((i - 1) * 50)).isActive = true
                button.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: buttonSize / 2).isActive = true
            }
            nameLabel = UILabel(frame: itemView.bounds)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.backgroundColor = .clear
            nameLabel.textAlignment = .center
            nameLabel.font = nameLabel.font.withSize(17)
            nameLabel.tag = -1
            itemView.addSubview(nameLabel)
            
            nameLabel.centerXAnchor.constraint(equalTo: itemView.centerXAnchor).isActive = true
            nameLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: 60).isActive = true
            
            typeLabel = UILabel(frame: itemView.bounds)
            typeLabel.translatesAutoresizingMaskIntoConstraints = false
            typeLabel.backgroundColor = .clear
            typeLabel.textAlignment = .center
            typeLabel.font = typeLabel.font.withSize(13)
            typeLabel.sizeToFit()
            typeLabel.frame = CGRect(x: 0, y: 0, width: typeLabel.frame.width + 20, height:typeLabel.frame.height + 10)
            typeLabel.layer.borderColor = UIColor.black.cgColor;
            typeLabel.layer.borderWidth = 1.0;
            typeLabel.tag = -2
            itemView.addSubview(typeLabel)
            
            typeLabel.leadingAnchor.constraint(equalTo: itemView.leadingAnchor).isActive = true
            typeLabel.bottomAnchor.constraint(equalTo: itemView.bottomAnchor, constant: 80).isActive = true
        }
        
        if recommendation?["image_url"] is NSNull || recommendation?["image_url"] == nil {
            itemView.image = UIImage(named: "launch.jpg")
        } else {
            if let url = URL(string: recommendation?["image_url"] as! String) {
                itemView.downloaded(from: url, contentMode: .scaleAspectFill)
            }
        }
        
        nameLabel.text = recommendation?["name"] as? String
        typeLabel.text = typeDictionary[(recommendation?["type"] as? String)!]
        itemView.tag = index
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.3
        }
        return value
    }
}

