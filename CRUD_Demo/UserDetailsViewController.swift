//
//  UserDetailsViewController.swift
//  CRUD_Demo
//
//  Created by Vijay's Braintech on 06/11/23.
//

import UIKit
import CoreData

class UserDetailsViewController: UIViewController {
    
    //MARK: - Outlet's
    @IBOutlet var passwordTextField: UITextField?
    @IBOutlet var emailTextField: UITextField?
    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var userIdTextField: UITextField?
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var userImage: UIImageView!
    //MARK: - Properties
    var name: String!
    var email: String!
    var password: String!
    var userID: String!
    var context: NSManagedObjectContext!
    var tableView: UITableView!
    var user: User?
    var image: UIImage!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField?.text = password
        emailTextField?.text = email
        userIdTextField?.text = userID
        nameTextField?.text = name
        userImage.image = image
        updateButton.layer.cornerRadius = 5
        updateButton.layer.borderWidth = 0.5
        userImage.layer.cornerRadius = 5
        userImage.layer.borderWidth = 0.5
        
    }
    //MARK: - Button Actions
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func UpdateButton(_ sender: Any) {
        user?.name = nameTextField?.text
        user?.password = passwordTextField?.text
        user?.email = emailTextField?.text
        user?.user_id = userIdTextField?.text
        
        let alert = UIAlertController(title: "Record Updated", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel){_ in
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(action)
        self.present(alert, animated: true)
        tableView.reloadData()
    }
}
