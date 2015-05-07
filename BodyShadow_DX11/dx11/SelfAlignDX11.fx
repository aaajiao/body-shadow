//@author: vvvv group
//@help: aligns the orientation of a geometry to the camera
//@tags: billboard, view space
//@credits:

// --------------------------------------------------------------------------------------------------
// PARAMETERS:
// --------------------------------------------------------------------------------------------------

//transforms
float4x4 tW: WORLD;        //the models world matrix
float4x4 tV: VIEW;         //view matrix as set via Renderer (EX9)
float4x4 tWV: WORLDVIEW;
float4x4 tWVP: WORLDVIEWPROJECTION;
float4x4 tP: PROJECTION;   //projection matrix as set via Renderer (EX9)

float4x4 tA <string uiname="Second Transform";>;

//alpha
float Alpha <float uimin=0.0; float uimax=1.0;> = 1;

//texture
Texture2D Tex <string uiname="Texture";>;

SamplerState g_samLinear
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Wrap;
	AddressV = Wrap;
};

float4x4 tTex <string uiname="Texture Transform"; bool uvspace=true;>;
float4x4 tColor <string uiname="Color Transform";>;


struct vs2ps
{
    float4 PosWVP: SV_POSITION;
    float4 TexCd : TEXCOORD0;
    float4 NormV: TEXCOORD1;
};

// --------------------------------------------------------------------------------------------------
// VERTEXSHADERS
// --------------------------------------------------------------------------------------------------

vs2ps VS(
    float4 PosO: POSITION,
    float4 NormO: NORMAL,
    float4 TexCd : TEXCOORD0)
{
    //inititalize all fields of output struct with 0
    vs2ps Out = (vs2ps)0;
    
    //normal in view space
    Out.NormV = normalize(mul(NormO, tA));

    //worlsview position
    float4 pos = mul(float4(0, 0, 0, 1), tWV);

    //position (projected)
    Out.PosWVP  = mul(pos + mul(PosO, tA), tP);
    Out.TexCd = mul(TexCd, tTex);
    return Out;
}

// --------------------------------------------------------------------------------------------------
// PIXELSHADERS:
// --------------------------------------------------------------------------------------------------

float4 colore : COLOR = 1;

float4 PS(vs2ps In): SV_Target
{

   // float4 col = tex2D(Samp, In.TexCd);
	float4 col = Tex.SampleLevel( g_samLinear, In.TexCd.xy,1);
    col.a *= Alpha;
  //  return mul(col*colore, tColor);
	return col;
}


// --------------------------------------------------------------------------------------------------
// TECHNIQUES:
// --------------------------------------------------------------------------------------------------

technique10 constant
{
		pass P0
		{
			SetVertexShader( CompileShader( vs_4_0, VS() ) );
			SetPixelShader( CompileShader( ps_4_0, PS() ) );
		}
}
