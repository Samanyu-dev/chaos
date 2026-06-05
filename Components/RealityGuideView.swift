import SwiftUI
import RealityKit

struct RealityGuideView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Attempt to load the Tripo AI generated guide model USDZ asset
        if let modelEntity = try? Entity.loadModel(named: "guide_astronaut") {
            let anchor = AnchorEntity()
            anchor.addChild(modelEntity)
            arView.scene.addAnchor(anchor)
        } else {
            // Procedural fallback: a glowing metallic space sphere representing Orbit Guide
            let mesh = MeshResource.generateSphere(radius: 0.15)
            let material = SimpleMaterial(color: .cyan, isMetallic: true)
            let modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            let anchor = AnchorEntity()
            anchor.addChild(modelEntity)
            arView.scene.addAnchor(anchor)
            
            // Subtle breathing coordinate scaling animation loop
            Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                let time = Float(Date().timeIntervalSinceReferenceDate)
                let scaleVal = 1.0 + sin(time * 3.0) * 0.08
                modelEntity.scale = simd_make_float3(scaleVal, scaleVal, scaleVal)
                
                // Orbit rotation
                modelEntity.transform.rotation = simd_quatf(angle: time * 0.5, axis: simd_make_float3(0, 1, 0))
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
