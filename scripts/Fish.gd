extends CharacterBody2D
class_name Fish

# Balık temel özellikleri
@export var fish_id: String = ""
@export var fish_name: String = ""
@export var fish_size: float = 1.0
@export var fish_speed: float = 100.0
@export var fish_attack: int = 10
@export var fish_defense: int = 5
@export var fish_rarity: String = "common" # common, rare, epic, legendary
@export var fish_health: int = 100
@export var max_health: int = 100

# Evrim ve gelişim
@export var evolution_points: int = 0
@export var experience_points: int = 0
@export var level: int = 1

# Yetenekler
var active_abilities: Array[String] = []
var passive_abilities: Array[String] = []
var max_active_abilities: int = 3
var max_passive_abilities: int = 2

# Görsel bileşenler
@onready var sprite: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Hareket ve AI
var target_position: Vector2
var is_player: bool = false
var ai_state: String = "idle" # idle, hunting, fleeing, attacking

# Savaş değişkenleri
var is_in_combat: bool = false
var last_attacked_time: float = 0.0
var attack_cooldown: float = 1.0

signal fish_died(fish: Fish)
signal fish_evolved(fish: Fish)
signal experience_gained(amount: int)

func _ready():
	# Temel ayarlar
	health_bar.max_value = max_health
	health_bar.value = fish_health
	health_bar.visible = false
	
	# Collision shape ayarla
	setup_collision()
	
	# AI başlat
	if not is_player:
		start_ai()

func _physics_process(delta):
	if is_player:
		handle_player_input()
	else:
		handle_ai_movement(delta)
	
	# Hareket uygula
	move_and_slide()
	
	# Animasyonları güncelle
	update_animations()

func handle_player_input():
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vector.y += 1
	if Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	
	# Normalize ve hız uygula
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * fish_speed
	else:
		velocity = Vector2.ZERO
	
	# Yetenek kullanımı
	handle_ability_input()

func handle_ability_input():
	if Input.is_action_just_pressed("ability_1") and active_abilities.size() > 0:
		use_ability(active_abilities[0])
	elif Input.is_action_just_pressed("ability_2") and active_abilities.size() > 1:
		use_ability(active_abilities[1])
	elif Input.is_action_just_pressed("ability_3") and active_abilities.size() > 2:
		use_ability(active_abilities[2])

func handle_ai_movement(delta):
	match ai_state:
		"idle":
			# Rastgele hareket
			if randf() < 0.01: # %1 ihtimalle yön değiştir
				target_position = global_position + Vector2(randf_range(-100, 100), randf_range(-100, 100))
		"hunting":
			# Hedefi takip et
			if target_position != Vector2.ZERO:
				var direction = (target_position - global_position).normalized()
				velocity = direction * fish_speed
		"fleeing":
			# Hedeften uzaklaş
			if target_position != Vector2.ZERO:
				var direction = (global_position - target_position).normalized()
				velocity = direction * fish_speed * 1.5
		"attacking":
			# Saldırı pozisyonuna git
			if target_position != Vector2.ZERO:
				var direction = (target_position - global_position).normalized()
				velocity = direction * fish_speed

func start_ai():
	# AI davranışını başlat
	ai_state = "idle"
	# Rastgele hedef belirle
	target_position = global_position + Vector2(randf_range(-200, 200), randf_range(-200, 200))

func take_damage(damage: int):
	fish_health -= damage
	health_bar.value = fish_health
	health_bar.visible = true
	
	# Hasar animasyonu
	if animation_player and animation_player.has_animation("hit"):
		animation_player.play("hit")
	
	# Ölüm kontrolü
	if fish_health <= 0:
		die()

func heal(amount: int):
	fish_health = min(fish_health + amount, max_health)
	health_bar.value = fish_health

func gain_experience(amount: int):
	experience_points += amount
	emit_signal("experience_gained", amount)
	
	# Seviye atlama kontrolü
	check_level_up()

func check_level_up():
	var required_xp = level * 100 # Basit XP formülü
	
	if experience_points >= required_xp:
		level_up()

func level_up():
	level += 1
	experience_points -= (level - 1) * 100
	
	# Özellik artışı
	fish_attack += 2
	fish_defense += 1
	max_health += 10
	fish_health = max_health
	
	# Görsel büyüme
	fish_size += 0.1
	scale = Vector2(fish_size, fish_size)
	
	# Evrim puanı
	evolution_points += 1
	
	emit_signal("fish_evolved", self)

func add_active_ability(ability_name: String):
	if active_abilities.size() < max_active_abilities:
		active_abilities.append(ability_name)

func add_passive_ability(ability_name: String):
	if passive_abilities.size() < max_passive_abilities:
		passive_abilities.append(ability_name)

func use_ability(ability_name: String):
	match ability_name:
		"dash":
			ability_dash()
		"cloak":
			ability_cloak()
		"toxic_trail":
			ability_toxic_trail()
		"clone":
			ability_clone()
		"shockwave":
			ability_shockwave()

func ability_dash():
	# Hız patlaması
	fish_speed *= 2.0
	await get_tree().create_timer(2.0).timeout
	fish_speed /= 2.0

func ability_cloak():
	# Görünmezlik
	modulate.a = 0.3
	await get_tree().create_timer(3.0).timeout
	modulate.a = 1.0

func ability_toxic_trail():
	# Zehirli iz (basit implementasyon)
	print("Toxic trail activated!")

func ability_clone():
	# Klon üretimi (basit implementasyon)
	print("Clone created!")

func ability_shockwave():
	# Alan etkili saldırı (basit implementasyon)
	print("Shockwave activated!")

func attack(other_fish: Fish):
	if Time.get_time_dict_from_system()["unix"] - last_attacked_time < attack_cooldown:
		return
	
	last_attacked_time = Time.get_time_dict_from_system()["unix"]
	
	# Saldırı hesaplaması
	var damage = fish_attack - other_fish.fish_defense
	damage = max(damage, 1) # Minimum 1 hasar
	
	other_fish.take_damage(damage)
	
	# Saldırı animasyonu
	if animation_player and animation_player.has_animation("attack"):
		animation_player.play("attack")

func die():
	emit_signal("fish_died", self)
	queue_free()

func setup_collision():
	# Collision shape oluştur
	var collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 20.0 * fish_size
	collision_shape.shape = shape
	add_child(collision_shape)

func update_animations():
	# Hareket animasyonu
	if velocity.length() > 0:
		if animation_player and animation_player.has_animation("swim"):
			animation_player.play("swim")
	else:
		if animation_player and animation_player.has_animation("idle"):
			animation_player.play("idle")

func _on_area_2d_body_entered(body):
	if body is Fish and body != self:
		# Balık çarpışması
		if is_player:
			# Oyuncu saldırıyor
			if fish_size > body.fish_size or fish_attack > body.fish_attack:
				attack(body)
		else:
			# AI saldırıyor
			if fish_size > body.fish_size:
				attack(body)
			elif fish_size < body.fish_size:
				ai_state = "fleeing"
				target_position = body.global_position 