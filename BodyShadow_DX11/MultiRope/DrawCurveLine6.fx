//@author: vux
//@help: standard constant shader
//@tags: color
//@credits: 

float4x4 tV : VIEW;
float4x4 tP : PROJECTION;
float4x4 tVP : VIEWPROJECTION;
float4x4 tWVP : WORLDVIEWPROJECTION;
float4x4 tVI : VIEWINVERSE;
Texture2D texture2d;

float4 c <bool color=true;> = 1;
int amount = 1;
int queueLength = 1;
struct particle
{
	float3 pos;
};
StructuredBuffer<particle> pData;

Texture2D tex_color;

float ropeWidth = 0.05f;

SamplerState g_samLinear : IMMUTABLE
{
    Filter = MIN_MAG_MIP_LINEAR;
    AddressU = Clamp;
    AddressV = Clamp;
};

struct VS_IN
{
	uint iv : SV_VertexID;
	//float4 p: POSITION;	
};

struct vs2ps
{
    float4 PosWVP: SV_POSITION;
	float4 TexCd : TEXCOORD0;
};

float3 g_positions[4]:IMMUTABLE =
    {
        float3( -1, 1, 0 ),
        float3( -1, -1, 0 ),
        float3( 1, 1, 0 ),
        float3( 1, -1, 0 ),
    };
    float2 g_texcoords[4]:IMMUTABLE = 
    { 
    	float2(0,0),
        float2(0,1), 
        float2(1,0),
        float2(1,1),
    };

vs2ps VS(VS_IN input)
{
    //inititalize all fields of output struct with 0
    vs2ps Out = (vs2ps)0;
    Out.PosWVP = input.iv;
    return Out;
}

[maxvertexcount(6)]
void GS(point vs2ps input[1], inout TriangleStream<vs2ps> SpriteStream)
{
    vs2ps output;
    //
    // Emit rope
    //
	uint base_index =(int)input[0].PosWVP.x;
	uint index_y = fmod(base_index, amount);
	uint index_x = floor(base_index / amount);
	
	uint index = index_x * amount + index_y;
	
	float2 tex = float2((float)index_y/(float)amount, (float)index_x/(float)(queueLength-1));

	float3 position;
	float3 direction = 0;

	if(queueLength > 0 && queueLength != 1)
	{
		float w = ropeWidth;
		float4 p, p1, p2;
		float4 tangent;
		float2 normal;
		float2 off;
		float4 ltPt, rtPt, rbPt, lbPt;
	    	
    	if(index_x == 0)
    	{
    		p1 = mul(float4(pData[index].pos, 1), tWVP);
    		p2 = mul(float4(pData[index+amount].pos, 1), tWVP);
    	}
    	else
    	{
    		p1 = mul(float4(pData[index-amount].pos, 1), tWVP);
    		p2 = mul(float4(pData[index].pos, 1), tWVP);
    	}
    	p = p1;
		p1 /= p1.w;
    	p2 /= p2.w;
    	tangent = p2 - p1;
    	normal = normalize(float2(tangent.y, -tangent.x));
    	off = normal * w;
		off *= mul(float4(1, 1, 0, 0), tP).xy;
		
		//ltPt
		output.PosWVP = p1 + float4(off*p1.w,0,0);
        output.TexCd.xy = float2((float)index_x / (float)(queueLength-1), 0);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
		
		//rtPt
		output.PosWVP = p2 + float4(off*p2.w,0,0);
        output.TexCd.xy = float2((float)(index_x) / (float)(queueLength-1), 0);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
		
		//rbPt
		output.PosWVP = p2 - float4(off*p2.w,0,0);
        output.TexCd.xy = float2((float)(index_x) / (float)(queueLength-1), 1);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
		
		//rbPt
		output.PosWVP = p2 - float4(off*p2.w,0,0);
        output.TexCd.xy = float2((float)(index_x) / (float)(queueLength-1), 1);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
		
		//lbPt
		output.PosWVP = p1 - float4(off*p1.w,0,0);
        output.TexCd.xy = float2((float)(index_x) / (float)(queueLength-1), 1);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
		
		//ltPt
		output.PosWVP = p1 + float4(off*p1.w,0,0);
        output.TexCd.xy = float2((float)index_x / (float)(queueLength-1), 0);
		output.TexCd.zw = tex;
    	SpriteStream.Append(output);
	}
	else
	{
		for(int i=0; i<4; i++)
	    {
	    	position = pData[index].pos + g_positions[i]*ropeWidth;	     
	        output.PosWVP = mul( float4(position,1.0), tVP );
	        output.TexCd.xy = g_texcoords[i];	
	    	output.TexCd.zw = float2((float)index_y/(float)amount, (float)index_x/(float)(queueLength-1));
	        SpriteStream.Append(output);
	    }
	}
    SpriteStream.RestartStrip();
}


float4 PS_Tex(vs2ps In): SV_Target
{
	float4 col1 = texture2d.Sample( g_samLinear, In.TexCd.xy);
    float4 col2 = tex_color.Sample(g_samLinear, In.TexCd.zw);
	float4 col = col1 * col2 * c;
    return col;
}


technique10 Constant
{
	pass P0
	{
		
		SetVertexShader( CompileShader( vs_4_0, VS() ) );
		SetGeometryShader( CompileShader( gs_4_0, GS() ) );
		SetPixelShader( CompileShader( ps_4_0, PS_Tex() ) );
	}
}




