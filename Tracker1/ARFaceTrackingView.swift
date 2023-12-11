import SwiftUI
import SceneKit
import ARKit
import Combine

class FaceTrackingViewModel: ObservableObject {
  @Published var action = "Waiting..."
}

struct ARFaceTrackingView: UIViewRepresentable {
  class Coordinator: NSObject, ARSCNViewDelegate {
    var parent: ARFaceTrackingView
    
    init(parent: ARFaceTrackingView) {
      self.parent = parent
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      node.geometry?.firstMaterial?.fillMode = .lines
      if let faceAnchor = anchor as? ARFaceAnchor {
        parent.expression(anchor: faceAnchor)
      }
    }
  }
  
  @ObservedObject var viewModel = FaceTrackingViewModel()
  var sceneView = ARSCNView()
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIView(context: Context) -> ARSCNView {
    sceneView.delegate = context.coordinator
    sceneView.showsStatistics = true
    
    guard ARFaceTrackingConfiguration.isSupported else {
      fatalError("Face tracking is not supported on this device")
    }
    
    let configuration = ARFaceTrackingConfiguration()
    sceneView.session.run(configuration)
    
    return sceneView
  }
  
  func updateUIView(_ uiView: ARSCNView, context: Context) {}
  
  func expression(anchor: ARFaceAnchor) {
    let mouthSmileLeft = anchor.blendShapes[.mouthSmileLeft]
    let mouthSmileRight = anchor.blendShapes[.mouthSmileRight]
    let cheekPuff = anchor.blendShapes[.cheekPuff]
    let tongueOut = anchor.blendShapes[.tongueOut]
    let jawLeft = anchor.blendShapes[.jawLeft]
    let eyeSquintLeft = anchor.blendShapes[.eyeSquintLeft]
    
    var action = "Waiting..."
    
    if ((mouthSmileLeft?.decimalValue ?? 0.0) + (mouthSmileRight?.decimalValue ?? 0.0)) > 0.9 {
      action = "You are smiling."
    }
    
    if cheekPuff?.decimalValue ?? 0.0 > 0.1 {
      action = "Your cheeks are puffed."
    }
    
    if tongueOut?.decimalValue ?? 0.0 > 0.1 {
      action = "Don't stick your tongue out!"
    }
    
    if jawLeft?.decimalValue ?? 0.0 > 0.1 {
      action = "You are weird!"
    }
    
    if eyeSquintLeft?.decimalValue ?? 0.0 > 0.1 {
      action = "Are you flirting?"
    }
    
    DispatchQueue.main.async {
      self.viewModel.action = action
    }
  }
}
