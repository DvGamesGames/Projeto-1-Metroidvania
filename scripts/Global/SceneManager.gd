extends Node

## Este é o script que controla a transição entre cenas.
## Para criar um script global, crie um script e configure nas configs em 'Autoload'.

#Video sobre Autoloads(gringo): https://www.youtube.com/watch?v=kXSrXjgd3pQ

## Como um script global, ele está presente no jogo em todos os momentos, constantemente.
## Mantenha isso em mente.

var player: PackedScene = load("caminho/para/cena/do/jogador")
var scene_folder_path: String = "res://scenes/"

var current_player


## Efetua a troca de cenas, e spawna o jogador(quando ele existe).
func change_to_scene(to_scene_name, spawn_idx):
	#Pega o nome da sala e coloca no formato aceito pela função, 
	#e depois transforma num objeto tipo 'PackedScene' para conveniencia.
	var full_next_scene_path: String = scene_folder_path + to_scene_name + ".tscn"
	var scene: PackedScene = load(full_next_scene_path)
	
	#Instância a cena para poder acessar suas variáveis relevantes.
	var instance = scene.instantiate()
	
	#Define o spawnpoint onde o jogador irá nascer.
	var spawn_point = instance.spawn_points[spawn_idx]
	
	#Muda para a cena.
	get_tree().change_scene_to_packed(scene)
	
	#Espera a cena ser carregada.
	await get_tree().process_frame
	
	#Cria uma instância do jogador e spawna no spawn_point informado.
	if player:
		spawn_player(spawn_point)
	
	print("Changed scene")

func spawn_player(spawn_point):
	#Caso já exista um jogador, ele é liberto...
	if current_player:
		current_player.queue_free()
	
	#... e outra instância é criada.
	current_player = player.instantiate()
	current_player.global_position = spawn_point
	
	#Espera a cena existir, para evitar erros...
	await get_tree().node_added
	
	#... E então spawna o jogador na cena.
	get_tree().current_scene.add_child(current_player)

## CÓDIGO ABAIXO NÃO É RELACIONADO AO MOVIMENTO ENTRE SALAS.
## ELES SÃO BEM CONVENIENTES, ENTÃO ELES VÃO CONTINUAR AQUI ATÉ SEREM NECESSÁRIOS.

## Configura as coordenadas limite de uma Camera2D. Cameras visualizam apenas o que está dentro dos limites.
func set_camera_anchors(camera: Camera2D, bottom_anchor, top_anchor):
	if camera is not Camera2D:
		return
	
	camera.limit_left = bottom_anchor.position.x
	camera.limit_bottom = bottom_anchor.position.y
	
	camera.limit_right = top_anchor.position.x
	camera.limit_top = top_anchor.position.y

## Apaga os tiles de um retangulo determinado pelas coordenadas 'start' e 'end'.
## Será conveniente em algum momento.
func erase_tiles(tilemap: TileMapLayer, start: Vector2, end: Vector2):
	var idx: Vector2 = start
	
	while(idx.y <= end.y):
		idx.x = start.x
		while(idx.x <= end.x):
			tilemap.erase_cell(idx)
			idx.x += 1
		idx.y += 1
