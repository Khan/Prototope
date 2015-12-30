//
//  CameraLayer.swift
//  Prototope
//
//  Created by Andy Matuschak on 3/5/15.
//  Copyright (c) 2015 Khan Academy. All rights reserved.
//

import Foundation
import AVFoundation

/** A layer that shows the output of one of the device's cameras. Defaults to using the back camera. */
public class CameraLayer: Layer {
	public enum CameraPosition: Printable {
		/** The device's front-facing camera. */
		case Front

		/** The device's back-facing camera. */
		case Back

		private var avCaptureDevicePosition: AVCaptureDevicePosition {
			switch self {
			case .Front: return .Front
			case .Back: return .Back
			}
		}

		public var description: String {
			switch self {
			case .Front: return "Front"
			case .Back: return "Back"
			}
		}
	}

	/** Selects which camera to use. */
	public var cameraPosition: CameraPosition {
		didSet { updateSession() }
	}

	private var captureSession: AVCaptureSession?

	public init(parent: Layer? = Layer.root, name: String? = nil) {
		self.cameraPosition = .Back
		super.init(parent: parent, name: name, viewClass: CameraView.self)
		updateSession()
	}

	deinit {
		captureSession?.stopRunning()
	}

	private func updateSession() {
		// Find device matching camera setting
		let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice]
		if let device = filter(devices, { device in return device.position == self.cameraPosition.avCaptureDevicePosition }).first {
			var error: NSError?
			if let input = AVCaptureDeviceInput(device: device, error: &error) {
				captureSession?.stopRunning()

				captureSession = AVCaptureSession()
				captureSession!.addInput(input)
				captureSession!.startRunning()
				cameraLayer.session = captureSession!
				cameraLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
			} else {
				Environment.currentEnvironment!.exceptionHandler("Couldn't create camera device: \(error)")
			}

		} else {
			Environment.currentEnvironment!.exceptionHandler("Could not find a \(cameraPosition.description.lowercaseString) camera on this device")
		}

	}

	private var cameraLayer: AVCaptureVideoPreviewLayer {
		return (self.view as! CameraView).layer as! AVCaptureVideoPreviewLayer
	}

	/** Underlying camera view class. */
	private class CameraView: SystemView {
		#if os(iOS)
		override class func layerClass() -> AnyClass {
			return AVCaptureVideoPreviewLayer.self
		}
		#else
		override func makeBackingLayer() -> CALayer {
			return AVCaptureVideoPreviewLayer()
		}
		#endif
	}
}
