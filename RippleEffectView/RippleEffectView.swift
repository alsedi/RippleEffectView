//
//  RippleEffectView.swift
//  RippleEffectView
//
//  Created by Alex Sergeev on 8/14/16.
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

public enum RippleType {
    case oneWave
    case heartbeat
}

@IBDesignable
open class RippleEffectView: UIView {
    public typealias CustomizationClosure = (_ totalRows:Int, _ totalColumns:Int, _ currentRow:Int, _ currentColumn:Int, _ originalImage:UIImage)->(UIImage)
    public typealias VoidClosure = () -> ()

    open var cellSize:CGSize?
    open var rippleType: RippleType = .oneWave

    open var tileImage:UIImage!
    open var magnitude: CGFloat = -0.6
    open var animationDuration: Double = 3.5

    var isAnimating: Bool = false

    fileprivate var tiles = [GridItemView]()
    fileprivate var isGridRendered: Bool = false

    open var tileImageCustomizationClosure: CustomizationClosure? = nil {
        didSet {
            stopAnimating()
            removeGrid()
            renderGrid()
        }
    }

    open var animationDidStop: VoidClosure?

    open func setupView() {
        if isAnimating {
            stopAnimating()
        }
        removeGrid()
        renderGrid()
    }
}

// MARK: View operations
extension RippleEffectView {
    override open func willMove(toSuperview newSuperview: UIView?) {
        if let parent = newSuperview, newSuperview != nil {
            self.frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height)
        }
    }

    override open func layoutSubviews() {
        guard let parent = superview else { return }
        self.frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height)
        setupView()
    }
}

//MARK: Animations
extension RippleEffectView {
    open func stopAnimating() {
        isAnimating = false
        layer.removeAllAnimations()
    }

    open func simulateAnimationEnd() {
        waitAndRun(animationDuration){
            if let callback = self.animationDidStop {
                callback()
            }

            if self.isAnimating {
                self.simulateAnimationEnd()
            }
        }
    }

    open func startAnimating() {
        guard superview != nil else {
            return
        }

        if isGridRendered == false {
            renderGrid()
        }

        isAnimating = true
        layer.shouldRasterize = true
        simulateAnimationEnd()

        for tile in tiles {
            let distance = self.distance(fromPoint:tile.position, toPoint:self.center)
            var vector = self.normalizedVector(fromPoint:tile.position, toPoint:self.center)

            vector = CGPoint(x:vector.x * magnitude * distance, y: vector.y * magnitude * distance)
            tile.startAnimatingWithDuration(animationDuration, rippleDelay: animationDuration - 0.0006666 * TimeInterval(distance), rippleOffset: vector)
        }
    }
}

//MARK: Grid operations
extension RippleEffectView {
    func removeGrid() {
        for tile in tiles {
            tile.removeAllAnimations()
            tile.removeFromSuperlayer()
        }
        tiles.removeAll()
        isGridRendered = false
    }

    func renderGrid() {
        guard isGridRendered == false else { return }
        guard tileImage != nil else { return }

        isGridRendered = true
        let itemWidth = (cellSize == nil) ? tileImage.size.width : cellSize!.width
        let itemHeight = (cellSize == nil) ? tileImage.size.height : cellSize!.height

        let rows = ((self.rows % 2 == 0) ? self.rows + 3 : self.rows + 2)
        let columns = ((self.columns % 2 == 0) ? self.columns + 3 : self.columns + 2)

        let offsetX = columns / 2
        let offsetY = rows / 2

        let startPoint = CGPoint(x: center.x - (CGFloat(offsetX) * itemWidth), y: center.y - (CGFloat(offsetY) * itemHeight))

        for row in 0..<rows {
            for column in 0..<columns {
                let tileLayer = GridItemView()
                if let imageCustomization = tileImageCustomizationClosure {
                    tileLayer.tileImage = imageCustomization(self.rows, self.columns, row, column, (tileLayer.tileImage == nil) ? tileImage : tileLayer.tileImage!)
                    tileLayer.contents = tileLayer.tileImage?.cgImage
                } else {
                    tileLayer.contents = tileImage.cgImage
                }
                tileLayer.rippleType = rippleType
                tileLayer.frame.size = CGSize(width: itemWidth, height: itemHeight)
                tileLayer.contentsScale = contentScaleFactor
                tileLayer.contentsGravity = kCAGravityResize
                tileLayer.position = startPoint
                tileLayer.position.x = tileLayer.position.x + (CGFloat(column) * itemWidth)
                tileLayer.position.y = tileLayer.position.y + (CGFloat(row) * itemHeight)
                tileLayer.shouldRasterize = true
                layer.addSublayer(tileLayer)
                tiles.append(tileLayer)
            }
        }
    }

