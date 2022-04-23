//
//  ViewController.swift
//  Plant Recognition
//
//  Created by Mohammad Hamudeh on 23/04/2022.
//

import UIKit
import Photos

class ChooseImageViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imageResults:ImageResults!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blureView: UIVisualEffectView!
    @IBOutlet weak var plantResultsTableView: UITableView!
    var plantImage:UIImage!
    @IBOutlet weak var plantImageView: UIImageView!
    @IBOutlet weak var plantNameLabel: CustomLabel!
    
    @IBOutlet weak var photoSelectBtn: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        plantResultsTableView.register(UINib(nibName: "PlantTableViewCell", bundle: nil), forCellReuseIdentifier: "plantCell")
        plantResultsTableView.dataSource = self
        plantResultsTableView.delegate = self
        plantResultsTableView.rowHeight = 180
        plantResultsTableView.estimatedRowHeight = 140
        self.blureView.isHidden = true
        
    }
    @IBAction func selectPhotoBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
                self.openCamera()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            alert.dismiss(animated: true) {
                self.openGallery()
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .notDetermined:
                    break
                case .restricted:
                    break
                case .denied:
                    let alert  = UIAlertController(title: "Permission Denied", message: "You don't have permision to  camera", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                case .authorized:
                    DispatchQueue.main.async {
                        let cameraPicker = UIImagePickerController()
                        cameraPicker.delegate = self
                        cameraPicker.sourceType = .camera
                        cameraPicker.allowsEditing = false
                        cameraPicker.showsCameraControls = true
                        self.present(cameraPicker, animated: true, completion: nil)
                    }
                case .limited:
                    break
                }
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "it looks that you don't have camera or its not working!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .authorized:
                    DispatchQueue.main.async {
                        let pickerController = UIImagePickerController()
                        pickerController.delegate = self
                        pickerController.sourceType = .photoLibrary
                        self.present(pickerController, animated: true)
                    }
                    
                default:
                    break
                }
            }
        }
    }
    func getImageResults(imageURL:URL){
        ImageRecognitionServices.instance.getImageRecognitionResults(image: imageURL) { res in
            switch res{
            case .success(let data):
                self.imageResults = data
                self.loadingIndicator.stopAnimating()
                self.loadingIndicator.isHidden = true
                self.plantResultsTableView.reloadData()
            case .failure(_):
                let alert = UIAlertController(title: "Error", message: "Un expected error, Please Try Again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true)
                }))
                self.present(alert, animated: true)
            }
            
        }
    }
    @IBAction func touchTohide(_ sender: Any) {
        self.blureView.isHidden = true
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let plantImageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            
            self.plantImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            getImageResults(imageURL: plantImageURL)
            
            
        }
        dismiss(animated: true, completion: {
            self.loadingIndicator.startAnimating()
            self.loadingIndicator.isHidden = false
        })
        
    }
    @objc func retakeImage(_ sender:Any){
        selectPhotoBtnPressed(sender)
    }
}
extension ChooseImageViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if imageResults != nil{
            return 1
        }else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if imageResults != nil{
            return imageResults.results.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = imageResults.results[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "plantCell", for: indexPath) as? PlantTableViewCell{
            let score = round(item.score*1000/10)
            
            cell.accuracyLabel.text = "\(score)%"
            cell.plantNAmeLAbel.text = item.species.scientificName
            cell.plantDecriptionLabel.text = item.species.scientificNameAuthorship
            cell.plantImage.image = plantImage
            return cell
        }
        return PlantTableViewCell()
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let stackView = UIStackView(frame: CGRect(x: 20, y: 8, width: tableView.frame.width - 40, height: tableView.layer.frame.height - 16))
        stackView.backgroundColor = .white
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .vertical
        let label1 = UILabel()
        label1.text = "We didn't find your plant?"
        let label2  = UILabel()
        label2.text = "Retake the photo or send us the picture so that we can help you find it"
        label2.numberOfLines = 2
        label1.font = UIFont.systemFont(ofSize: 16, weight: .bold )
        label1.textColor = .black
        label2.font = UIFont.systemFont(ofSize: 12)
        label2.textColor = .black
        stackView.addArrangedSubview(label1)
        stackView.addArrangedSubview(label2)
        let btn = UIButton()
        btn.setTitle("Retake photo", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(retakeImage), for: .touchUpInside)
        
        stackView.addArrangedSubview(btn)
        
        return stackView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn) {
            self.plantImageView.image = self.plantImage
            self.plantNameLabel.text = self.imageResults.results[indexPath.row].species.scientificName
            self.blureView.isHidden = false
        }
        
    }
}
