// © 2021 EasyRoads3D
// This shader can be used for tunnels to blend the tunnel texture with the terrain. This requires vertex color info on the generated tunnel side object. Red represents the part of the mesh that should blend with the matching terrain layer.  
// Usage: Assign the same  terrain layer albedo map to the Terrain Layer Tiling Albedo Map and set the tiling to the terrain size divided by the Tiling Size value of the specific Terrain Layer

Shader "EasyRoads3D/Misc/ER Terrain Tunnel Blend"
{
	Properties
	{
		[Space]
		[Header(Terrain Layer Maps)]
		[Space]
		_MainTex("Albedo", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Metallic("Metallic (R) AO (G) Smoothness (A)", 2D) = "gray" {}
		_MainMetallicPower("Metallic Power", Range( 0 , 2)) = 0
		_MainSmoothnessPower("Smoothness Power", Range( 0 , 2)) = 1
		_OcclusionStrength("Ambient Occlusion Power", Range( 0 , 2)) = 1
		_BumpMap("Normal Map", 2D) = "bump" {}
		_BumpScale("Normal Map Scale", Range( 0 , 4)) = 1
		[Space]
		[Space]
		[Header(Terrain Layer Tiling)]
		[Space]
		_DetailAlbedoMap("Albedo", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _texcoord4( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+2450" "IgnoreProjector" = "True" }
		LOD 200
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
			float2 uv4_texcoord4;
			float4 vertexColor : COLOR;
		};

		uniform half _BumpScale;
		uniform sampler2D _BumpMap;
		uniform sampler2D _DetailAlbedoMap;
		uniform float4 _DetailAlbedoMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform sampler2D _Metallic;
		uniform float4 _Metallic_ST;
		uniform half _MainMetallicPower;
		uniform half _MainSmoothnessPower;
		uniform half _OcclusionStrength;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv3_DetailAlbedoMap = i.uv4_texcoord4 * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
			float3 tex2DNode36 = UnpackScaleNormal( tex2D( _BumpMap, uv3_DetailAlbedoMap ), _BumpScale );
			float3 lerpResult42 = lerp( UnpackScaleNormal( tex2D( _BumpMap, i.uv_texcoord ), _BumpScale ) , tex2DNode36 , i.vertexColor.r);
			o.Normal = lerpResult42;
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 lerpResult41 = lerp( ( tex2D( _MainTex, uv_MainTex ) * _Color ) , ( tex2D( _DetailAlbedoMap, uv3_DetailAlbedoMap ) * _Color ) , i.vertexColor.r);
			o.Albedo = lerpResult41.rgb;
			float2 uv_Metallic = i.uv_texcoord * _Metallic_ST.xy + _Metallic_ST.zw;
			float4 tex2DNode23 = tex2D( _Metallic, uv_Metallic );
			o.Metallic = ( tex2DNode23.r * _MainMetallicPower );
			o.Smoothness = ( tex2DNode23.a * _MainSmoothnessPower );
			o.Occlusion = ( tex2DNode23.g * _OcclusionStrength );
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	
}




