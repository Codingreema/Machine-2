////
////  ML.swift
////  Machine
////
////  Created by Rimah on 07/07/1445 AH.
////
//import SwiftUI
//import ARKit
//import CoreML
//
//struct ML: View {
//    @State private var isARSessionActive = false
//    
//    var body: some View {
//        VStack {
//            ARViewContainer()
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//    
//    
//  
//    
//    struct ARViewContainer: UIViewRepresentable {
//        func makeUIView(context: Context) -> ARSCNView {
//            let arView = ARSCNView(frame: .zero)
//            arView.automaticallyUpdatesLighting = true
//            arView.session = ARSession()
//           
//            return arView
//        }
//        
//        func updateUIView(_ uiView: ARSCNView, context: Context) {}
//    }
//}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ML()
//    }
//}
