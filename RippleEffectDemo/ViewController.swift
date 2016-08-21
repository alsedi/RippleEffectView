//
//  ViewController.swift
//  RippleEffectDemo
//
//  Created by Alex Sergeev on 8/21/16.
//  Copyright © 2016 ALSEDI Group. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

extension UIColor {
  static var random: UIColor {
    get {
      let hue = CGFloat(Double(arc4random() % 360) / 360.0) // 0.0 to 1.0
      let saturation: CGFloat = 0.7
      let brightness: CGFloat = 0.8
      return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
  }
}

class ViewController: UIViewController {
  var rippleEffectView: RippleEffectView!

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  override func viewDidLoad() {
    rippleEffectView = RippleEffectView()
    rippleEffectView.tileImage = UIImage(named: "1")
    view.addSubview(rippleEffectView)
    //Example, how to change images for titles.
    rippleEffectView.tileImageRandomizationClosure = { row, column, image in
      if (row % 2 == 0 && column % 2 == 0) {
        let newImage = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(image.size, false, newImage.scale)
        UIColor.random.set()
        newImage.drawInRect(CGRectMake(0, 0, image.size.width, newImage.size.height));
        if let titledImage = UIGraphicsGetImageFromCurrentImageContext() {
          UIGraphicsEndImageContext()
          return titledImage
        }
        UIGraphicsEndImageContext()
      }
      return image
    }
    rippleEffectView.setupView()
    rippleEffectView.animationDidStop = { [unowned self] in
      //Each time animation sequency finished this callback will change background of the wrapper view.
      UIView.animateWithDuration(1.5) { _ in
        self.rippleEffectView.backgroundColor = UIColor.random.colorWithAlphaComponent(0.25)
      }
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    rippleEffectView.startAnimating()
  }
}

