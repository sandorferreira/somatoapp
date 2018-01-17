//
//  CamposViewController.swift
//  SomatoApp
//
//  Created by Sandor ferreira da silva on 28/08/17.
//  Copyright © 2017 Sandor Ferreira da Silva. All rights reserved.
//

import UIKit

class CamposViewController: UIViewController, UIScrollViewDelegate {
    
    // From Storyboard
    
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pesoTF: UITextField!
    @IBOutlet weak var alturaTF: UITextField!
    
    @IBOutlet weak var btHomem: UIButton!
    @IBOutlet weak var btMulher: UIButton!

    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonContinuar: UIButton!
    
    // Aux Variables
    
    var isHomem: Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .onDrag
        scrollView.delegate = self

        updateDesignables()
        isHomem = true
        // Do any additional setup after loading the view.
    }


    func updateDesignables() {
        btHomem.layer.cornerRadius = btHomem.frame.height / 2.0
        btMulher.layer.cornerRadius = btMulher.frame.height / 2.0
        
        buttonContinuar.layer.cornerRadius = buttonContinuar.frame.height / 2.0
        
        datePicker.setValue(colorThemeYellow, forKey: "textColor")
    }
    
    
    
    
    @IBAction func continuar(_ sender: UIButton) {
        
        
        let textFieldIndex = isAnyTextFieldEmpty()
        
        if textFieldIndex != 0 {
            let alert = UIAlertController(title: "Ops!", message: "Você deve preencher todos os dados antes de continuar", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            (self.view.viewWithTag(textFieldIndex) as? UITextField)?.becomeFirstResponder()
        } else {
            let nome = nameTF.text
            var CONST_SEXO = "HOMEM"
            if let peso = Double(pesoTF.text!) {
                if let altura = Double(alturaTF.text!) {
                    let nascimento = datePicker.date
                    if isHomem == false {
                        CONST_SEXO = "MULHER"
                    }
                    let pessoa = Pessoa(nome: nome, nascimento: nascimento, sexo: CONST_SEXO, altura: altura, peso: peso)
                    let cameraController = self.storyboard?.instantiateViewController(withIdentifier: "cameraController") as! CameraViewController
                    cameraController.pessoa = pessoa
                    cameraController.navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(cameraController, animated: true)
                } else {
                    let alert = UIAlertController(title: "Ops!", message: "Valor de altura inválido", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            } else {
                let alert = UIAlertController(title: "Ops!", message: "Valor do peso inválido", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func pickHomem(_ sender: UIButton) {
        isHomem = true
        btHomem.backgroundColor = colorThemeYellow
        btHomem.setTitleColor(colorBackground, for: .normal)
        
        btMulher.backgroundColor = .clear
        btMulher.setTitleColor(colorThemeYellow, for: .normal)
        
    }
    
    @IBAction func pickMulher(_ sender: UIButton) {
        isHomem = false
        btHomem.backgroundColor = .clear
        btHomem.setTitleColor(colorThemeYellow, for: .normal)
        
        btMulher.backgroundColor = colorThemeYellow
        btMulher.setTitleColor(colorBackground, for: .normal)
    }
    
    func isAnyTextFieldEmpty() -> Int {
        if (nameTF.text?.isEmpty)! {
            return 1
        }
        if (alturaTF.text?.isEmpty)! {
            return 2
        }
        if (pesoTF.text?.isEmpty)! {
            return 3
        }
        
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    

}
