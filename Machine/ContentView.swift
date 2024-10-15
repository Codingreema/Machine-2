////
////  ContentView.swift
////  Machine
////
////  Created by Rimah on 04/07/1445 AH.
////
//import CoreML
//import SwiftUI
//import ARKit
//
//struct ARViewContainer: UIViewControllerRepresentable {
//    let arViewController: ARViewController
//    let model: modelHand
//
//    func makeUIViewController(context: UIViewControllerRepresentableContext<ARViewContainer>) -> ARViewController {
//        let controller = ARViewController()
//        controller.model = model
//        arViewController.arView = controller.arView
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARViewContainer>) {
//    }
//}
//
//class ARViewController: UIViewController, ARSessionDelegate {
//    var frameCounter = 0
//    let handPosePredictionInterval = 10
//    var model: modelHand!
//    var effectNode: SCNNode?
//    var arView: ARSCNView!
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        arView = ARSCNView()
//        arView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(arView)
//
//        NSLayoutConstraint.activate([
//            arView.topAnchor.constraint(equalTo: view.topAnchor),
//            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//
//        let session = ARSession()
//        session.delegate = self
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.frameSemantics = .personSegmentationWithDepth
//        arView.session.run(configuration)
//    }
//
//
//
//func session(_ session: ARSession, didUpdate frame: ARFrame)  {
//    let pixelBuffer = frame.capturedImage
//    let handPoseRequest = VNDetectHumanHandPoseRequest()
//    handPoseRequest.maximumHandCount = 1
//    handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
//    
//    let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
//    
//    do {
//        try handler.perform([handPoseRequest])
//    } catch {
//        assertionFailure("Hand Pose Request failed: \(error)")
//    }
//    
//    guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
//        return
//    }
//    
//    if frameCounter % handPosePredictionInterval == 0 {
//       if let handObservation = handPoses.first as? VNHumanHandPoseObservation {
//            do {
//                let keypointsMultiArray = try handObservation.keypointsMultiArray()
//                let handPosePrediction = try model.prediction(poses: keypointsMultiArray)
//                let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
//
//                print("Confidence: \(confidence)")
//
//                if confidence > 0.9 {
//                    print("Rendering hand pose effect: \(handPosePrediction.label)")
//                    renderHandPoseEffect(name: handPosePrediction.label)
//                }
//            } catch {
//                fatalError("Failed to perform hand pose prediction: \(error)")
//            }
//        }
//    }
//
//}
//
//func renderHandPoseEffect(name: String) {
//    switch name {
//    case "One":
//        print("Rendering effect for One")
//        if effectNode == nil {
//            effectNode = addParticleNode(for: "One")
//        }
//    default:
//        print("Removing all particle nodes")
//        removeAllParticleNode()
//    }
//}
//
//func removeAllParticleNode() {
//    effectNode?.removeFromParentNode()
//    effectNode = nil
//}
//
//    func addParticleNode(for poseName: String) -> SCNNode {
//        print("Adding particle node for pose: \(poseName)")
//        let particleNode = SCNNode()
//        return particleNode
//    }
//}
//struct ContentView: View {
//    let model = modelHand()
//
//    var body: some View {
//        VStack {
//            Text("View")
//            ARViewContainer(arViewController: ARViewController(), model: model)
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//
