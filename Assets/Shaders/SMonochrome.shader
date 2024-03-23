Shader "Unlit/SMonochrome"{
    Properties{
        GColor("Color" , Color) = (1.0 , 0.0 , 0.0 , 1.0)
    }
    SubShader{
        Tags{"RenderType" = "Opaque"}

        Pass{
            CGPROGRAM

            #pragma vertex FVertex
            #pragma fragment FFragment

            #include "UnityCG.cginc"

            struct SApplicationToVertex{
                float4 VVertex : POSITION;
            };
            struct SVertexToFragment{
                float4 VVertex : SV_POSITION;
            };

            fixed4 GColor;

            SVertexToFragment FVertex(SApplicationToVertex PApplicationToVertex){
                SVertexToFragment LVertexToFragment;
                LVertexToFragment.VVertex = UnityObjectToClipPos(PApplicationToVertex.VVertex);
                return LVertexToFragment;
            }
            fixed4 FFragment(SVertexToFragment PVertexToFragment) : SV_Target{
                return GColor;
            }

            ENDCG
        }
    }
}
