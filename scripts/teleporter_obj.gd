extends Area2D

#Variáveis configuráveis
@export_multiline var scene_name: String
@export var door_idx: String

## Quando qualquer corpo entrar na área, a sala muda.
## Configurar para apenas o jogador afetar a área mais tarde.
func _on_body_entered(body: Node2D) -> void:
	#O jogador var ser teleportado para a porta com o identificador DOOR_IDX
	SceneManager.change_to_scene(scene_name, door_idx)
