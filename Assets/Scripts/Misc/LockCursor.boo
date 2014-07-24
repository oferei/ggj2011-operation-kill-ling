import UnityEngine

class LockCursor (MonoBehaviour): 
	
	_canQuit as bool
	_texts as (GUIText)
	_mouseCaught = false

	def Start ():
		# Start out in paused mode in web player
		
		Object.DontDestroyOnLoad(gameObject)
		
		_texts = gameObject.GetComponentsInChildren[of GUIText]()
		
		_canQuit = Application.platform not in [
			RuntimePlatform.OSXWebPlayer,
			RuntimePlatform.WindowsWebPlayer,
			RuntimePlatform.WindowsEditor]
		
		SetPause(false)
		Screen.lockCursor = true
	
	def OnEnable ():
		#~ Screen.lockCursor = true
		God.Inst.Hermes.Listen(MessageCaughtMouse, self)
	
	def OnDisable():
		#~ Screen.lockCursor = false
		God.Inst.Hermes.StopListening(MessageCaughtMouse, self)
	
	def OnMsgCaughtMouse(msg as MessageCaughtMouse):
		_mouseCaught = true
	
	def OnApplicationQuit ():
		Time.timeScale = 1

	def SetPause (pause as bool):
		Input.ResetInputAxes()
		gos as (GameObject) = FindObjectsOfType(GameObject)
		for go in gos:
			go.SendMessage("DidPause", pause, SendMessageOptions.DontRequireReceiver)
		
		if pause:
			Time.timeScale = 0
			for text in _texts:
				text.transform.position.x = 0.5
				text.transform.position.y = 0.5
				text.anchor = TextAnchor.MiddleCenter
		else:
			for text in _texts:
				text.anchor = TextAnchor.UpperLeft
				text.transform.position.x = 0
				text.transform.position.y = 1
			Time.timeScale = 1
	
	def DidPause (pause as bool):
		if pause:
			for text in _texts:
				text.text = "PAUSED\nclick to resume"
				if _canQuit:
					text.text += "\nor press X to quit"
				text.fontSize = 40
		else:
			for text in _texts:
				text.text = "Escape to show the cursor"
				text.fontSize = 15

	#~ def OnMouseDown ():
		#~ # Lock the cursor
		#~ Screen.lockCursor = true

	_wasLocked = false

	def Update ():
		if _mouseCaught:
			_mouseCaught = false
		else:
			if Input.GetMouseButtonDown(0):
				Screen.lockCursor = true
		if Input.GetKeyDown(KeyCode.Escape):
			Screen.lockCursor = false
		
		# X to quit
		if Time.timeScale == 0 and _canQuit and Input.GetKeyDown(KeyCode.X):
			Application.Quit()
		
		# Did we lose cursor locking?
		# eg. because the user pressed escape
		# or because he switched to another application
		# or because some script set Screen.lockCursor = false;
		if not Screen.lockCursor and _wasLocked:
			_wasLocked = false
			SetPause(true)
		# Did we gain cursor locking?
		elif Screen.lockCursor and not _wasLocked:
			_wasLocked = true
			SetPause(false)
	  