import UnityEngine

class Starter (MonoBehaviour):
	
	public images as (Texture)
	
	_index as int = 0

	def Start ():
		show(0)
	
	def show(index as int):
		if index >= len(images):
			end()
		else:
			guiTexture.texture = images[index]
		
	def end():
		Application.LoadLevel("play")

	def Update ():
		if Time.timeScale == 0:
			return
		if Input.GetMouseButtonDown(0) or Input.GetKeyDown("space"):
			_index += 1
			show(_index)
