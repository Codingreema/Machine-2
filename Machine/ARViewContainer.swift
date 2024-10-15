//
//  ARViewContainer.swift
//  Machine
//
//  Created by Rimah on 06/07/1445 AH.
//

import Foundation

struct ARViewContainer: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.session.delegate = context.coordinator
        arView.automaticallyConfigureSession = false
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            guard let pixelBuffer = frame.capturedImage else {
                return
            }

            let handPoseRequest = VNDetectHumanHandPoseRequest()
            handPoseRequest.maximumHandCount = 1

            let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
            try? handler.perform([handPoseRequest])

            guard let handPoses = handPoseRequest.results as? [VNHumanHandPoseObservation], !handPoses.isEmpty else {
                parent.parentViewModel.showHandPoseEffect = false
                return
            }

            let handObservation = handPoses[0]

            if let keypointsMultiArray = try? handObservation.keypointsMultiArray(),
                let handPosePrediction = try? HandPoseFive().prediction(poses: keypointsMultiArray),
                let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label],
                confidence > 0.9 {
                parent.parentViewModel.handPosePrediction = handPosePrediction.label
                parent.parentViewModel.showHandPoseEffect = true
            } else {
                parent.parentViewModel.showHandPoseEffect = false
            }
        }
    }
}
