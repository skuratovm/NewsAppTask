//
//  NewTableViewCell.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 3.02.22.
//

import UIKit

class NewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var newImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        newImageView.image = UIImage(named: "—Pngtree—vector newspaper icon_4869064")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
