//
//  ViewController.swift
//  Tip
//
//  Created by Alejandro Barros Fuentes on 8/21/18.
//  Copyright © 2018 Alejandro Barros Fuentes. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var price: UITextField!
    var percentage : Double = 15.0
    @IBOutlet weak var tipRecomend: UILabel!
    var tips: [String] = [ "15","18","20"]
    @IBOutlet weak var newTip: UITextField!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidAppear(true)
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.table.flashScrollIndicators()
        let imageBack = #imageLiteral(resourceName: "background-orange-vector")
        let imageView = UIImageView(image: imageBack)
        self.table.backgroundView = imageView
        self.newTip.delegate = self;
    }
    
    @IBAction func addTip(_ sender: Any) {
        if validTips() == true {
            insertNewTip()
        } else {
            showAlertMessage( title: "Attention!!" , message: "The percentage set is duplicate.")
        }
    }
    
    func validTips() -> Bool {
        var ret = true
        let tipInput = newTip.text!
        for tip in tips {
            if tip == tipInput {
                ret = false
            }
        }
        return ret
    }
    
    func insertNewTip(){
        if validateNullValues(input: newTip ) == true {
            tips.append(newTip.text!)
            let index = IndexPath(row:tips.count - 1 ,section: 0 )
            table.beginUpdates()
            table.insertRows(at: [index] , with: .automatic)
            table.endUpdates()
            newTip.text = ""
            view.endEditing(true)
        } else {
            showAlertMessage(title :"Attention!!", message: "Input the new tip, please")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        cell.textLabel?.text = self.tips[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let text = cell?.textLabel?.text
        percentage = (text! as NSString).doubleValue
        tipRecomend.text = ""
        if price.text != nil && !(price.text == "") {
            calculate()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle , forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            tips.remove(at: indexPath.row)
            table.beginUpdates()
            table.deleteRows(at: [indexPath], with: .automatic)
            table.endUpdates()
        }
    }
    
    func showAlertMessage(title : String , message : String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Accept", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true , completion: nil)
    }
    
    func validateNullValues(input : UITextField) -> Bool {
        if input.text == nil || input.text == "" {
            return false
        }
        return true
    }
    
    @IBAction func calculate(){
        if validateNullValues(input: price ) == true {
            var result : Double
            let value  = (price.text! as NSString).doubleValue
            result =  round(value * percentage) / 100
            tipRecomend.text = String(result)
        } else {
            showAlertMessage(title: "Attention!!", message: "Input the price, please")
        }
    }
    
    func textField( _ textFiel: UITextField , shouldChangeCharactersIn range: NSRange , replacementString string : String ) -> Bool{
        let allowedCharacter = CharacterSet.decimalDigits
        let characterSet =  CharacterSet(charactersIn: string)
        return allowedCharacter.isSuperset(of: characterSet)
    }

}

