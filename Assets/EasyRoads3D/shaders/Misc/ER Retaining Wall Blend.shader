// © 2021 EasyRoads3D
// This shader blends two textures with the option to set the the Blend Threshold. It can be used for retaining walls. The first texture displays on the road side. It blends with the wall texture. 

Shader "EasyRoads3D/ER Retaining Wall Blend"
{
	Properties
	{
		[Space]
		[Header(Road Edge)]
		[Space]
		_MainTex("Albedo", 2D) = "white" {}
		_Color0("Color", Color) = (1,1,1,1)
		_Metallic("Metallic (R) AO (G) Smoothness (A)", 2D) = "gray" {}
		_MainMetallicPower4("Metallic Power", Range( 0 , 2)) = 0
		_MainSmoothnessPower4("Smoothness Power", Range( 0 , 2)) = 1
		_OcclusionStrength4("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale1("Normal Map Scale", Range( 0 , 4)) = 1
		[Space]
		[Header(Wall)]
		[Space]
		_Albedo("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_MetallicGlossMap2("Metallic (R) AO (G) Smoothness (A)", 2D) = "gray" {}
		_MainMetallicPower5("Metallic Power", Range( 0 , 2)) = 0
		_MainSmoothnessPower5("Smoothness Power", Range( 0 , 2)) = 1
		_OcclusionStrength5("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_BumpMap2("Normal Map", 2D) = "bump" {}
		_DetailNormalMapScale1("Normal Map Scale", Range( 0 , 4)) = 1
		[Space]
		[Header(Road Edge Wall Blend Threshold)]
		[Space]
		_Threshold("", Range( 0.1 , 1)) = 0.5


		[Space]
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+2450" "IgnoreProjector" = "True" }
		LOD 200
		Cull Back
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform half _BumpScale1;
		uniform sampler2D _BumpMap;
		uniform half _DetailNormalMapScale1;
		uniform sampler2D _BumpMap2;
		uniform float _Threshold;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color0;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Color;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform half _MainMetallicPower4;
		uniform sampler2D _MetallicGlossMap2;
		uniform float4 _MetallicGlossMap2_ST;
		uniform half _MainMetallicPower5;
		uniform half _OcclusionStrength4;
		uniform half _OcclusionStrength5;
		uniform half _MainSmoothnessPower4;
		uniform half _MainSmoothnessPower5;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_22_0 = 1;
			if(i.vertexColor.a < _Threshold){
				temp_output_22_0 = (i.vertexColor.a / _Threshold);
			}
			float3 lerpResult24 = lerp( UnpackScaleNormal( tex2D( _BumpMap, i.uv_texcoord ), _BumpScale1 ) , UnpackScaleNormal( tex2D( _BumpMap2, i.uv_texcoord ), _DetailNormalMapScale1 ) , temp_output_22_0);
			o.Normal = lerpResult24;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			float4 lerpResult16 = lerp( ( tex2DNode1 * _Color0 ) , ( tex2D( _Albedo, uv_Albedo ) * _Color ) , temp_output_22_0);
			o.Albedo = lerpResult16.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode2 = tex2D( _Metallic, uv_Metallic );
			float2 uv_MetallicGlossMap2 = i.uv_texcoord * _MetallicGlossMap2_ST.xy + _MetallicGlossMap2_ST.zw;
			float4 tex2DNode25 = tex2D( _MetallicGlossMap2, uv_MetallicGlossMap2 );
			float lerpResult26 = lerp( ( tex2DNode2.r * _MainMetallicPower4 ) , ( tex2DNode25.r * _MainMetallicPower5 ) , temp_output_22_0);
			o.Metallic = lerpResult26;
			float lerpResult27 = lerp( ( tex2DNode2.a * _OcclusionStrength4 ) , ( tex2DNode25.a * _OcclusionStrength5 ) , temp_output_22_0);
			o.Smoothness = lerpResult27;
			float lerpResult29 = lerp( ( tex2DNode2.g * _MainSmoothnessPower4 ) , ( tex2DNode25.g * _MainSmoothnessPower5 ) , temp_output_22_0);
			o.Occlusion = lerpResult29;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}