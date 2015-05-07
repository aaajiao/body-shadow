int amount = 1;
int queueLength = 1;
StructuredBuffer<float3> path;

bool reset;
bool insert;
StructuredBuffer<float3> resetPos;

struct particle
{
	float3 pos;
};
RWStructuredBuffer<particle> Output : BACKBUFFER;



//==============================================================================
//COMPUTE SHADER ===============================================================
//==============================================================================

[numthreads(1, 1, 1)]
void CSConstantForce( uint3 DTid : SV_DispatchThreadID )
{
	int index;
	if(reset)
	{
		for(int i=0; i<queueLength; i++)
		{
			index = i*amount+DTid.x;
			Output[index].pos = resetPos[DTid.x];
		}
	}
	else
	{
		if(insert)
		{
			for(int j=queueLength-1; j>0; j--)
			{
				index = j*amount + DTid.x;
				Output[index].pos = Output[index-amount].pos;
			}
			uint count,dummy;
			path.GetDimensions(count,dummy);
			Output[DTid.x].pos = path[DTid.x%count];
		}
	}
}

//==============================================================================
//TECHNIQUES ===================================================================
//==============================================================================

technique11 MainLoop
{
	pass P0
	{
		SetComputeShader( CompileShader( cs_5_0, CSConstantForce() ) );
	}
}
