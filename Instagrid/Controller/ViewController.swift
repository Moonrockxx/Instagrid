//
//  ViewController.swift
//  Instagrid
//
//  Created by TomF on 21/06/2021.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    // MARK: Variables
    
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
    
    // - selectLayout1 is called by default for display the fist layout button selected
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLayout1((Any).self)
    }
    
    // MARK: - IBAction
    
    // - Update view when the first layout button is touched
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
    
    // - Update view when the second layout button is touched
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
    
    // - Update view when the third layout button is touched
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
    
    // - Allows to know which picker is touched
    @IBAction func selectedSquare(_ sender: UIButton) {
        squareSelected = sender
        checkLibraryPermission()
    }
    
    // - Handle swipe gestures for display the Share Sheet on depend to the device orientation
    @IBAction func swipeForShareGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up where UIDevice.current.orientation.isLandscape == false :
            self.shareAnimation(x: 0, y: -700)
            showShareSheet()
        case .left where UIDevice.current.orientation.isLandscape == true :
            self.shareAnimation(x: -700, y: 0)
            showShareSheet()
        default :
            break
        }
    }
    
    // MARK: Functions
    
    // - Update view on depend to the orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            self.swipeLabel.text = "Swipe left to share"
            self.arrowImage.image = UIImage(named: "Arrow Left")
        } else {
            self.swipeLabel.text = "Swipe up to share"
            self.arrowImage.image = UIImage(named: "Arrow Up")
        }
    }
    
    // - Permission treatment for library access, if status is authorized or limited we can display the image picker, if the status is restricted or denied we display a custom alert modal
    private func checkLibraryPermission() {
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
                    self.presentAlert(viewController: self, title: "Access Denied", message: "Go to the settings to allow the application to access the library")
                }
            case .notDetermined:
                break
            default:
                break
            }
        }
    }
    
    // - Transform the Grid View to an UIImage
    private func viewToImage(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImage(cgImage: image!.cgImage!)
    }
    
    // - Animation to make the grid view disappear/appear
    private func shareAnimation(x: CGFloat, y: CGFloat) {
        UIView.animate(withDuration: 0.75, animations: {
            self.gridView.transform = CGAffineTransform(translationX: x, y: y)
        })
    }
    
    // - Treatment to show the share sheet with the image view to share
    private func showShareSheet() {
        let items = viewToImage(view: gridView)
        let activityController = UIActivityViewController(activityItems: [items as Any], applicationActivities: [])
        activityController.completionWithItemsHandler = {
            (activityType, completed, _, error) in
            self.shareAnimation(x: 0, y: 0)
        }
        present(activityController, animated: true)
    }
    
    // - Remove all images from the grid
    private func clearGridView() {
        for picker in allImagePickers {
            picker.setImage(UIImage(named: "Plus"), for: .normal)
        }
    }
}


// MARK: Extensions
// - Indicate that the ViewController class supports all the functionality required by the two protocols
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // - Allows to select an image on the library and make a treatment before display it on the square selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            squareSelected.imageView?.contentMode = .scaleAspectFill
            squareSelected.clipsToBounds = false
            squareSelected.setImage(pickedImage, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // - Tells the delegate that the user cancelled the pick operation
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // - Allows to present an Alert when it's necessary
    func presentAlert(viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
