//
//  ActivityViewController.swift
//  seowha
//
//  Created by Jinsoo Heo on 30/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityImageView: UIImageView!
    var activity: [String : Any]!
    
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

        self.navigationItem.title = "서화"
        
        activityImageView.contentMode = .scaleAspectFill
        activityImageView.clipsToBounds = true
        
        if activity["image_url"] is NSNull {
            activityImageView.image = UIImage(named: "launch.jpg")
        } else {
            activityImageView.downloaded(from: activity["image_url"] as! String, contentMode: .scaleAspectFill)
        }
        
        
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.backgroundColor = .clear
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont(name: "NanumSquare", size: 20)
        nameLabel.text = activity["name"] as? String
        
        scrollView.addSubview(nameLabel)
        
        nameLabel.centerXAnchor.constraint(equalTo: activityImageView.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: activityImageView.bottomAnchor, constant: 55).isActive = true
        
        let typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.backgroundColor = .clear
        typeLabel.textAlignment = .center
        typeLabel.font = UIFont(name: "NanumSquare", size: 14)
        typeLabel.text = typeDictionary[activity["type"] as! String]
        
        scrollView.addSubview(typeLabel)
        
        typeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        typeLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        
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
        
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.backgroundColor = .clear
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "NanumSquare", size: 17)
        dateLabel.text = start_at + " - " + end_at
        
        scrollView.addSubview(dateLabel)
        
        dateLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 30).isActive = true
        
        let locationTitleLabel = UILabel()
        locationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitleLabel.backgroundColor = .clear
        locationTitleLabel.textAlignment = .center
        locationTitleLabel.font = UIFont(name: "NanumSquare", size: 15)
        locationTitleLabel.text = "장소"
        locationTitleLabel.textColor = .gray
        
        scrollView.addSubview(locationTitleLabel)
        
        locationTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        locationTitleLabel.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 30).isActive = true
        
        let locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.backgroundColor = .clear
        locationLabel.textAlignment = .left
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.numberOfLines = 0
        locationLabel.font = UIFont(name: "NanumSquare", size: 17)
        locationLabel.text = activity["location"] as? String
        locationLabel.sizeToFit()
        
        scrollView.addSubview(locationLabel)
        
        locationLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        locationLabel.topAnchor.constraint(equalTo: locationTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        var tags: String = ""

        for with in activity["with"] as? [String] ?? [] {
            tags += "#" + with + " "
        }
        
        for with in activity["properties"] as? [String] ?? [] {
            tags += "#" + with + " "
        }

        let tagsLabel = UILabel()
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.backgroundColor = .clear
        tagsLabel.textAlignment = .left
        tagsLabel.lineBreakMode = .byWordWrapping
        tagsLabel.numberOfLines = 0
        tagsLabel.font = UIFont(name: "NanumSquare", size: 15)
        tagsLabel.text = tags
        tagsLabel.textColor = UIColor(rgb: 0xEF706A)
        tagsLabel.sizeToFit()

        scrollView.addSubview(tagsLabel)

        tagsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 13).isActive = true
        
        let useTimeInfoTitleLabel = UILabel()
        useTimeInfoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        useTimeInfoTitleLabel.backgroundColor = .clear
        useTimeInfoTitleLabel.textAlignment = .center
        useTimeInfoTitleLabel.font = UIFont(name: "NanumSquare", size: 15)
        useTimeInfoTitleLabel.text = "이용시간 정보 ⌄"
        useTimeInfoTitleLabel.textColor = UIColor(rgb: 0xEF706A)
        
        scrollView.addSubview(useTimeInfoTitleLabel)
        
        useTimeInfoTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        useTimeInfoTitleLabel.topAnchor.constraint(equalTo: tagsLabel.bottomAnchor, constant: 20).isActive = true
        
        let useTimeLabel = UILabel()
        useTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        useTimeLabel.backgroundColor = .clear
        useTimeLabel.textAlignment = .left
        useTimeLabel.lineBreakMode = .byWordWrapping
        useTimeLabel.numberOfLines = 0
        useTimeLabel.font = UIFont(name: "NanumSquare", size: 17)
        useTimeLabel.text = activity["use_time_info"] as? String
        useTimeLabel.sizeToFit()
        
        scrollView.addSubview(useTimeLabel)
        
        useTimeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        useTimeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        useTimeLabel.topAnchor.constraint(equalTo: useTimeInfoTitleLabel.bottomAnchor, constant: 5).isActive = true
        
        let priceTitleLabel = UILabel()
        priceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceTitleLabel.backgroundColor = .clear
        priceTitleLabel.textAlignment = .center
        priceTitleLabel.font = UIFont(name: "NanumSquare", size: 15)
        priceTitleLabel.text = "가격 정보 ⌄"
        priceTitleLabel.textColor = UIColor(rgb: 0xEF706A)
        
        scrollView.addSubview(priceTitleLabel)
        
        priceTitleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        priceTitleLabel.topAnchor.constraint(equalTo: useTimeLabel.bottomAnchor, constant: 10).isActive = true
        
        let priceLabel = UILabel()
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.backgroundColor = .clear
        priceLabel.textAlignment = .left
        priceLabel.lineBreakMode = .byWordWrapping
        priceLabel.numberOfLines = 0
        priceLabel.font = UIFont(name: "NanumSquare", size: 17)
        priceLabel.text = activity["price"] as? String
        priceLabel.sizeToFit()
        
        scrollView.addSubview(priceLabel)
        
        priceLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 50).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -50).isActive = true
        priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 5).isActive = true
    }
}
