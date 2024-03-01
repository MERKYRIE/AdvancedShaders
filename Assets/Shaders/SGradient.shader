Shader "Unlit/SGradient"{
    Properties{
        GFirstColor("First color" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GSecondColor("Second color" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GFirstTexture("First texture" , 2D) = "black"
        GSecondTexture("Second texture" , 2D) = "black"
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

            half4 GFirstColor;
            half4 GSecondColor;
            sampler2D GFirstTexture;
            sampler2D GSecondTexture;
            float4 GFirstTexture_ST;
            float4 GSecondTexture_ST;

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
                LVertexToFragment.VTexture.xy = PApplicationToVertex.VTexture.xy * GFirstTexture_ST.xy + GFirstTexture_ST.zw;
                return LVertexToFragment;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                float4 LColor = tex2D(GFirstTexture , PVertexToFragment.VTexture) * tex2D(GSecondTexture , PVertexToFragment.VTexture) * GFirstColor * GSecondColor;
                LColor.a = PVertexToFragment.VTexture.x;
                return LColor;
            }

            ENDCG
        }
    }
}