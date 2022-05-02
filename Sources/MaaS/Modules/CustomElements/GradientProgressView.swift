//
//  File.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit

class GradientProgressView: UIView {
    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    private let progressLayer = CALayer()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        layer.cornerRadius = 6
        layer.addSublayer(gradientLayer)
                
        gradientLayer.mask = progressLayer
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
    }

    override func draw(_ rect: CGRect) {
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))

        progressLayer.frame = progressRect
        progressLayer.backgroundColor = UIColor.black.cgColor
        progressLayer.cornerRadius = 6

        gradientLayer.frame = rect
        gradientLayer.colors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        gradientLayer.endPoint = CGPoint(x: progress, y: 0.5)
    }
}
