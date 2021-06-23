//
//  ViewController.swift
//  Instagrid
//
//  Created by TomF on 21/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: Enums and variables
    
    enum layoutChoices {
        case firstLayout, secondLayout, thirdLayout
    }
    
    var squareSelected = UIButton()
    var selectedLayoutImage = UIImage(named: "Selected")
    
    // MARK: IBOutlets
    // - Swipe Label
    @IBOutlet weak var swipeLabel: UILabel!
    
    // - Grid View
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var gridTopLeft: UIButton!
    @IBOutlet weak var gridTopRight: UIButton!
    @IBOutlet weak var rectangleTop: UIButton!
    @IBOutlet weak var gridBottomLeft: UIButton!
    @IBOutlet weak var gridBottomRight: UIButton!
    @IBOutlet weak var rectangleBottom: UIButton!
    
    // - Layout buttons
    @IBOutlet weak var firstLayoutButton: UIButton!
    @IBOutlet weak var secondLayoutButton: UIButton!
    @IBOutlet weak var thirdLayoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - IBAction
    @IBAction func selectLayout1(_ sender: Any) {
        gridTopLeft.isHidden = true
        gridTopRight.isHidden = true
        rectangleTop.isHidden = false
        gridBottomLeft.isHidden = false
        gridBottomRight.isHidden = false
        rectangleBottom.isHidden = true
        firstLayoutButton.isSelected = true
        secondLayoutButton.isSelected = false
        thirdLayoutButton.isSelected = false
        firstLayoutButton.setImage(selectedLayoutImage, for: .selected)
    }
    
    @IBAction func selectLayout2(_ sender: Any) {
        gridTopLeft.isHidden = false
        gridTopRight.isHidden = false
        rectangleTop.isHidden = true
        gridBottomLeft.isHidden = true
        gridBottomRight.isHidden = true
        rectangleBottom.isHidden = false
        firstLayoutButton.isSelected = false
        secondLayoutButton.isSelected = true
        thirdLayoutButton.isSelected = false
        secondLayoutButton.setImage(selectedLayoutImage, for: .selected)
    }
    
    @IBAction func selectLayout3(_ sender: Any) {
        gridTopLeft.isHidden = false
        gridTopRight.isHidden = false
        rectangleTop.isHidden = true
        gridBottomLeft.isHidden = false
        gridBottomRight.isHidden = false
        rectangleBottom.isHidden = true
        firstLayoutButton.isSelected = false
        secondLayoutButton.isSelected = false
        thirdLayoutButton.isSelected = true
        thirdLayoutButton.setImage(selectedLayoutImage, for: .selected)
    }
    
    @IBAction func selectedSquare(_ sender: UIButton) {
//        squareSelected = sender
//        selectPictureInLibrary()
//        print(sender.tag)
    }
    
}

// MARK: Extensions
// - Extensions and methods for ImagePickerController
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            squareSelected.imageView?.contentMode = .scaleAspectFill
            squareSelected.clipsToBounds = false
            squareSelected.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
