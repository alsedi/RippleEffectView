//
//  ViewController.swift
//  RippleEffectView
//
//  Created by Maximilian Alexander on 12/07/2016.
//  Copyright (c) 2016 Maximilian Alexander. All rights reserved.
//

import UIKit
import RippleEffectView

class Example1ViewController: UIViewController {
    var rippleEffectView: RippleEffectView!

    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        view.backgroundColor = UIColor.black
        rippleEffectView = RippleEffectView()
        rippleEffectView.tileImage = UIImage(named: "cell-image")
        rippleEffectView.magnitude = 0.6
        rippleEffectView.cellSize = CGSize(width:50, height:50)
        rippleEffectView.rippleType = .heartbeat
        view.addSubview(rippleEffectView)

        //Example, simple tile image customization
        rippleEffectView.tileImageCustomizationClosure = {rows, columns, row, column, image in
            if (row % 2 == 0 && column % 2 == 0) {
                let newImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
                UIColor.random.set()
                newImage.draw(in: CGRect(x:0, y:0, width:image.size.width, height:newImage.size.height));
                if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    return titledImage
                }
                UIGraphicsEndImageContext()
            }
            return image
        }


        //Example 2: Complex tile image customization
        /*
         rippleEffectView.tileImageCustomizationClosure = { rows, columns, row, column, image in
         let newImage = image.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
         UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)

         let xmiddle = (columns % 2 != 0) ? columns/2 : columns/2 + 1
         let ymiddle = (rows % 2 != 0) ? rows/2 : rows/2 + 1

         let xoffset = abs(xmiddle - column)
         let yoffset = abs(ymiddle - row)

         UIColor(hue: 206/360.0, saturation: 1, brightness: 0.95, alpha: 1).withAlphaComponent(1.0 - CGFloat((xoffset + yoffset)) * 0.1).set()

         newImage.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: newImage.size.height));
         if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
         UIGraphicsEndImageContext()
         return titledImage
         }
         UIGraphicsEndImageContext()
         return image
         }
         */


        rippleEffectView.setupView()
        rippleEffectView.animationDidStop = { [unowned self] in
            //Each time animation sequency finished this callback will change background of the wrapper view.
            UIView.animate(withDuration: 1.5, animations: { _ in
                self.rippleEffectView.backgroundColor = UIColor.random.withAlphaComponent(0.25)
            }) 
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rippleEffectView.startAnimating()
    }
}

