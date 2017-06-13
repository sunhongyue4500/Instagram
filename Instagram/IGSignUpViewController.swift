//
//  IGSignUpViewController.swift
//  Instagram
//
//  Created by Sunhy on 2017/6/11.
//  Copyright © 2017年 Sunhy. All rights reserved.
//

import Foundation

class IGSignUpViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBOutlet weak var repeatPasswordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var fullNameTxt: UITextField!
    @IBOutlet weak var bioTxt: UITextField!
    @IBOutlet weak var webTxt: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var cancelBtrn: UIButton!
    
    var scrollViewHeight : CGFloat = 0
    var keyboard: CGRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        scrollView.contentSize.height = self.view.frame.height;
        scrollViewHeight = self.view.frame.height
        
        // 设置头像为原型
        self.avaImage.layer.cornerRadius = self.avaImage.frame.width / 2
        avaImage.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyBoard(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // 添加单击手势
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGesture)
        
        // 头像添加单击手势
        let avagImageViewTagGes = UITapGestureRecognizer(target: self, action: #selector(avagImageViewTapAction(sender:)))
        avagImageViewTagGes.numberOfTapsRequired = 1
        self.avaImage.isUserInteractionEnabled = true
        self.avaImage.addGestureRecognizer(avagImageViewTagGes)
        
    }
    
    // MARK: - Btn Action
    @IBAction func signUpBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.userNameTxt.text!.isEmpty || self.passwordTxt.text!.isEmpty || self.repeatPasswordTxt.text!.isEmpty || self.emailTxt.text!.isEmpty || self.fullNameTxt.text!.isEmpty || self.bioTxt.text!.isEmpty || self.webTxt.text!.isEmpty {
            let alertController = UIAlertController(title: "提示", message: "所有不能为空", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if passwordTxt.text != repeatPasswordTxt.text {
            let alertController = UIAlertController(title: "提示", message: "两次密码不一致", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        let user = AVUser()
        user.username = userNameTxt.text?.lowercased()
        user.email = emailTxt.text?.lowercased()
        user.password = passwordTxt.text
        
        user["fullName"] = fullNameTxt.text?.lowercased()
        user["bio"] = bioTxt.text?.lowercased()
        user["web"] = webTxt.text?.lowercased()
        user["gender"] = ""
        let avaData = UIImageJPEGRepresentation(avaImage.image!, 0.5)
        let avaFile = AVFile(name: "ava.jpg", data: avaData)
        user["ava"] = avaFile
        
        user.signUpInBackground { (success:Bool, error:Error?) in
            if success {
                print("用户注册成功")
            } else {
                print("用户注册失败")
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    // MARK: - Gesture Action
    @IBAction func cancelAction(_ sender: UIButton) {
    }

    func avagImageViewTapAction(sender: UITapGestureRecognizer) {
        // 创建照片获取器
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .photoLibrary
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        present(photoPicker, animated: true, completion: nil)
    }
    
    func tapGestureAction(gesture: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Notification Action
    func showKeyBoard(notification: Notification) {
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.frame.size.height = self.view.frame.size.height - self.keyboard.size.height
        }
    }
    
    func hideKeyBoard(notification: Notification) {
        UIView.animate(withDuration: 0.4) { 
            self.scrollView.frame.size.height = self.view.frame.size.height
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate  Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avaImage.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
