extends CharacterBody2D

var jumping_allowed = false

var speed = 450
var jump_force = 700
var gravity = 40
var coyote_time = 0.4

@onready var c_timer: Timer = $Misc/CTimer

func _physics_process(_delta: float) -> void:
	#Captura o vetor de movimento do jogador
	var h_movement = Input.get_axis("move_left", "move_right")
	#Aplica a velocidade na direção pressionada
	velocity.x = h_movement * speed 
	
	#Checa se o jogador NÃO está no chão
	if not is_on_floor():
		#Se ele não está, mas acabou de sair do chão - por uma pequena 
		#janela de tempo ele ainda pode pular(Coyote Time)
		if jumping_allowed:
			if c_timer.is_stopped():
				c_timer.start(coyote_time)
		
		#Caso a velocidade vertical do jogador seja menor que 1250, 
		#a gravidade puxa ele pra baixo e continua aumentando até atingir o limite(1250).
		if velocity.y < 1250:
			velocity.y += gravity
		else:
			velocity.y = 1250
	else:
		#Agora, se o jogador ESTÁ no chão ele pode pular.
		jumping_allowed = true
	
	#Se você apertar o botão "jump"(setado nas configs por mim), e o jogador puder pular,
	#a jump_force negativa é aplicada, pois no Godot números negativos vão pra cima no mundo. 
	if Input.is_action_just_pressed("jump") and jumping_allowed:
		velocity.y = jump_force * (-1)
		jumping_allowed = false
	
	#Função que permite o jogador se mover.
	move_and_slide()

func _on_c_timer_timeout() -> void:
	jumping_allowed = false
