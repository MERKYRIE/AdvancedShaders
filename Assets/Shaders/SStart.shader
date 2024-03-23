Shader "Unlit/SStart"{
    Properties{
        GColor("Color" , Color) = (1.0 , 1.0 , 1.0 , 1.0)
    }
    SubShader{
        Tags{
            "Queue" = "Transparent"
            "RenderType" = "Transparent"
            "IgnoreProjector" = "True"
        }
        Pass{
            CGPROGRAM

            #pragma vertex FVertex
            #pragma fragment FFragment

            half4 GColor;

            struct SApplicationToVertex{
                float4 VVertex : POSITION;
            };
            struct SVertexToFragment{
                float4 VPosition : SV_POSITION;
            };

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VPosition = UnityObjectToClipPos(PApplicationToVertex.VVertex);
                return LVertexToFragment;
            }
            half4 FFragment(SVertexToFragment PVertexToFragment) : COLOR{
                return GColor;
            }

            ENDCG
        }
    }
}
