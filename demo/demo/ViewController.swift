//
//  ViewController.swift
//  demo
//
//  Created by Denis Martin on 28/06/2015.
//  Copyright (c) 2015 iRLMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView:  UIImageView!
	@IBOutlet weak var cameraView: IRLCameraView! {
		didSet {
			cameraView.setupCameraView()
			cameraView.delegate = self
			cameraView.alpha = 0
			cameraView.overlayColor = .white
			cameraView.detectorType = .performance
			cameraView.cameraViewType = .normal
			cameraView.isShowAutoFocusEnabled = true
			cameraView.isBorderDetectionEnabled = true
		}
	}
    
    // MARK: User Actions

    @IBAction func scan(_ sender: AnyObject) {
		/*
		let scanner = IRLScannerViewController.cameraView(withDefaultType: .normal,
		                                                  defaultDetectorType: IRLScannerDetectorType.performance, with: self)
        scanner.showControls = false
        scanner.showAutoFocusWhiteRectangle = false
        present(scanner, animated: true, completion: nil)
		*/

		imageView.image = nil
		cameraView.start()

		view.bringSubview(toFront: cameraView)

		UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
			self.cameraView.alpha = 1
		}, completion: nil)
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		cameraView.start()

		view.bringSubview(toFront: cameraView)

		UIView.animate(withDuration: 0.3, delay: 0.1, options: [], animations: {
			self.cameraView.alpha = 1
		}, completion: nil)
	}
}

// MARK: IRLCameraViewProtocol

extension ViewController: IRLCameraViewProtocol {

	func didDetectRectangle(_ view: IRLCameraView!, withConfidence confidence: UInt) {
		print("didDetectRectangle withConfidence \(confidence)")
	}

	func didGainFullDetectionConfidence(_ view: IRLCameraView!) {
		print("didGainFullDetectionConfidence")

		//imageView.image = view.latestCorrectedUIImage()

		view.captureImage { [weak self](image: UIImage?) in
			self?.imageView.image = image

			UIView.animate(withDuration: 0.3, animations: { 
				view.alpha = 0
			}) { (_) in
				view.stop()
			}
		}
	}

	func didLostConfidence(_ view: IRLCameraView!) {

	}
}
