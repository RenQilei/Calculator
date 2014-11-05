//
//  ViewController.swift
//  Calculator
//
//  Created by 任琦磊 on 14/10/24.
//  Copyright (c) 2014年 任琦磊. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var formulaString = ""
    
    @IBOutlet var formulaLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!
    
    @IBAction func ClickNumberButton(sender: UIButton) {
        formulaString += sender.currentTitle!
        formulaLabel.text = formulaString
    }
    @IBAction func ClickOperatorButton(sender: UIButton) {
        formulaString += sender.currentTitle!
        formulaLabel.text = formulaString
    }
    @IBAction func ClickEqualButton(sender: UIButton) {
        formulaString += sender.currentTitle!
        formulaLabel.text = formulaString
        
        var formulaCaculation: FormulaCaculation!
        formulaCaculation.caculating(formulaString)
    }
    @IBAction func ClickDeleteButton(sender: UIButton) {
        formulaString = formulaString.substringToIndex(advance(formulaString.startIndex, countElements(formulaString)-1))
        formulaLabel.text = formulaString
    }
    @IBAction func ClickAllDeleteButton(sender: UIButton) {
        formulaString = ""
        formulaLabel.text = formulaString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

