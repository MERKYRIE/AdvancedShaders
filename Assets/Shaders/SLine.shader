Shader "Unlit/SLine"{
    Properties{
        GColor("Color" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GTexture("Texture" , 2D) = ""
        GStart("Start" , Float) = 0.0
        GWidth("Width" , Float) = 0.0
        GAmount("Amount" , Integer) = 0
    }
    SubShader{
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        Pass{
            Blend SrcAlpha OneMinusSrcAlpha
            
            CGPROGRAM

            #pragma vertex FVertex
            #pragma fragment FFragment

            struct SApplicationToVertex{
                float4 VObject : POSITION;
                float4 VTexture : TEXCOORD0;
            };
            struct SVertexToFragment{
                float4 VClip : SV_POSITION;
                float4 VTexture : TEXCOORD0;
            };

            half4 GColor;
            sampler2D GTexture;
            float4 GTexture_ST;
            float GStart;
            float GWidth;
            int GAmount;

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VClip = UnityObjectToClipPos(PApplicationToVertex.VObject);
                LVertexToFragment.VTexture.xy = PApplicationToVertex.VTexture.xy * GTexture_ST.xy + GTexture_ST.zw;
                return LVertexToFragment;
            }
            float FLine(float2 PTexture , float PBegin , float PEnd){
                return PBegin < PTexture.x && PTexture.x < PEnd;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                float4 LColor = tex2D(GTexture , PVertexToFragment.VTexture) * GColor;
                for(int LLine = 0 ; LLine <= GAmount - 1 ; LLine++){
                    LColor.a = FLine(PVertexToFragment.VTexture , GStart + LLine * 2 * GWidth , GStart + (LLine + 1) * 2 * GWidth);
                    if(LColor.a){
                        return LColor;
                    }
                }
                return LColor;
            }

            ENDCG
        }
    }
}