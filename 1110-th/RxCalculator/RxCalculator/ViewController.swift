//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstValueTextField: UITextField!
    @IBOutlet weak var secondValueTextField: UITextField!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operationObservable: Observable<Calculator.Operation> = operationSegmentedControl.rx.value.map { selectedIndex in
            let operation = Calculator.Operation(rawValue: selectedIndex) ?? Calculator.Operation.addition
            return operation
        }
        
        let firstValueObserver: Observable<Int> = firstValueTextField.rx.text.map{ string in
            return Int(string ?? "") ?? 0
        }
        
        let secondValueObserver: Observable<Int> = secondValueTextField.rx.text.map{ string in
            return Int(string ?? "") ?? 0
        }
        
        let resultObservable = Observable.combineLatest(firstValueObserver, secondValueObserver) {(firstValue, secondValue) in
            return firstValue + secondValue
        }
        
        resultObservable.map{(resultInt) in
            return String(resultInt)
        }.bindTo(resultLabel.rx.text).addDisposableTo(disposeBag)
    }
    
}

