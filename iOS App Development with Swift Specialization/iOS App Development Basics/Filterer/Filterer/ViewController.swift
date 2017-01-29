//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var newPhotoButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var shareButton: UIButton!

    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var redFilterButton: UIButton!
    @IBOutlet var greenFilterButton: UIButton!
    @IBOutlet var blueFilterButton: UIButton!
    @IBOutlet weak var grayscaleFilterButton: UIButton!
    @IBOutlet weak var contrastFilterButton: UIButton!
    
    @IBOutlet var thirdMenu: UIView!
    @IBOutlet var intensitySlider: UISlider!
    
    var originalImage: UIImage?
    var currentImage: UIImage!
    var currentFilter: Filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        thirdMenu.translatesAutoresizingMaskIntoConstraints = false
        if let originalImage = imageView.image {
            self.originalImage = originalImage
        }
        compareButton.enabled = false
        editButton.enabled = false
        setButtonsIcon(UIImage(named: "landscape")!)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.overlayLongPressed(_:)))
        imageView.addGestureRecognizer(longPressRecognizer)
        imageView.userInteractionEnabled = true
    
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func setButtonsIcon(iconImage: UIImage) {
        guard let rgbaImage = RGBAImage(image: iconImage) else {
            return
        }
        
        let redIcon = FilterCalculations.redFilter(rgbaImage, intensity: 1)
        let greenIcon = FilterCalculations.greenFilter(rgbaImage, intensity: 1)
        let blueIcon = FilterCalculations.blueFilter(rgbaImage, intensity: 1)
        let grayscaleIcon = FilterCalculations.grayscaleFilter(rgbaImage, intensity: 0.5)
        let contrastIcon = FilterCalculations.contrastFilter(rgbaImage, intensity: 0.8)
        
        redFilterButton.setImage(redIcon.toUIImage(), forState: .Normal)
        greenFilterButton.setImage(greenIcon.toUIImage(), forState: .Normal)
        blueFilterButton.setImage(blueIcon.toUIImage(), forState: .Normal)
        grayscaleFilterButton.setImage(grayscaleIcon.toUIImage(), forState: .Normal)
        contrastFilterButton.setImage(contrastIcon.toUIImage(), forState: .Normal)
    }
    
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            setupNewImage(image)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onEdit(sender: UIButton) {
        if (sender.selected) {
            hideThirdMenu()
            sender.selected = false
        } else {
            showThirdMenu()
            sender.selected = true
        }
    }
  
    func showThirdMenu() {
        hideSecondaryMenu()
        view.addSubview(thirdMenu)
        
        let bottomConstraint = thirdMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = thirdMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = thirdMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = thirdMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.thirdMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.thirdMenu.alpha = 1.0
        }
    }
    
    func hideThirdMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.thirdMenu.alpha = 0
        }) { completed in
            if completed == true {
                self.editButton.selected = false
                self.thirdMenu.removeFromSuperview()
            }
        }
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        hideThirdMenu()
        view.addSubview(secondaryMenu)
        
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.filterButton.selected = false                    
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    func setupNewImage(image: UIImage) {
        hideSecondaryMenu()
        hideThirdMenu()
        imageView.image = image
        self.originalImage = image
        compareButton.enabled = false
        editButton.enabled = false
        filterButton.selected = false
        editButton.selected = false
    }
    
    
    func applyFilter(filter: Filter) {
        guard let originalImage = self.originalImage, rgbaImage = RGBAImage(image: originalImage) else {
            return
        }
        onFilterStart()
        let filteredImage = filter.apply(rgbaImage)
        if let image = filteredImage.toUIImage() {
            crossFadeToImage(image)
            onFilterComplete()
        }
    }

    func crossFadeToImage(image: UIImage) {
        UIView.transitionWithView(imageView,
                                  duration:1,
                                  options: UIViewAnimationOptions.TransitionCrossDissolve,
                                  animations: {self.imageView.image = image},
                                  completion: nil)
    }
    
    
    func onFilterStart() {
        compareButton.enabled = false
        editButton.enabled = false
    }
    
    func onFilterComplete() {
        compareButton.enabled = true
        editButton.enabled = true
    }
 
    func addTextToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        
        // Setup the font specific variables
        let textColor: UIColor = UIColor.redColor()
        // calculate the overlay font size, otherwise for high-res images it will be too small,
        // and for low-res images it will be too huge.
        let fontSize: Int = Int(floorf(Float(inImage.size.width) / 5.0))
        let textFont: UIFont = UIFont(name: "Helvetica", size: CGFloat(fontSize))!
        
        //Setup the image context using the passed image.
        UIGraphicsBeginImageContext(inImage.size)
        
        //Setups up the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            
            ]
        
        //Put the image into a rectangle as large as the original image.
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        
        // Creating a point within the space that is as bit as the image.
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        
        //Now Draw the text into an image.
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //And pass it back up to the caller.
        return newImage
        
    }
    
    func startCompare() {
        guard let currentImage = imageView.image else {
            return
        }
        
        self.currentImage = currentImage
        
        if let originalImage = self.originalImage {
            let labeledImage = addTextToImage("original", inImage: originalImage, atPoint: CGPointMake(0, 0))
            crossFadeToImage(labeledImage)
        }
    }
    
    func endCompare() {
        if let _ = self.originalImage {
            crossFadeToImage(currentImage)
        }
    }
 
    func overlayLongPressed(longPress: UIGestureRecognizer) {
        if (longPress.state == UIGestureRecognizerState.Ended) {
            endCompare()
        }else if (longPress.state == UIGestureRecognizerState.Began) {
            startCompare()
        }
    }
    
    @IBAction func onRedFilter() {
        guard let filter = Filter(name: "Red", intensity: Double(intensitySlider.value)) else {
            return
        }
        currentFilter = filter
        applyFilter(filter)
    }
    
    @IBAction func onGreenFilter() {
        guard let filter = Filter(name: "Green", intensity: Double(intensitySlider.value)) else {
            return
        }
        currentFilter = filter
        applyFilter(filter)
    }
    
    @IBAction func onBlueFilter() {
        guard let filter = Filter(name: "Blue", intensity: Double(intensitySlider.value)) else {
            return
        }
        currentFilter = filter
        applyFilter(filter)
    }
    
    @IBAction func onGrayscaleFilter() {
        guard let filter = Filter(name: "Grayscale", intensity: Double(intensitySlider.value)) else {
            return
        }
        currentFilter = filter
        applyFilter(filter)
    }
    
    @IBAction func onContrastFilter() {
        guard let filter = Filter(name: "Contrast", intensity: Double(intensitySlider.value)) else {
            return
        }
        currentFilter = filter
        applyFilter(filter)
    }
    
    @IBAction func compareOriginal() {
        startCompare()
    }
    
    @IBAction func compareFiltered() {
        endCompare()
    }
    
    @IBAction func onIntensitySlider(sender: UISlider) {
        let intensity = sender.value
        currentFilter.intensity = Double(intensity)
        applyFilter(currentFilter)
    }
}

