//
//  AddUserViewController.swift
//  CRUD_Demo
//
//  Created by Sazid Saifi on 08/11/23.
//

import UIKit


//MARK: - Outlet's
protocol MyProtocol {
   func fetchData()
}

class AddUserViewController: UIViewController {
    
    //MARK: - Outlet's
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var paswordView: UIView!
    @IBOutlet var emailView: UIView!
    @IBOutlet var userIDView: UIView!
    @IBOutlet var saveButton: UIButton!
//  @IBOutlet var cancelButton: UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var userIdTextField: UITextField!
    
    //MARK: - Properties
     
    
    var delegate: MyProtocol!
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUi()
        
    }
    
    //MARK: - Helpers
    func setUpUi(){
        containerView.layer.cornerRadius = 8.0
        containerView.layer.borderWidth = 0.5
        imageView.layer.cornerRadius = imageView.frame.width/2
        nameView.layer.cornerRadius = 8.0
        nameView.layer.borderWidth = 0.5
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 8.0
//        cancelButton.layer.borderWidth = 0.5
//        cancelButton.layer.cornerRadius = 8.0
        paswordView.layer.borderWidth = 0.5
        emailView.layer.cornerRadius = 8.0
        emailView.layer.borderWidth = 0.5
        paswordView.layer.cornerRadius = 8.0
        userIDView.layer.borderWidth = 0.5
        userIDView.layer.cornerRadius = 8.0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 0.5
    }
    @objc private func handleTapGesture() {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true)
    }
    
    //MARK: - Button Actions
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let user = User(context: context)
        
        if emailTextField.text == "" {
            showAlert(title: "Empty Field", message: "Please enter  email")
        } else if nameTextField.text == "" {
            showAlert(title: "Empty name Field", message: "Please enter password")
        } else if passwordTextField.text == "" {
            showAlert(title: "Empty password Field", message: "Please enter password")
        } else if userIdTextField.text == "" {
            showAlert(title: "Empty userId Field", message: "Please enter password")
        } else if imageView.image == nil {
            showAlert(title: "Empty image view", message: "Please enter password")
        } else {
            user.email = emailTextField.text
            user.name = nameTextField.text
            user.password = passwordTextField.text
            user.user_id = userIdTextField.text
            user.image = UIImage.pngData(imageView.image!)()
        }
        do {
            try context.save()
        }
        catch {
            
        }
        delegate.fetchData()
        self.dismiss(animated: true)
        
    }
}

extension AddUserViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
   
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imageView.image = info[.editedImage] as? UIImage
        picker.dismiss(animated: false)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
            picker.dismiss(animated: false)
        }
    

    
    
}
