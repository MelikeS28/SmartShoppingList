//
//  DetailsViewController.swift
//  SmartShoppingList
//
//  Created by Melike on 22.06.2026.
//

import UIKit
import SnapKit
import PhotosUI

class DetailsViewController: UIViewController {

    
    // MARK: - Properties
    
     let viewModel = DetailsViewModel()
    
    // MARK: - UI Elements
        
        private let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(systemName: "photo.badge.plus")
            imageView.tintColor = .systemGray
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            return imageView
        }()
        
        private let nameTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Enter the product name"
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        private let priceTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Enter the price"
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        private let sizeTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = "Enter the size"
            textField.borderStyle = .roundedRect
            return textField
        }()
        
        private let saveButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.backgroundColor = .systemPurple
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 8.0
            return button
        }()
        
    // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupConstraints()
            setupImagePickerGestureRecognizer()
            
            saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
            configureUI()
        }
    
    // MARK: - GestureRecognizer
    private func setupImagePickerGestureRecognizer() {
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func selectImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    // MARK: - Actions
    @objc private func saveButtonAction() {
        let name = nameTextField.text
        let price = priceTextField.text
        let size = sizeTextField.text
        let image = imageView.image
        
        viewModel.saveProduct(name: name, price: price, size: size, image: image)
        
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Configure UI
    private func configureUI() {
        if let item = viewModel.chosenShoppingItem {
            
            nameTextField.text = item.name
            sizeTextField.text = item.size
            priceTextField.text = String(item.price)
            
            if let imageData = item.image, let savedImage = UIImage(data: imageData) {
                imageView.image = savedImage
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
            }
            saveButton.isHidden = true
        }
    }
    // MARK: - SetupViews
        private func setupViews() {
            view.backgroundColor = .systemBackground
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemPurple]
            view.addSubview(imageView)
            view.addSubview(nameTextField)
            view.addSubview(priceTextField)
            view.addSubview(sizeTextField)
            view.addSubview(saveButton)
        }

    // MARK: - SetupConstraints
        private func setupConstraints() {
            
            imageView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(200)
            }
            
            nameTextField.snp.makeConstraints{ make in
                make.top.equalTo(imageView.snp.bottom).offset(30)
                make.left.right.equalToSuperview().inset(20)
                make.height.equalTo(44)
            }
            
            priceTextField.snp.makeConstraints { make in
                make.top.equalTo(nameTextField.snp.bottom).offset(15)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(44)
            }
            
            sizeTextField.snp.makeConstraints { make in
                make.top.equalTo(priceTextField.snp.bottom).offset(15)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.height.equalTo(44)
            }
            
            saveButton.snp.makeConstraints { make in
                make.top.equalTo(sizeTextField.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
        }

    }
   // MARK: - PHPickerViewControllerDelegate

extension DetailsViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { [ weak self] image, error in
                if let selectedImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self?.imageView.image = selectedImage
                        self?.imageView.contentMode = .scaleAspectFill
                        self?.imageView.clipsToBounds = true
                    }
                }
            }
        }
    }
    
}
