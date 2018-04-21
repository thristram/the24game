//
//  StatisticsCollectionViewCell.swift
//  the 24 Game
//
//  Created by Fangchen Li on 4/21/18.
//  Copyright © 2018 Fangchen Li. All rights reserved.
//

import UIKit

class StatisticsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemView: UIView!
    @IBOutlet weak var itemBottomBGView: UIView!
    @IBOutlet weak var itemIconView: UIImageView!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var winnerIndicator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.itemView.layer.cornerRadius = 8
        self.itemView.clipsToBounds = true
        // Initialization code
    }
    func setTitle(title: String){
        self.itemIconView.isHidden = true
        self.itemTitle.isHidden = false
        self.itemTitle.text = title
    }
    func setIcon(icon: UIImage){
        self.itemIconView.isHidden = false
        self.itemTitle.isHidden = true
        self.itemIconView.image = icon
    }
    func setTeam(number: Int){
        self.itemBottomBGView.backgroundColor = UIColor.clear
        self.itemView.backgroundColor = UIColor.mineLoverLightBlack
        switch(number){
        case 1:
            self.winnerIndicator.backgroundColor = UIColor.TFRed
//            self.itemView.backgroundColor = UIColor.TFRed
//            self.itemBottomBGView.backgroundColor = UIColor.TFBlackHover
            break
        case 2:
            self.winnerIndicator.backgroundColor = UIColor.black
//            self.itemView.backgroundColor = UIColor.TFLightBlack
//            self.itemBottomBGView.backgroundColor = UIColor.black
            
            break
        case 3:
            self.winnerIndicator.backgroundColor = UIColor.seraphOrange
//            self.itemView.backgroundColor = UIColor.seraphOrange
//            self.itemBottomBGView.backgroundColor = UIColor.TFBlackHover
            
            break
        case 4:
            self.winnerIndicator.backgroundColor = UIColor.seraphDarkBlue
//            self.itemView.backgroundColor = UIColor.seraphDarkBlue
//            self.itemBottomBGView.backgroundColor = UIColor.TFBlackHover
        
            break
        default:
            self.winnerIndicator.backgroundColor = UIColor.clear
            break
        }
    
    }

}
