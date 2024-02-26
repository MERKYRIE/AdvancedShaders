Shader "Unlit/SSinus"{
    Properties{
        GColor("Color" , Color) = (1.0 , 1.0 , 1.0 , 1.0)
        GTexture("Texture" , 2D) = "white"{}
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

            half4 GColor;
            sampler2D GTexture;
            float4 GTexture_ST;

            struct SApplicationToVertex{
                float4 VObject : POSITION;
                float4 VTexture : TEXCOORD0;
            };
            struct SVertexToFragment{
                float4 VClip : SV_POSITION;
                float4 VTexture : TEXCOORD0;
            };

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VClip = UnityObjectToClipPos(PApplicationToVertex.VObject);
                LVertexToFragment.VTexture.xy = PApplicationToVertex.VTexture.xy * GTexture_ST.xy + GTexture_ST.zw;
                return LVertexToFragment;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                float4 LColor = tex2D(GTexture , PVertexToFragment.VTexture) * GColor;
                LColor.a = sin(PVertexToFragment.VTexture.x * 20.0);
                return LColor;
            }

            ENDCG
        }
    }
}
