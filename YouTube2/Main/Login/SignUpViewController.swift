//
//  SignUpViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 21.01.2024.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    lazy var uploadPhotoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Телефон, имя пользователя или эл. адрес"
        textField.backgroundColor = .lightGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.backgroundColor = .lightGray
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passRepeatTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Повторите пароль"
        textField.backgroundColor = .lightGray
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red.withAlphaComponent(0.5)
        //        button.isEnabled = false
        button.setTitle("Регистрация", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        setupSignals()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tap)
    
    }

    
    func setupLayouts() {
        view.backgroundColor = .black
        view.addSubview(uploadPhotoButton)
        uploadPhotoButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(50)
            make.centerX.equalToSuperview()
            make.size.equalTo(140)
        }
        
        view.addSubview(loginTextField)
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(uploadPhotoButton.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
        
        view.addSubview(passTextField)
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
        
        view.addSubview(passRepeatTextField)
        passRepeatTextField.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(passRepeatTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(50)
        }
        
    }
    
    func setupSignals() {
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoPressed), for: .touchUpInside)
        loginTextField.addTarget(self, action: #selector(handleLoginEditing), for: .allEditingEvents)
        signUpButton.addTarget(self, action: #selector(handleRegisterPressed), for: .touchUpInside)
    }
    
    @objc func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func uploadPhotoPressed() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true)
    }
    
    @objc func handleLoginEditing(_ textField: UITextField) {
        print("logintext :\(textField.text)")
    }
    
    @objc func handleRegisterPressed() {
        guard
            let login = loginTextField.text, login.count > 0,
            let pass1 = passTextField.text, pass1.count > 0,
            let pass2 = passRepeatTextField.text, pass2.count > 0
        else { return }
        
        if pass1 == pass2 {
            Auth.auth().createUser(withEmail: login, password: pass1) { res, err in
                if let err = err {
                    print("auth err :\(err)")
                    return
                }
                
                if let res = res {
                    print("result: \(res)")
                    
                    if let uploadImageData = self.uploadPhotoButton.imageView?.image?.jpegData(compressionQuality: 0.3) {
                        let filename = NSUUID().uuidString
                        
                        Storage.storage().reference().child("profile_images").child(filename)
                            .putData(uploadImageData, metadata: nil) { metadata, err in
                                if let err = err {
                                    print("error upload profile image \(err)")
                                    return
                                }
                                
                                Storage.storage().reference().child("profile_images").child(filename).downloadURL { url, err in
                                    if let err = err {
                                        print("err downloadURL: \(err)" )
                                        return
                                    }
                                    
                                    let profileImageUrl = url!.absoluteString
                                    let uid = res.user.uid
                                    
                                    let dictionaryValues = ["username": login, "profileImageUrl": profileImageUrl] as [String: Any]
                                    let values = [uid: dictionaryValues]
                                    
                                    Database.database().reference().child("users").updateChildValues(values) { err, ref in
                                        if let err = err {
                                            print("Failed to save user info in db:", err)
                                            return
                                        }
                                        print("Succesfully saved user info to db")
                                        self.dismiss(animated: true)
                                        
                                    }
                                    
                                }
                            }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
            extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
                func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                    print("imageInfo \(info)")
                    
                    if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                        uploadPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
                    } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                        uploadPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
                    }
                    
                    uploadPhotoButton.layer.cornerRadius = uploadPhotoButton.frame.width / 2
                    uploadPhotoButton.layer.masksToBounds = true
                    uploadPhotoButton.layer.borderColor = UIColor.red.cgColor
                    uploadPhotoButton.layer.borderWidth = 3
                    
                    dismiss(animated: true)
                }
            }
