// ﻿Shader "Unlit/PopShader"
// {
//     Properties
//     {
//         _Color ("Color", Color) = (1,1,1,0)
//         _AmbiColor ("AmbiColor", Color) = (1,1,1,0)
//         // _MainTex ("Texture", 2D) = "white" {}
//     }
//     SubShader
//     {
//         Tags { "RenderType"="Opaque" }
//         // LOD 100
//
//         Pass
//         {
//             CGPROGRAM
//             #pragma vertex vert
//             #pragma fragment frag
//             // make fog work
//             // #pragma multi_compile_fog
//
//             #include "UnityCG.cginc"
//             #include "Lighting.cginc"
//             #include "AutoLight.cginc"
//
//             // struct appdata
//             // {
//             //     float4 vertex : POSITION;
//             //     float2 uv : TEXCOORD0;
//             // };
//
//             struct VertexInput {
//                 float4 vertex : POSITION;
//                 float3 normal : NORMAL;
//                 float2 uv0 : TEXCOORD0;
//             };
//
//             // struct v2f
//             // {
//             //     float2 uv : TEXCOORD0;
//             //     UNITY_FOG_COORDS(1)
//             //     float4 vertex : SV_POSITION;
//             // };
//             struct VertexOutput {
//                 float4 clipSpacePos : SV_POSITION;
//                 float2 uv0 : TEXCOORD0;
//                 float3 normal : TEXCOORD1;
//                 float3 worldPos : TEXCOORD2;
//             };
//
//             // sampler2D _MainTex;
//             float4 _MainTex_ST;
//
//             VertexOutput vert (VertexInput v)
//             {
//                 // v2f o;
//                 // o.vertex = UnityObjectToClipPos(v.vertex);
//                 // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
//                 // UNITY_TRANSFER_FOG(o,o.vertex);
//                 // return o;
//                 VertexOutput o;
//                 o.uv0 = v.uv0;
//                 o.normal = v.normal;
//                 o.worldPos = mul (unity_ObjectToWorld, v.vertex);
//                 o.clipSpacePos = UnityObjectToClipPos (v.vertex);
//                 return o;
//             }
//
//             float4 _Color;
//             float4 _AmbiColor;
//
//             fixed4 frag (VertexOutput o) : SV_Target
//             {
//                 float3 normal = normalize(o.normal);
//                 float3 lightColor = _LightColor0.rgb;
//                 float3 lightDir = _WorldSpaceLightPos0.xyz;
//                 float  lightFalloff = max(0, dot(lightDir, normal));
//                 //lightFalloff = step(0.5, lightFalloff);
//                 float3 dirdiff = lightColor * lightFalloff;
//                 //return lightFalloff;
//
//                 float3 camPos = _WorldSpaceCameraPos;
//                 float3 frag = camPos - o.worldPos;
//                 float3 viewDir = normalize (frag );
//                 float3 viewReflect = reflect(-viewDir, normal);
//                 float specFalloff = max(0, dot(viewReflect, lightDir));
//                 //specFalloff = pow (specFalloff, 1); // gloss;
//                 specFalloff = step (0.1, specFalloff);
//                 float3 dirSpec = specFalloff * lightColor;
//                 return (dirSpec + _Color.rgb * dirdiff, 0);
//                 // // sample the texture
//                 // fixed4 col = tex2D(_MainTex, i.uv);
//                 // // apply fog
//                 // UNITY_APPLY_FOG(i.fogCoord, col);
//                 // return col;
//             }
//             ENDCG
//         }
//     }
// }
Shader "Unlit/DirectionalCelColoring"
{
    Properties
    {
        _LightColor("Light Color", Color) = (1,1,1,1)
        _MiddleColor("Middle Color", Color) = (1,1,1,1)
        _DarkColor("Dark Color", Color) = (1,1,1,1)
        _Threshold1("Threshold 1", Range(0, 1)) = 0.33
        _Threshold2("Threshold 2", Range(0, 1)) = 0.66
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float lightDot : TEXCOORD0;
            };


            fixed4 _LightColor;
            fixed4 _MiddleColor;
            fixed4 _DarkColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                half3 normal = normalize(mul(unity_ObjectToWorld, half4(v.normal, 0))).xyz;
                half lightDot = clamp(dot(normal, normalize(_WorldSpaceLightPos0)), -1.0, 1.0);
                o.lightDot = (lightDot + 1) / 2;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float _Threshold1;
            float _Threshold2;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                if (i.lightDot > 0 && i.lightDot < _Threshold1) col = _LightColor;
                else if (i.lightDot > _Threshold1 && i.lightDot < _Threshold2) col = _MiddleColor;
                else col = _DarkColor;
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