    var rows: Int {
        var size = tileImage.size
        if let _ = cellSize {
            size = cellSize!
        }
        return Int(self.frame.height / size.height)
    }

    var columns: Int {
        var size = tileImage.size
        if let _ = cellSize {
            size = cellSize!
        }
        return Int(self.frame.width / size.width)
    }
}

//MARK: Helper methods
private extension UIView {
    func distance(fromPoint:CGPoint,toPoint:CGPoint)->CGFloat {
        let nX = (fromPoint.x - toPoint.x)
        let nY = (fromPoint.y - toPoint.y)
        return sqrt(nX*nX + nY*nY)
    }

    func normalizedVector(fromPoint:CGPoint,toPoint:CGPoint)->CGPoint {
        let length = distance(fromPoint:fromPoint, toPoint:toPoint)
        guard length > 0 else { return CGPoint.zero }
        return CGPoint(x:(fromPoint.x - toPoint.x)/length, y:(fromPoint.y - toPoint.y)/length)
    }
}

private class GridItemView: CALayer {
    var tileImage:UIImage?
    var rippleType:RippleType = .oneWave

    func startAnimatingWithDuration(_ duration: TimeInterval, rippleDelay: TimeInterval, rippleOffset: CGPoint) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.2, 1)
        let linearFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        let zeroPointValue = NSValue(cgPoint: CGPoint.zero)

        var animations = [CAAnimation]()

        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        if rippleType == .heartbeat {
            scaleAnimation.keyTimes = [0, 0.3, 0.4, 0.5, 0.6, 0.69, 0.735, 1]
            scaleAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, timingFunction, timingFunction, timingFunction]
            scaleAnimation.values = [1, 1, 1.35, 1.05, 1.20, 0.95, 1, 1]
        } else {
            scaleAnimation.keyTimes = [0, 0.5, 0.6, 1]
            scaleAnimation.values = [1, 1, 1.15, 1]
            scaleAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction]
        }
        scaleAnimation.beginTime = 0.0
        scaleAnimation.duration = duration
        animations.append(scaleAnimation)

        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        positionAnimation.duration = duration
        if rippleType == .heartbeat {
            let secondBeat = CGPoint(x:rippleOffset.x, y:rippleOffset.y)
            positionAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, timingFunction, timingFunction, linearFunction]
            positionAnimation.keyTimes = [0, 0.3, 0.4, 0.5, 0.6, 0.7, 0.75, 1]
            positionAnimation.values = [zeroPointValue, zeroPointValue, NSValue(cgPoint:rippleOffset), zeroPointValue, NSValue(cgPoint:secondBeat), NSValue(cgPoint:CGPoint(x:-rippleOffset.x*0.3,y:-rippleOffset.y*0.3)),zeroPointValue, zeroPointValue]
        } else {
            positionAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction]
            positionAnimation.keyTimes = [0, 0.5, 0.6, 1]
            positionAnimation.values = [zeroPointValue, zeroPointValue, NSValue(cgPoint:rippleOffset), zeroPointValue]
        }
        positionAnimation.isAdditive = true
        animations.append(positionAnimation)

        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        if rippleType == .heartbeat {
            opacityAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
            opacityAnimation.keyTimes = [0, 0.3, 0.4, 0.5, 0.6, 0.69, 1]
            opacityAnimation.values = [1, 1, 0.85, 0.75, 0.90, 1, 1]
        } else {
            opacityAnimation.timingFunctions = [linearFunction, timingFunction, timingFunction, linearFunction]
            opacityAnimation.keyTimes = [0, 0.5, 0.6, 0.94, 1]
            opacityAnimation.values = [1, 1, 0.45, 1, 1]
        }
        animations.append(opacityAnimation)

        let groupAnimation = CAAnimationGroup()
        groupAnimation.repeatCount = Float.infinity
        groupAnimation.fillMode = kCAFillModeBackwards
        groupAnimation.duration = duration
        groupAnimation.beginTime = rippleDelay
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.animations = animations
        groupAnimation.timeOffset = 0.35 * duration

        shouldRasterize = true
        add(groupAnimation, forKey: "ripple")
    }

    func stopAnimating() {
        removeAllAnimations()
    }
}

func waitAndRun(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
