//
//  SimpleShader.metal
//  Visualizer
//
//  Created by okuyama on 2021/12/16.
//

#include <metal_stdlib>
using namespace metal;


struct ColorInOut{
    float4 position[[position]];
    float2 texCoords;
    float time;
};




vertex ColorInOut vertexShader(constant float4 *positions[[buffer(0)]],
                               constant float2 *texCoords[[buffer(1)]],
                            
                               uint vid         [[vertex_id]]){
    ColorInOut out;
    out.position = positions[vid];
    out.texCoords = texCoords[vid];
    return out;
}

fragment float4 fragmentShader(ColorInOut in [[stage_in]],
                               texture2d<float> texture[[texture(0)]],
                               constant float &time[[buffer(0)]],
                               constant float* amplitudes[[buffer(1)]],
                               constant float* sampleArray[[buffer(2)]]

                               ){
    constexpr sampler colorSampler;
    float2 resolution(780,amplitudes[150]);
    float4 color = texture.sample(colorSampler,in.texCoords);
    
    float arrayNum = 150.0;
    float value =floor(in.texCoords.x*arrayNum)/arrayNum;
    float amplitudeValue = sampleArray[int(value*arrayNum)];
//    amplitudeValue = value;
    //return color;
    return float4(amplitudeValue,amplitudeValue,amplitudeValue,1);
}
