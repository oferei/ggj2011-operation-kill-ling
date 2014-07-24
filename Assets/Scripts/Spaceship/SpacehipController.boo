import UnityEngine

class SpacehipController (MonoBehaviour): 
	
	public speherMove as SphereMove;
	#~ public energyDisplay as GUIText;
	public speed as single = 1000
	public slowSpeed as single = 250
	public maxEnergy as single = 50
	
	public energy as single
	
	public weapon1EnergyRate = 10;
	public energyRechargeRate = 1;
	
	private beamControl as BeamControl;
	private damageZone as DamageControl;
	private beamSound as AudioSource;
	private shipSound as AudioSource;
	
	def Start ():
		energy = maxEnergy
		beamControl = gameObject.GetComponentsInChildren(BeamControl)[0]
		damageZone = gameObject.GetComponentsInChildren(DamageControl)[0]
		shipSound = gameObject.GetComponentsInChildren(AudioSource)[0]
		beamSound = gameObject.GetComponentsInChildren(AudioSource)[1]
		shipSound.Play()
		beamSound.Stop()
		
	
	def FixedUpdate():
		x = Input.GetAxis("Horizontal")
		y = Input.GetAxis("Vertical")
		direction = Vector3(x,0,y)
		if (direction.sqrMagnitude > 1):
			direction.Normalize()
		#~ speherMove.currentDirection = direction * speed
		if Input.GetMouseButton(0):
			desiredSpeed = slowSpeed
		else:
			desiredSpeed = speed
		speherMove.currentDirection = Vector3.Lerp(speherMove.currentDirection, direction * desiredSpeed, Time.deltaTime * 5)
		
		shipSound.pitch = 1 + direction.sqrMagnitude
		
		if not damageZone.damageActive:
			if (Input.GetMouseButton(0) and energy > 5):
				beamControl.Enable()
				damageZone.damageActive = true
				if (not beamSound.isPlaying):
					beamSound.Play()
		else:
			energy -=  weapon1EnergyRate * Time.deltaTime
			if (not Input.GetMouseButton(0) or energy < 1):
				beamControl.Disable()
				damageZone.damageActive = false
				beamSound.Stop()
		
		energy += energyRechargeRate * Time.deltaTime
		if (energy > maxEnergy) :
			energy = maxEnergy
		if (energy < 0) :
			energy = 0
