//
//  ViewController.swift
//  Instagrid
//
//  Created by TomF on 21/06/2021.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    // MARK: Enums and variables
    
    enum layoutChoices {
        case firstLayout, secondLayout, thirdLayout
    }
    
    private var squareSelected = UIButton()
    private var selectedLayoutImage = UIImage(named: "Selected")
    
    // MARK: IBOutlets
    // - Swipe Label
    @IBOutlet weak var swipeLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    // - Grid View
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var gridTopLeft: UIButton!
    @IBOutlet weak var gridTopRight: UIButton!
    @IBOutlet weak var rectangleTop: UIButton!
    @IBOutlet weak var gridBottomLeft: UIButton!
    @IBOutlet weak var gridBottomRight: UIButton!
    @IBOutlet weak var rectangleBottom: UIButton!
    @IBOutlet var allImagePickers: [UIButton]!
    
    // - Layout buttons
    @IBOutlet weak var firstLayoutButton: UIButton!
    @IBOutlet weak var secondLayoutButton: UIButton!
    @IBOutlet weak var thirdLayoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLayout1((Any).self)
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
        clearGridView()
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
        clearGridView()
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
        clearGridView()
    }
    
    @IBAction func selectedSquare(_ sender: UIButton) {
        squareSelected = sender
        checkLibraryPermission()
        print(sender.tag)
    }
    
    @IBAction func swipeForShareGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up where UIDevice.current.orientation.isLandscape == false :
            self.shareAnimation(x: 0, y: -700)
            showShareSheet()
        case .left where UIDevice.current.orientation.isLandscape == true :
            self.shareAnimation(x: -700, y: 0)
            showShareSheet()
        default :
            print("wrong direction")
            break
        }
    }
    
    // MARK: Functions
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.swipeLabel.text = "Swipe left to share"
            self.arrowImage.image = UIImage(named: "Arrow Left")
        } else {
            self.swipeLabel.text = "Swipe up to share"
            self.arrowImage.image = UIImage(named: "Arrow Up")
        }
    }
    
    func checkLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized, .limited:
                DispatchQueue.main.async {
                    let imagePickerController = UIImagePickerController()
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                        imagePickerController.sourceType = .photoLibrary
                    }
                    imagePickerController.delegate = self
                
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            case .restricted, .denied:
                DispatchQueue.main.async {
                    self.presentAlert(viewController: self, title: "Access Denied", message: "")
                }
            case .notDetermined:
                break
            default:
                break
            }
        }
        
    }
    
    private func viewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }
    
    private func shareAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.75, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    private func showShareSheet() {
        let items = viewToImage(view: gridView)
        let ac = UIActivityViewController(activityItems: [items as Any], applicationActivities: [])
        ac.completionWithItemsHandler = {
            (activityType, completed, _, error) in
            if completed {
                self.shareAnimation(x: 0, y: 0)
            } else {
                self.shareAnimation(x: 0, y: 0)
            }
        }
        present(ac, animated: true)
    }
    
    private func clearGridView() {
        for picker in allImagePickers {
            picker.setImage(UIImage(named: "Plus"), for: .normal)
        }
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
    
    func presentAlert(viewController: UIViewController, title: String, message: String) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
          
          // add an action (button)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
          
          // show the alert
            viewController.present(alert, animated: true, completion: nil)
        }
}
