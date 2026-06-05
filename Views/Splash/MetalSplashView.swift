import SwiftUI
import MetalKit

struct MetalSplashView: UIViewRepresentable {
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.delegate = context.coordinator
        mtkView.backgroundColor = .clear
        mtkView.isOpaque = false
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.framebufferOnly = true
        mtkView.preferredFramesPerSecond = 60
        
        context.coordinator.setupPipeline(mtkView: mtkView)
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var device: MTLDevice?
        var commandQueue: MTLCommandQueue?
        var pipelineState: MTLRenderPipelineState?
        var vertexBuffer: MTLBuffer?
        var startTime: Date = Date()
        
        // Full screen quad geometry offsets
        let vertices: [Float] = [
            -1.0, -1.0,  0.0, 0.0,
             1.0, -1.0,  1.0, 0.0,
            -1.0,  1.0,  0.0, 1.0,
             1.0,  1.0,  1.0, 1.0
        ]
        
        func setupPipeline(mtkView: MTKView) {
            self.device = mtkView.device
            self.commandQueue = device?.makeCommandQueue()
            
            // Build full screen quad vertex buffer
            let vertexSize = vertices.count * MemoryLayout<Float>.size
            vertexBuffer = device?.makeBuffer(bytes: vertices, length: vertexSize, options: [])
            
            guard let device = device else { return }
            
            // Compile Metal shaders
            let defaultLibrary = device.makeDefaultLibrary()
            let vertexFunc = defaultLibrary?.makeFunction(name: "starfield_vertex")
            let fragmentFunc = defaultLibrary?.makeFunction(name: "starfield_fragment")
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunc
            pipelineDescriptor.fragmentFunction = fragmentFunc
            pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
            
            // Support transparency
            pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
            pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .zero
            
            do {
                pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            } catch {
                print("Failed to compile Metal starfield pipeline state: \(error)")
            }
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor,
                  let pipelineState = pipelineState,
                  let vertexBuffer = vertexBuffer else { return }
            
            guard let commandBuffer = commandQueue?.makeCommandBuffer(),
                  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            
            renderEncoder.setRenderPipelineState(pipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            
            // Pass parameters (time delta & screen resolution size)
            var timeVal = Float(Date().timeIntervalSince(startTime))
            var resolution = simd_make_float2(Float(view.bounds.width), Float(view.bounds.height))
            
            renderEncoder.setFragmentBytes(&timeVal, length: MemoryLayout<Float>.size, index: 0)
            renderEncoder.setFragmentBytes(&resolution, length: MemoryLayout<simd_float2>.size, index: 1)
            
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder.endEncoding()
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
