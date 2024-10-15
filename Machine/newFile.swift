//
//  newFile.swift
//  Machine
//
//  Created by Rimah on 12/07/1445 AH.

import CoreML
import SwiftUI
import ARKit
import SceneKit
import Vision

// بدايه😞

protocol ARViewControllerDelegate: AnyObject {
    func didDetectHandPose(with confidence: Float, name: String)
}
// هنا نعرف كل شيء بنحتاجه
class ARViewController: UIViewController, ARSessionDelegate {
    weak var delegate: ARViewControllerDelegate?
    
    let model = try? HandPoseFive(configuration: MLModelConfiguration())

    var frameCounter = 0
    let handPosePredictionInterval = 10
    var modelPose: HandPoseFive!
    var effectNode: SCNNode?
    var arView: ARSCNView!
    
    // UILabel عشان نطلعهم للشاشة 🤗
    var confidenceLabel: UILabel!
    var handPoseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arView = ARSCNView()
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        
        // Add UILabels نحطهم عشان نطلع معلوماتهم
        confidenceLabel = UILabel()
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confidenceLabel)
        
        handPoseLabel = UILabel()
        handPoseLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(handPoseLabel)
        
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            confidenceLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            confidenceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            handPoseLabel.topAnchor.constraint(equalTo: confidenceLabel.bottomAnchor, constant: 10),
            handPoseLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
        ])
        
        let session = ARSession()
        arView.session = session
        session.delegate = self
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.frameSemantics = .personSegmentationWithDepth
        arView.session.run(configuration)
    }
    // هنا الافعال اللي تصير لليد وبدونه ماكان بيعرف عن حركات اليد 😑
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1
        handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
        } catch {
            assertionFailure("Hand Pose Request failed: \(error)")
        }
        
        guard let handPoses = handPoseRequest.results, !handPoses.isEmpty else {
            return
        }
        
        if frameCounter % handPosePredictionInterval == 0 {
            if let handObservation = handPoses.first as? VNHumanHandPoseObservation {
                do {
                    let keypointsMultiArray = try handObservation.keypointsMultiArray()
                    let handPosePrediction = try modelPose.prediction(poses: keypointsMultiArray)
                    let confidence = handPosePrediction.labelProbabilities[handPosePrediction.label]!
                    
                    print("Confidence: \(confidence)")
                    
                    if confidence > 0.9 {
                        print("Rendering hand pose effect: \(handPosePrediction.label)")
                        renderHandPoseEffect(name: handPosePrediction.label)
                        // نقول له عن وضعية اليد🫠
                        delegate?.didDetectHandPose(with: Float(confidence), name: handPosePrediction.label)
                        
                        // نحدث وضعيات اليد هنا😮
                        confidenceLabel.text = "Confidence: \(String(format: "%.2f", confidence))"
                        handPoseLabel.text = "Hand Pose: \(handPosePrediction.label)"
                    }
                } catch {
                    fatalError("Failed to perform hand pose prediction: \(error)")
                }
            }
        }
    }
    func renderHandPoseEffect(name: String) {
       
    }
    
    func addParticleNode(for pose: HandPoseFive) -> SCNNode {
        let particleSystem = SCNParticleSystem(named: "HandParticleEffect.scnp", inDirectory: nil)!
      
        
        let particleNode = SCNNode()
        particleNode.addParticleSystem(particleSystem)
        arView.scene.rootNode.addChildNode(particleNode)
        
        return particleNode
    }
    
    func removeAllParticleNode() {
        arView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.particleSystems != nil {
                node.removeFromParentNode()
            }
        }
    }
}
struct ARViewContainer: UIViewControllerRepresentable {
    let modelPose: HandPoseFive

    func makeUIViewController(context: Context) -> ARViewController {
        let arViewController = ARViewController()
        arViewController.modelPose = modelPose
        return arViewController
    }

    func updateUIViewController(_ uiViewController: ARViewController, context: Context) {
        // اي تحديث بيصير هنا
    }
}

struct newFile: View {
    let modelPose = HandPoseFive()
    
    var body: some View {
        VStack{
            Text("View")
            ARViewContainer(modelPose: modelPose)
        }
    }
}
#Preview {
    newFile()
}
