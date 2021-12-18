//
//  MetalView.swift
//  Visualizer
//
//  Created by okuyama on 2021/12/16.
//

import Foundation
import MetalKit
import SwiftUI

struct MetalView: NSViewRepresentable {
    var amplitudes: [Double]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice() {
            mtkView.device = metalDevice
        }

        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.enableSetNeedsDisplay = true
        mtkView.setNeedsDisplay(NSRect());
        return mtkView
    }
    
    func updateNSView(_ uiView: MTKView, context: NSViewRepresentableContext<MetalView>) {
        context.coordinator.draw(in: uiView);
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var metalDevice: MTLDevice!
        var metalCommandQueue: MTLCommandQueue!
        private let vertexData:[Float] = [
            -1,-1,0,1,
             1,-1,0,1,
             -1,1,0,1,
             1,1,0,1
        ]
        private let textureCoodinateData: [Float] = [0,1,
                                                     1,1,
                                                     0,0,
                                                     1,0];
        
        var vertexBuffer: MTLBuffer!
        var texCoordBuffer: MTLBuffer!
        var resolutionBuffer: MTLBuffer!
        var timeBuffer: MTLBuffer!
        var amplitudesBuffer: MTLBuffer!;
        var sampleArrayBuffer:MTLBuffer!
        var renderPipeline: MTLRenderPipelineState!
        
        
        private var startDate: Date!
        
        private func setupMetal(){
            if let metalDevice = MTLCreateSystemDefaultDevice() {
                self.metalDevice = metalDevice
            }
            self.metalCommandQueue = metalDevice.makeCommandQueue()!
        }
        
        private func makeBuffers(){
            let size = vertexData.count * MemoryLayout<Float>.size
            vertexBuffer = metalDevice.makeBuffer(bytes:vertexData,length:size)
            texCoordBuffer = metalDevice.makeBuffer(bytes:textureCoodinateData, length:textureCoodinateData.count * MemoryLayout<Float>.size)
            
            timeBuffer = metalDevice.makeBuffer(length: MemoryLayout<Float>.size, options: []);
            timeBuffer.label = "time"
            
            amplitudesBuffer = metalDevice.makeBuffer(bytes:parent.amplitudes, length:parent.amplitudes.count*MemoryLayout<Double>.size);
        }
        
        private func makePipeline(){
            let library = metalDevice.makeDefaultLibrary()!;
            let descriptor = MTLRenderPipelineDescriptor()
            descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
            descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
            descriptor.colorAttachments[0].pixelFormat = MTLPixelFormat.bgra8Unorm;

            renderPipeline = try! metalDevice.makeRenderPipelineState(descriptor: descriptor)
        }
        
        
        
        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
            
            setupMetal();
            
            makeBuffers();
            makePipeline();
            
            
            startDate = Date().addingTimeInterval(0);
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        }
        
        func updateTimeBuffer(){
            let pTimeData = timeBuffer.contents()
            let vTimeData = pTimeData.bindMemory(to: Float.self, capacity: 1 / MemoryLayout<Float>.stride)
            vTimeData[0] = Float(Date().timeIntervalSince(startDate));
        }
        
        func updateSampleArrayBuffer(){
            let array = [0.1,0.2,0.3,0.4,0.5,0.6]
            
            var randomElements: [Float] = []
            for _ in 0..<150 {
                let randomValue:Float = Float(array.randomElement()!)
                randomElements.append(randomValue)
            }
            sampleArrayBuffer = metalDevice.makeBuffer(bytes:randomElements,length:randomElements.count * MemoryLayout<Float>.size)
            
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else {
                return
            }
            
            updateSampleArrayBuffer();
            
            let commandBuffer = metalCommandQueue.makeCommandBuffer()!
            
            let renderPassDescriptor = view.currentRenderPassDescriptor!
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
            renderEncoder?.setRenderPipelineState(renderPipeline)
            
            renderEncoder?.setVertexBuffer(vertexBuffer, offset:0,index:0)
            renderEncoder?.setVertexBuffer(texCoordBuffer, offset: 0, index: 1)
            renderEncoder?.setFragmentBuffer(timeBuffer,offset:0,index:0)
            renderEncoder?.setFragmentBuffer(amplitudesBuffer,offset:0,index:1)
            renderEncoder?.setFragmentBuffer(sampleArrayBuffer,offset:0,index:2)
            
            renderEncoder?.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            renderEncoder?.endEncoding()
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
