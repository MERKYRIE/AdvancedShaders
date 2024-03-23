Shader "Unlit/SOutline"{
    Properties{
        GColor("Color" , Color) = (0.0 , 0.0 , 0.0 , 0.0)
        GTexture("Texture" , 2D) = ""
        GOutline("Outline" , Float) = 0.0
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

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
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
        Pass{
            Blend SrcAlpha OneMinusSrcAlpha
            Cull front
            Zwrite off

            CGPROGRAM

            #pragma vertex FVertex
            #pragma fragment FFragment

            struct SApplicationToVertex{
                float4 VObject : POSITION;
            };
            struct SVertexToFragment{
                float4 VClip : SV_POSITION;
            };

            float4 GColor;
            float GOutline;

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VClip = UnityObjectToClipPos(PApplicationToVertex.VObject);
                return LVertexToFragment;
            }
            float4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                return GColor;
            }

            ENDCG
        }
    }
}