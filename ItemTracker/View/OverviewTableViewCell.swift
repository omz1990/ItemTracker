//
//  OverviewTableViewCell.swift
//  ItemTracker
//
//  Created by Omar Mujtaba on 5/5/20.
//  Copyright © 2020 AmmoLogic Training. All rights reserved.
//

import UIKit

class OverviewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var line1Label: UILabel!
    @IBOutlet weak var line2Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCell(heading: String?, line1Title: String?, line1Body: String?, line2Title: String?, line2Body: String?, image: UIImage?) {
        headingLabel.text = heading
        line1Label.attributedText = aggregateTitleAndBody(title: line1Title, body: line1Body)
        line2Label.attributedText = aggregateTitleAndBody(title: line2Title, body: line2Body)
        if let image = image {
            itemImageView?.image = image
        }
    }
    
    private func aggregateTitleAndBody(title: String?, body: String?) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        if let title = title {
            let boldAttributes: [NSAttributedString.Key : Any] = [
                .font : UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor : UIColor.systemGray,

            ]
            let titleString = NSMutableAttributedString(string: "\(title): ", attributes: boldAttributes)
            attributedString.append(titleString)
        }
        
        if let body = body {
            let normalAttributes: [NSAttributedString.Key : Any] = [
                .font : UIFont.systemFont(ofSize: 13),
                .foregroundColor : UIColor.systemGray,

            ]
            let bodyString = NSMutableAttributedString(string: body, attributes: normalAttributes)
            attributedString.append(bodyString)
        }
        
        return attributedString
    }
    
}
