//
//  AddPostViewController.swift
//  YouTube2
//
//  Created by Smart Castle M1A2009 on 18.02.2024.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AddPostViewController: UIViewController {
    
    lazy var selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .red
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: .normal)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadImage), name: Notification.Name(rawValue: "captureNewPhoto"), object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayouts()
        uploadButton.addTarget(self, action: #selector(handleUploadDidTap), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleUploadImage(_ notification: Notification) {
        if let image = notification.object as? UIImage {
            selectedImageView.image = image
            self.fromCamera = true
        }
    }
    
    @objc func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func handleUploadDidTap() {
        guard let caption = commentTextView.text, caption.count > 0 else { return }
        guard let image = selectedImageView.image else { return }
        
        guard let uploadData = image.jpegData(compressionQuality: 0.3) else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("posts").child(filename).putData(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print("failed to upload post image", err)
                return
            }
            print("Successfully upload post image")
            
            Storage.storage().reference().child("posts").child(filename).downloadURL { url, error in
                if let error = error {
                    print("Failed to downloadURL", error)
                } else {
                    print("Successfully downloadURL",url!)
                    let postImageUrl = url!.absoluteString
                    self.saveToDatabaseWithImageUrl(imageUrl: postImageUrl)
                }}
        }
    }
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
    
    private func saveToDatabaseWithImageUrl(imageUrl: String) {
        guard let caption = commentTextView.text, caption.count > 0 else { return }
        guard let image = selectedImageView.image else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        let randomId = UUID().uuidString
        let ref = userPostRef.child(randomId)
        
        let values = ["imageUrl": imageUrl,
                      "caption": caption,
                      "imageWidth": image.size.width,
                      "imageHeight": image.size.height,
                      "creationDate": Date().timeIntervalSince1970,
                      "id": randomId] as [String: Any]
        
        ref.updateChildValues(values) { (err, ref) in
            if let err = err {
                print("Failed to save post to db",err)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("successfully saved post to db")
            self.dismiss(animated: true, completion: nil)
            self.tabBarController?.selectedIndex = 4
            NotificationCenter.default.post(name: AddPostViewController.updateFeedNotificationName, object: nil)
        }
    }
    
    var fromCamera = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !fromCamera {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func setupLayouts() {
        view.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.snp.width)
        }
        
        view.addSubview(commentTextView)
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(selectedImageView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(50)
        }
    }
    
}

extension AddPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.selectedImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.selectedImageView.image = originalImage
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
