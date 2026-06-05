#include <metal_stdlib>
using namespace metal;

struct VertexInput {
    float2 position [[attribute(0)]];
    float2 texCoords [[attribute(1)]];
};

struct VertexOutput {
    float4 position [[position]];
    float2 texCoords;
};

vertex VertexOutput starfield_vertex(const VertexInput input [[stage_in]],
                                     unsigned int vid [[vertex_id]]) {
    VertexOutput out;
    out.position = float4(input.position, 0.0, 1.0);
    out.texCoords = input.texCoords;
    return out;
}

// Pseudo-random noise generator
float hash(float2 p) {
    p = frac(p * float2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return frac(p.x * p.y);
}

fragment float4 starfield_fragment(VertexOutput in [[stage_in]],
                                   constant float &time [[buffer(0)]],
                                   constant float2 &resolution [[buffer(1)]]) {
    float2 uv = in.texCoords - 0.5;
    uv.x *= resolution.x / resolution.y;
    
    // Rotate coordinate space over time
    float angle = time * 0.03;
    float s = sin(angle);
    float c = cos(angle);
    uv = float2(uv.x * c - uv.y * s, uv.x * s + uv.y * c);
    
    float color = 0.0;
    
    // Process 3 layers of stars for depth
    for (float i = 0.0; i < 3.0; i++) {
        float2 shift = float2(hash(float2(i, 1.0)), hash(float2(i, 2.0))) * 10.0;
        float2 st = uv * (150.0 + i * 100.0) + shift;
        float2 ipos = floor(st);
        float2 fpos = frac(st);
        
        float n = hash(ipos);
        if (n > 0.98) { // Star density filter
            float twinkle = sin(time * (3.0 + n * 5.0) + n * 100.0) * 0.5 + 0.5;
            float dist = length(fpos - 0.5);
            color += (0.015 / (dist + 0.01)) * twinkle;
        }
    }
    
    // Satellite path orbits overlay
    float orbit = abs(length(uv) - 0.35 + sin(time * 0.8) * 0.01);
    if (orbit < 0.002) {
        color += 0.08 * (1.0 - (orbit / 0.002));
    }
    
    return float4(float3(color), 1.0);
}
