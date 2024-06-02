//
//  LoginViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 14.01.2024.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Instagram"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Телефон, имя пользователя и эл. адрес "
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
    
    lazy var signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Войти", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
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
    
    func setupSignals() {
        signInButton.addTarget(self, action: #selector(didSignInPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didSignUpPressed), for: .touchUpInside)
    }
    
    @objc func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func didSignInPressed() {
        guard
            let login = loginTextField.text, login.count > 0,
            let pass = passTextField.text, pass.count > 0
        else { return }
        
        Auth.auth().signIn(withEmail: login, password: pass) { res, err in
            if let err = err {
                print("err in Auth \(err)")
                return
            }
            
            self.dismiss(animated: true)
        }
    }
    
    @objc func didSignUpPressed() {
        let vc = SignUpViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupLayouts() {
        
        view.backgroundColor = .black
        view.addSubview(logoLabel)
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin).offset(50)
            make.left.right.equalToSuperview().inset(50)
        }
        
        view.addSubview(loginTextField)
        loginTextField.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        view.addSubview(passTextField)
        passTextField.snp.makeConstraints { make in
            make.top.equalTo(loginTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(45)
        }
        
        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passTextField.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
    }
    

