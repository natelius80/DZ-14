//
//  ViewController.swift
//  DZ 14
//
//  Created by Питонейшество on 18/11/2019.
//  Copyright © 2019 Питонейшество. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        surnameTextField.delegate = self
        
        nameTextField.text = Persistance.shared.userName
        
        surnameTextField.text = Persistance.shared.userSurname
        
        //nameTextField.text = UserDefaults.standard.value(forKey: "name") as? String
    }
}
extension ViewController: UITextFieldDelegate {
  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == nameTextField {
//            textField.resignFirstResponder()
//            Persistance.shared.userName = nameTextField.text
//            surnameTextField.becomeFirstResponder()
//        }
//        else {
//            surnameTextField.resignFirstResponder()
//            Persistance.shared.userSurname = surnameTextField.text
//        }
        if textField == nameTextField {
            textField.resignFirstResponder()
            Persistance.shared.userName = nameTextField.text
        }
        else {
            textField.resignFirstResponder()
            Persistance.shared.userSurname = surnameTextField.text
        }
        
        //UserDefaults.standard.set(nameTextField.text, forKey: "name")
        //print(Persistance.shared.userName as Any)
        //print(Persistance.shared.userSurname as Any)

        return true
    }
}

