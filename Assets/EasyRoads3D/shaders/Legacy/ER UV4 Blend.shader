// © 2021 EasyRoads3D
// This shader blends two textures by vertex color. The second map is UV4 generated.

Shader "EasyRoads3D/Misc/ER UV4 Blend"
{
	Properties
	{
		[Space]
		[Header(Main Maps)]
		[Space]
		_MainTex("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Metallic("Metallic (R) AO (G) Smoothness (A)", 2D) = "gray" {}
		_MetallicPower("Metallic Power", Range( 0 , 2)) = 0
		_SmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		_OcclusionStrength("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Map Scale", Range( 0 , 4)) = 1
		[Space]
		[Space]
		[Header(Secondary Maps)]
		[Space]
		_Albedo("Albedo", 2D) = "white" {}
		_Color0("Color", Color) = (1,1,1,1)
		_MetallicGlossMap2("Metallic (R) AO (G) Smoothness (A)", 2D) = "gray" {}
		_Float0("Metallic Power", Range( 0 , 2)) = 0
		_Float1("Smoothness Power", Range( 0 , 2)) = 1
		_AmbientOcclusionPower("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_DetailNormalMapScale("Normal Map", 2D) = "bump" {}
		_BumpScale1("Normal Map Scale", Range( 0 , 4)) = 1

		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+2450" "IgnoreProjector" = "True" }
		LOD 200
		Cull Back
		Offset  [_OffsetFactor] , [_OffsetUnit]
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
		};

		uniform half _BumpScale;
		uniform sampler2D _BumpMap;
		uniform half _BumpScale1;
		uniform sampler2D _DetailNormalMapScale;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _Albedo;
		uniform float4 _Color0;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform half _MetallicPower;
		uniform sampler2D _MetallicGlossMap2;
		uniform half _Float0;
		uniform half _SmoothnessPower;
		uniform half _Float1;
		uniform half _OcclusionStrength;
		uniform half _AmbientOcclusionPower;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 lerpResult24 = lerp( UnpackScaleNormal( tex2D( _BumpMap, i.uv_texcoord ), _BumpScale ) , UnpackScaleNormal( tex2D( _DetailNormalMapScale, i.uv4_texcoord4 ), _BumpScale1 ) , i.vertexColor.a);
			o.Normal = lerpResult24;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float4 lerpResult16 = lerp( ( tex2DNode1 * _Color ) , ( tex2D( _Albedo, i.uv4_texcoord4 ) * _Color0 ) , i.vertexColor.a);
			o.Albedo = lerpResult16.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode2 = tex2D( _Metallic, uv_Metallic );
			float4 tex2DNode25 = tex2D( _MetallicGlossMap2, i.uv4_texcoord4 );
			float lerpResult26 = lerp( ( tex2DNode2.r * _MetallicPower ) , ( tex2DNode25.r * _Float0 ) , i.vertexColor.a);
			o.Metallic = lerpResult26;
			float lerpResult27 = lerp( ( tex2DNode2.a * _SmoothnessPower ) , ( tex2DNode25.a * _Float1 ) , i.vertexColor.a);
			o.Smoothness = lerpResult27;
			float lerpResult29 = lerp( ( tex2DNode2.g * _OcclusionStrength ) , ( tex2DNode25.g * _AmbientOcclusionPower ) , i.vertexColor.a);
			o.Occlusion = lerpResult29;
			o.Alpha = tex2DNode1.a;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows exclude_path:deferred 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv4_texcoord4;
				o.customPack1.zw = v.texcoord3;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv4_texcoord4 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	
}