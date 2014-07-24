import UnityEngine

class BeamControl (MonoBehaviour): 
	
	public animationDelay as single = 5
	public transparency1 as single = 0.2
	public transparency2 as single = 0.6
	
	private renderers as (MeshRenderer)
	private enable as bool
	private currentFrame as int
	private timeOnLastFrame as single
	
	
	def Start ():
		renderers = gameObject.GetComponentsInChildren[of MeshRenderer]()
		
		shader as Shader = Shader.Find('Transparent/Diffuse')
		
		i = 0
		for renderer as MeshRenderer in renderers:
			i++
			renderer.enabled = false
			renderer.material.shader = shader;
			prevColor as Color = renderer.material.color
			tr as single = transparency1
			if (i % 2 == 0):
				tr = transparency2
			renderer.material.color = Color(prevColor.r, prevColor.g, prevColor.b, tr)
			
		currentFrame = 0
		#Enable()
	
	def FixedUpdate ():
		if not enable:
			renderers[currentFrame].enabled = false
			renderers[currentFrame+1].enabled = false
			return
		
		renderers[currentFrame].enabled = true
		if ((Time.time - timeOnLastFrame) > animationDelay * 0.01):
			#Debug.Log("${(Time.time - timeOnLastFrame)}")
			nextFrame as int = currentFrame + 2
			if (nextFrame >= renderers.Length):
				nextFrame = 0
			
			renderers[nextFrame].enabled = true
			renderers[nextFrame+1].enabled = true			
			renderers[currentFrame].enabled = false
			renderers[currentFrame+1].enabled = false
			currentFrame = nextFrame
			timeOnLastFrame = Time.time
		
	
	def Enable():
		enable = true
		
	def Disable():
		renderers[currentFrame].enabled = false
		renderers[currentFrame+1].enabled = false
		enable = false
		currentFrame = 0
		