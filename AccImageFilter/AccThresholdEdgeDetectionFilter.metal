//
//  AccThresholdEdgeDetectionFilter.metal
//  MetalAcc
//
//  Created by 王佳玮 on 16/4/5.
//  Copyright © 2016年 JW. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;
kernel void ThresholdEdgeDetection(texture2d<float, access::read> inTexture [[texture(0)]],
                               texture2d<float, access::write> outTexture [[texture(1)]],
                               device unsigned int *threshold [[buffer(0)]],
                               uint2 gid [[thread_position_in_grid]])
{
    const float bottomIntensity = inTexture.read(uint2(gid.x,gid.y-1)).r;
    const float leftIntensity = inTexture.read(uint2(gid.x-1,gid.y)).r;
    const float rightIntensity = inTexture.read(uint2(gid.x+1,gid.y)).r;
    const float topIntensity = inTexture.read(uint2(gid.x,gid.y+1)).r;
    const float centerIntensity = inTexture.read(gid).r;
    
    float h = (centerIntensity - topIntensity) + (bottomIntensity - centerIntensity);
    float v = (centerIntensity - leftIntensity) + (rightIntensity - centerIntensity);

    float mag = length(float2(h, v));
    mag = step(*threshold, mag);
    
    float4 outColor = float4(float3(mag), 1.0);
    outTexture.write(outColor,gid);
}