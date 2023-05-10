//
//  SettingView.swift
//  EpidemicSimulator
//
//  Created by Lucy Rez on 09.05.2023.
//

import UIKit

public final class SettingView: UIView {
        
    private let minValue: Int
    private let maxValue: Int
    private let errorMessage: String
    public var value: Int?
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.layer.borderWidth = 2
        tf.isUserInteractionEnabled = true
        tf.layer.borderColor = UIColor.black.cgColor
        tf.addTarget(self, action: #selector(validateTextField), for: .editingChanged)
        return tf
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    required init(title: String, placeholderText: String, errorText: String, minValue: Int, maxValue: Int) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.errorMessage = errorText
        super.init(frame: .zero)
        
        updateView(titleText: title, placeholderText: placeholderText, errorText: errorText)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView(titleText: String, placeholderText: String, errorText: String) {
        titleLabel.text = titleText
        textField.placeholder = placeholderText
        errorLabel.text = errorText
    }
    
    private func setUpView() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(errorLabel)
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 42),
            textField.widthAnchor.constraint(equalToConstant: 200),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        errorLabel.isHidden = true
    }
    
    @objc private func validateTextField() {
        guard let text = textField.text else { return }
        guard let inputValue = Int(text) else {
            errorLabel.text = "Текст должен быть числом"
            errorLabel.isHidden = false
            textField.layer.borderColor = UIColor.red.cgColor
            value = nil
            return
        }
        
        if inputValue > maxValue || inputValue < minValue {
            errorLabel.text = errorMessage
            errorLabel.isHidden = false
            textField.layer.borderColor = UIColor.red.cgColor
            value = nil
            return
        }
        
        errorLabel.isHidden = true
        textField.layer.borderColor = UIColor.black.cgColor
        value = inputValue
    }
    
}
