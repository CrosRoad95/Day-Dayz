
local texture = dxCreateTexture ("images/aimer.png")
local shader = dxCreateShader ( "shader.fx" )
dxSetShaderValue ( shader, "gTexture", texture )
engineApplyShaderToWorldTexture ( shader, "sitem16")