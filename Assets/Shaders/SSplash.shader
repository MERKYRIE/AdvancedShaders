Shader "Unlit/SSplash"{
    Properties{
        GFirstColor("FirstColor" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GSecondColor("SecondColor" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GTexture("Texture" , 2D) = ""
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

            half4 GFirstColor;
            half4 GSecondColor;
            sampler2D GTexture;
            float4 GTexture_ST;

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VClip = UnityObjectToClipPos(PApplicationToVertex.VObject);
                LVertexToFragment.VTexture.xy = PApplicationToVertex.VTexture.xy * GTexture_ST.xy + GTexture_ST.zw;
                return LVertexToFragment;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                return tex2D(GTexture , PVertexToFragment.VTexture).g * GFirstColor * tex2D(GTexture , PVertexToFragment.VTexture).g * GSecondColor;
            }

            ENDCG
        }
    }
}