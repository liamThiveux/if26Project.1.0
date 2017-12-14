//
//  AddRecetteViewController.swift
//  if26Project
//
//  Created by if26-grp2 on 30/11/2017.
//  Copyright © 2017 if26-grp2. All rights reserved.
//

import UIKit

class AddRecetteViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titreRe  cette: UITextField!
    @IBOutlet weak var ingredient1: UITextField!
    @IBOutlet weak var ingredient2: UITextField!
    @IBOutlet weak var ingredient3: UITextField!
    @IBOutlet weak var ingredient4: UITextField!
    @IBOutlet weak var ingredient5: UITextField!
    @IBOutlet weak var ingredient6: UITextField!
    @IBOutlet weak var ingredient7: UITextField!
    @IBOutlet weak var etapes: UITextView!
    @IBOutlet weak var buttonAddPhoto: UIButton!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    let imageView2 : UIImageView! = nil
    let picker = UIImagePickerController()
    @IBAction func buttonAddPhoto(_ sender: UIButton) {
            
        if UIImagePickerController.availableMediaTypes(for: .photoLibrary) != nil {
                picker.allowsEditing = false
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(picker, animated: true, completion: nil)
            } else {
                noCamera()
            }
        }
    
        func noCamera(){
            let alertVC = UIAlertController(title: "No Camera", message: "Sorry, Gallery is not accessible.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
            alertVC.addAction(okAction)
            present(alertVC, animated: true, completion: nil)
        }


//MARK: - Delegates
//What to do when the picker returns with a photo
/*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    var chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
    photoUser.contentMode = .scaleAspectFit //3
    dismiss(animated: true, completion: nil) //5
}*/
//What to do if the image picker cancels.
func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
}
    
    @IBAction func addDB(_ sender: UIButton) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self   //the required delegate to get a photo back to the app.

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
