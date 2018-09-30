//
//  UICardView.swift
//  seowha
//
//  Created by Jinsoo Heo on 30/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

class UICardView: UIView {
    @IBOutlet weak var thumbnailView: UIImageView!
    var titleLabel: UILabel!
    var locationLabel: UILabel!
    var atLabel: UILabel!
    var typeLabel: UILabel!
    var tagsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInitialization()
    }
    
    func commonInitialization() {
        let view = Bundle.main.loadNibNamed("UICardView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = true;
        self.addSubview(view)
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.backgroundColor = .clear
        titleLabel.textAlignment = .left
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "NanumSquare", size: 17)
        titleLabel.sizeToFit()
        
        self.addSubview(titleLabel)
        
        titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        
        locationLabel = UILabel()
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.backgroundColor = .clear
        locationLabel.textAlignment = .left
        locationLabel.font = UIFont(name: "NanumSquare", size: 14)
        locationLabel.textColor = UIColor.gray
        
        self.addSubview(locationLabel)
        
        locationLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 30).isActive = true
        locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        locationLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 75).isActive = true
        
        atLabel = UILabel()
        atLabel.translatesAutoresizingMaskIntoConstraints = false
        atLabel.backgroundColor = .clear
        atLabel.textAlignment = .left
        atLabel.font = UIFont(name: "NanumSquare", size: 14)
        atLabel.textColor = UIColor.gray
        
        self.addSubview(atLabel)
        
        atLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 30).isActive = true
        atLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        atLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 95).isActive = true
        
        typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.backgroundColor = .clear
        typeLabel.textAlignment = .left
        typeLabel.font = UIFont(name: "NanumSquare", size: 13)
        
        self.addSubview(typeLabel)
        
        typeLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 30).isActive = true
        typeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        typeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 120).isActive = true
        
        tagsLabel = UILabel()
        tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        tagsLabel.backgroundColor = .clear
        tagsLabel.textAlignment = .left
        tagsLabel.font = UIFont(name: "NanumSquare", size: 14)
        tagsLabel.textColor = UIColor.gray
        
        self.addSubview(tagsLabel)
        
        tagsLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 30).isActive = true
        tagsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        tagsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 145).isActive = true
    }
    
    func setThumnail(_ link: String) {
        thumbnailView.downloaded(from: link)
    }
    
    func setThumnail(_ image: UIImage) {
        thumbnailView.image = image
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setLocation(_ location: String) {
        locationLabel.text = location
    }
    
    func setAt(_ at: String) {
        atLabel.text = at
    }
    
    func setType(_ type: String) {
        typeLabel.text = type
    }
    
    func setTags(_ tags: String) {
        tagsLabel.text = tags
    }
}
