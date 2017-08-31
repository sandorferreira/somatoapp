//
//  Pessoa.swift
//  SomatoApp
//
//  Created by Sandor ferreira da silva on 28/08/17.
//  Copyright © 2017 Sandor Ferreira da Silva. All rights reserved.
//

import UIKit

class Pessoa {
    var nome: String?
    var nascimento: Date?
    var sexo: String?
    var altura: Double?
    var peso: Double?
    
    init(nome: String?, nascimento: Date?, sexo: String?, altura: Double?, peso: Double?) {
        self.nome = nome
        self.nascimento = nascimento
        self.sexo = sexo
        self.altura = altura
        self.peso = peso
    }
    
    
}
