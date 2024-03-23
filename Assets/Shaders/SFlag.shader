Shader "Unlit/SFlag"{
    Properties{
        GTexture("Texture" , 2D) = ""
        GSpeed("Speed" , Float) = 0.0
        GFrequency("Frequency" , Float) = 0.0
        GAmplitude("Amplitude" , Float) = 0.0
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

            sampler2D GTexture;
            float4 GTexture_ST;
            float GSpeed;
            float GFrequency;
            float GAmplitude;

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                PApplicationToVertex.VObject.z = PApplicationToVertex.VObject.z + sin((PApplicationToVertex.VTexture.x - _Time.y * GSpeed) * GFrequency) * GAmplitude;
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VClip = UnityObjectToClipPos(PApplicationToVertex.VObject);
                LVertexToFragment.VTexture.xy = PApplicationToVertex.VTexture.xy * GTexture_ST.xy + GTexture_ST.zw;
                return LVertexToFragment;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                return tex2D(GTexture , PVertexToFragment.VTexture);
            }

            ENDCG
        }
    }
}