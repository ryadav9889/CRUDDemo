//  MyTableViewCell.swift
//  CRUD_Demo
//  Created by Vijay's Braintech on 07/11/23.

import UIKit

class MyTableViewCell: UITableViewCell, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    //MARK: - Outlet's
    @IBOutlet var containerView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var useImageView: UIImageView!
    @IBOutlet var cancelButton: UIButton!
    
    var didClickRemove: (() -> Void)?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        configureUI()
    }
    
    func configureUI() {
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth =  1
        containerView.layer.borderColor = UIColor.gray.cgColor
        useImageView.layer.cornerRadius = 8
        useImageView.clipsToBounds = true
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func minusButtonAction(_ sender: Any) {
        didClickRemove?()
    }
    
    
    
}
