//
//  CatFactCell.swift
//  CatFacts
//
//  Created by Gonçalo Almeida on 13/03/2025.
//

import UIKit

class CatFactCell: UITableViewCell {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var verifiedImageView: UIImageView!
    @IBOutlet weak var newImageView: UIImageView!
    
    @IBOutlet weak var imagesHStackView: UIStackView!
    
    static let identifier = "CatFactCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CatFactCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configure(_ viewModel: CatFactCellViewModel) {
        descriptionLabel.text = viewModel.factDescription
        verifiedImageView.image = viewModel.isVerified ? UIImage(named: "verified") : nil
        newImageView.image = viewModel.isNew ? UIImage(named: "new") : nil
        
        imagesHStackView.isHidden = !(viewModel.isVerified || viewModel.isNew)
    }
}
