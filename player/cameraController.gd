extends Camera2D

var zoomSpeed = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func adjustZoom(delta, newZoomLevel : Vector2):
	zoom = lerp(zoom, newZoomLevel, zoomSpeed * delta)
