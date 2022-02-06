//
//  NewsTableViewCell.swift
//  NewsTask
//
//  Created by Mikhail Skuratov on 4.02.22.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var newsImageView: UIImageView!{
        didSet{
            newsImageView.layer.cornerRadius = 10
            newsImageView.layer.masksToBounds = true
            
            newsImageView.clipsToBounds = true
            newsImageView.contentMode = .scaleAspectFill
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let readmoreFont = UIFont(name: "Helvetica-Oblique", size: 15.0)
        let readmoreFontColor = UIColor.systemBlue
        if descriptionLabel.vissibleTextLength > 70{
            DispatchQueue.main.async {
                self.descriptionLabel.addTrailing(with: "... ", moreText: "Show more", moreTextFont: readmoreFont!, moreTextColor: readmoreFontColor)
            }
        }
    }
    
    
    func configure(with viewModel: NewsTableViewCellViewModel){
        //Configure all the data here
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.subtitle
        //Image
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL{
            //Fetch image
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                if error != nil{
                    DispatchQueue.main.async {
                        self?.newsImageView.image = UIImage(named: "—Pngtree—vector newspaper icon_4869064")
                    }
                }
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
    
    
}
