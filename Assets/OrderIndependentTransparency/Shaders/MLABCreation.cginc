#ifndef OIT_MLAB_INCLUDED
#define OIT_MLAB_INCLUDED

#include "UnityCG.cginc"
#include "OitUtils.cginc"
#define MAX_SORTED_PIXELS 8

struct FragmentBuffer_STRUCT
{
    uint pixelColor;
    uint uDepthCoverage;
};

RasterizerOrderedStructuredBuffer<FragmentBuffer_STRUCT> FragmentBuffer : register(u1);
RasterizerOrderedTexture2D<uint> ClearMask : register(u2);

void createFragmentEntry(float4 col, float3 pos, uint uCoverage) {
    //Retrieve current Pixel count and increase counter
    uint uPixelCount = FragmentBuffer.IncrementCounter();

    //calculate bufferAddress
    uint uStartOffsetAddress = _ScreenParams.x * (pos.y - 0.5) + (pos.x - 0.5);

    //create new Fragment
    FragmentBuffer_STRUCT Element;
    Element.pixelColor = PackRGBA(col);
    Element.uDepthCoverage = PackDepthCoverage(Linear01Depth(pos.z), uCoverage);

    // if (ClearMask[pos.xy] == 0) {
        FragmentBuffer[uStartOffsetAddress] = Element;
        ClearMask[pos.xy] = 1;
    // } else {
    //     //Sort pixels in depth
    //     //with insertion sort
    //     FragmentBuffer_STRUCT temp, merge;
    //     for (int i = 0; i < MAX_SORTED_PIXELS; i++)
    //     {
    //         if (Linear01Depth(pos.z) > UnpackDepth(FragmentBuffer[uStartOffsetAddress + i].uDepthCoverage))
    //         {
    //             FragmentBuffer_STRUCT temp = FragmentBuffer[uStartOffsetAddress + i];
    //             FragmentBuffer[uStartOffsetAddress + i] = Element;
    //             Element = temp;
    //         }
    //     }
    // //TODO: merge
    // }

}

#endif // OIT_MLAB_INCLUDED