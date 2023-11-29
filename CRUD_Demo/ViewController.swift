//
//  ViewController.swift
//  CRUD_Demo
//  Created by Vijay's Braintech on 06/11/23.
//

import UIKit
import CoreData


class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    //MARK: - Outlet's
    @IBOutlet var tableView: UITableView!
    @IBOutlet var buttonImage: UIButton!
    @IBOutlet var searchTextField: UITextField!
    
    @IBOutlet var SearchBarView: UIView!
    
    //MARK: - Properties
    var dataSource = [User]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.registerTableViewCells()
        buttonImage.isHidden = true
        SearchBarView.layer.borderWidth = 1
        searchTextField.delegate = self
        fetchData()
    }
    
    //MARK: - Helpers
    
    func showAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true)
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validate(YourEMailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: YourEMailAddress)
    }
    
    func validateFun(userID: String,name: String,email: String,password: String){
        if email == "" {
            showAlert(title: "Empty Field", message: "Please enter  email")
        } else if !self.validate(YourEMailAddress: email ){
            showAlert(title: "Empty Email", message: "Please enter valid email")
        } else if password == "" {
            showAlert(title: "Empty password", message: "Please enter password")
        } else if !self.isPasswordValid(password) {
            showAlert(title: "Invalid password", message: "Please enter Valid password")
        } else if userID == "" {
            showAlert(title: "Invalid userID", message: "Please enter userID")
        } else {
            let newUser = User(context: self.context)
            newUser.user_id = userID
            newUser.password = password
            newUser.name = name
            newUser.email = email
            do{
                try self.context.save()
            } catch {
                print("error in saving")
            }
            self.dataSaved()
            self.fetchData()
        }
    }
    
    func confirmDelete(index: Int){
        let alert = UIAlertController(title: nil, message:"Are you sure you want to delete this" , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let confirmAction = UIAlertAction(title: "Yes", style: .default){ _ in
            let user = self.dataSource[index]
            self.context.delete(user)
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchData()
        }
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)
        self.present(alert, animated: true)
    }
    
    func addtextField(alert: UIAlertController,placeholder: String){
        alert.addTextField(){ textField in
            textField.placeholder = placeholder
            textField.textAlignment = .center
        }
    }
    
    func dataSaved() {
        let alert = UIAlertController(title: "Alert", message:"Data is Saved" , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "ok", style: .cancel)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func showAlert() {
        let  vc = (self.storyboard?.instantiateViewController(withIdentifier: "AddUserViewController"))! as! AddUserViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        self.present(vc, animated: false)
        
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MyTableViewCell",bundle: nil)
        self.tableView.register(textFieldCell,forCellReuseIdentifier: "MyTableViewCell")
    }
    @objc func whichButtonPressed(sender: UIButton) {
        let buttonNumber = sender.tag
        print(buttonNumber)
        self.confirmDelete(index: buttonNumber)
        

    }
    
    
    
    //MARK: - Button Actions
    @IBAction func addUserAction(_ sender: Any) {
        showAlert()
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        print(searchTextField.text!)
        
        let fetchRequest: NSFetchRequest<User>
        fetchRequest = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "user_id LIKE %@", searchTextField.text!)
        do {
            let userArray = try context.fetch(fetchRequest)
            
            if !userArray.isEmpty {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
                
                for user in userArray {
                    nextVC.password = user.password
                    nextVC.name = user.name
                    nextVC.userID = user.user_id
                    nextVC.email = user.email
                    nextVC.image = UIImage(data: user.image ?? Data())
                }
                nextVC.context = self.context
                nextVC.tableView = self.tableView
                nextVC.updateButton?.isHidden = true
                self.navigationController?.pushViewController(nextVC, animated: false)
            }
            else {
                let alert = UIAlertController(title: nil, message: "User not found", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert,animated: true)
            }
        }
        catch {
            print("faild")
        }
    }
}

//MARK: - UITableViewDelegate,UITableViewDataSource

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell ?? nil)!
        
       // cell.cancelButton.addTarget(self, action: #selector(whichButtonPressed(sender:)), for: .touchUpInside)
       // cell.cancelButton.tag = indexPath.row
        let user = dataSource[indexPath.row]
        cell.nameLabel.text = user.email
        cell.useImageView.image = UIImage(data: user.image ?? Data())
        
        cell.didClickRemove = {
            self.confirmDelete(index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction  = UIContextualAction(style: .destructive, title: "Delete", handler: {_,_,_ in
//            self.confirmDelete(index: indexPath.row)
//        })
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "UserDetailsViewController") as! UserDetailsViewController
        let user = self.dataSource[indexPath.row]
        nextVC.user = user
        nextVC.password = user.password
        nextVC.name = user.name
        nextVC.userID = user.user_id
        nextVC.email = user.email
        nextVC.context = self.context
        nextVC.tableView = self.tableView
        nextVC.image = UIImage(data: user.image ?? Data())
        self.navigationController?.pushViewController(nextVC, animated: false)
    }
}

//MARK: - MyProtocol
extension ViewController: MyProtocol {
    
    func fetchData() {
        do{
            self.dataSource = try context.fetch(User.fetchRequest())
            tableView.reloadData()
        }
        catch{
            print("request fail")
        }
    }
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if text != "" {
            buttonImage.isHidden  = false
        } else {
            buttonImage.isHidden  = true
        }
        return true
    }
    
    
    
}
