extends Fish
class_name Player

# Oyuncu özel özellikleri
@export var player_name: String = "Oyuncu"
@export var save_data: Dictionary = {}

# UI bileşenleri
@onready var ui_manager: UIManager = get_node("/root/GameManager/UIManager")
@onready var camera: Camera2D = $Camera2D

# Oyun durumu
var game_started: bool = false
var total_fish_eaten: int = 0
var total_evolution_points: int = 0

# Yetenek cooldown'ları
var ability_cooldowns: Dictionary = {}
var cooldown_timers: Dictionary = {}

func _ready():
	super._ready()
	
	# Oyuncu ayarları
	is_player = true
	fish_name = "Küçük Balık"
	fish_id = "player_fish"
	
	# Başlangıç özellikleri
	fish_size = 0.8
	fish_speed = 120.0
	fish_attack = 8
	fish_defense = 3
	fish_health = 80
	max_health = 80
	
	# Kamera ayarları
	if camera:
		camera.enabled = true
		camera.make_current()
	
	# UI bağlantıları
	connect("fish_evolved", Callable(self, "_on_fish_evolved"))
	connect("experience_gained", Callable(self, "_on_experience_gained"))
	
	# Oyuncu sprite'ını ayarla
	setup_player_sprite()
	
	# Oyunu başlat
	game_started = true

func setup_player_sprite():
	var sprite = get_node("Sprite2D")
	if sprite:
		var texture = load("res://assets/sprites/fish_simple.svg")
		if texture:
			sprite.texture = texture
			sprite.scale = Vector2(fish_size, fish_size)

func _physics_process(delta):
	super._physics_process(delta)
	
	# Cooldown'ları güncelle
	update_cooldowns(delta)
	
	# UI güncelle
	update_ui()

func handle_player_input():
	super.handle_player_input()
	
	# Mouse ile yön takibi (opsiyonel)
	if Input.is_action_pressed("mouse_follow"):
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		velocity = direction * fish_speed

func handle_ability_input():
	# Cooldown kontrolü ile yetenek kullanımı
	if Input.is_action_just_pressed("ability_1") and can_use_ability(0):
		use_ability_with_cooldown(active_abilities[0], 0)
	elif Input.is_action_just_pressed("ability_2") and can_use_ability(1):
		use_ability_with_cooldown(active_abilities[1], 1)
	elif Input.is_action_just_pressed("ability_3") and can_use_ability(2):
		use_ability_with_cooldown(active_abilities[2], 2)

func can_use_ability(ability_index: int) -> bool:
	if active_abilities.size() <= ability_index:
		return false
	
	var ability_name = active_abilities[ability_index]
	return not ability_cooldowns.has(ability_name) or ability_cooldowns[ability_name] <= 0

func use_ability_with_cooldown(ability_name: String, ability_index: int):
	use_ability(ability_name)
	
	# Cooldown ayarla
	var cooldown_time = get_ability_cooldown(ability_name)
	ability_cooldowns[ability_name] = cooldown_time
	
	# UI'da cooldown göster
	if ui_manager:
		ui_manager.update_ability_cooldown(ability_index, cooldown_time)

func get_ability_cooldown(ability_name: String) -> float:
	match ability_name:
		"dash":
			return 5.0
		"cloak":
			return 8.0
		"toxic_trail":
			return 3.0
		"clone":
			return 12.0
		"shockwave":
			return 6.0
		_:
			return 1.0

func update_cooldowns(delta: float):
	for ability_name in ability_cooldowns.keys():
		if ability_cooldowns[ability_name] > 0:
			ability_cooldowns[ability_name] -= delta

func eat_fish(eaten_fish: Fish):
	# Balık yeme işlemi
	total_fish_eaten += 1
	
	# XP kazan
	var xp_gain = calculate_xp_gain(eaten_fish)
	gain_experience(xp_gain)
	
	# Evrim puanı kazan
	var evolution_gain = calculate_evolution_gain(eaten_fish)
	evolution_points += evolution_gain
	total_evolution_points += evolution_gain
	
	# Özellik devralma şansı
	if randf() < 0.3: # %30 şans
		inherit_fish_trait(eaten_fish)
	
	# UI güncelle
	if ui_manager:
		ui_manager.update_stats(self)

func calculate_xp_gain(eaten_fish: Fish) -> int:
	var base_xp = 10
	var size_bonus = int(eaten_fish.fish_size * 5)
	var rarity_bonus = get_rarity_bonus(eaten_fish.fish_rarity)
	
	return base_xp + size_bonus + rarity_bonus

func calculate_evolution_gain(eaten_fish: Fish) -> int:
	var base_evolution = 1
	var rarity_bonus = get_rarity_evolution_bonus(eaten_fish.fish_rarity)
	
	return base_evolution + rarity_bonus

func get_rarity_bonus(rarity: String) -> int:
	match rarity:
		"common":
			return 0
		"rare":
			return 5
		"epic":
			return 15
		"legendary":
			return 30
		_:
			return 0

func get_rarity_evolution_bonus(rarity: String) -> int:
	match rarity:
		"common":
			return 0
		"rare":
			return 1
		"epic":
			return 2
		"legendary":
			return 3
		_:
			return 0

func inherit_fish_trait(eaten_fish: Fish):
	# Yenen balıktan özellik devralma
	var trait_chance = randf()
	
	if trait_chance < 0.4: # %40 şans - saldırı artışı
		fish_attack += 1
		print("Saldırı gücü arttı!")
	elif trait_chance < 0.7: # %30 şans - hız artışı
		fish_speed += 5
		print("Hız arttı!")
	elif trait_chance < 0.9: # %20 şans - can artışı
		max_health += 5
		fish_health += 5
		print("Can arttı!")
	else: # %10 şans - yetenek kazanma
		if eaten_fish.active_abilities.size() > 0:
			var random_ability = eaten_fish.active_abilities[randi() % eaten_fish.active_abilities.size()]
			add_active_ability(random_ability)
			print("Yeni yetenek kazanıldı: " + random_ability)

func _on_fish_evolved(fish: Fish):
	# Evrim animasyonu ve efektleri
	if animation_player and animation_player.has_animation("evolve"):
		animation_player.play("evolve")
	
	# UI güncelle
	if ui_manager:
		ui_manager.show_evolution_message(level)
		ui_manager.update_stats(self)

func _on_experience_gained(amount: int):
	# XP kazanma efekti
	if ui_manager:
		ui_manager.show_xp_gain(amount)

func update_ui():
	# UI güncellemeleri
	if ui_manager:
		ui_manager.update_health_bar(fish_health, max_health)
		ui_manager.update_level_display(level)
		ui_manager.update_xp_bar(experience_points, level * 100)

func save_game():
	# Oyun verilerini kaydet
	save_data = {
		"player_name": player_name,
		"level": level,
		"experience_points": experience_points,
		"evolution_points": evolution_points,
		"fish_size": fish_size,
		"fish_speed": fish_speed,
		"fish_attack": fish_attack,
		"fish_defense": fish_defense,
		"fish_health": fish_health,
		"max_health": max_health,
		"active_abilities": active_abilities,
		"passive_abilities": passive_abilities,
		"total_fish_eaten": total_fish_eaten,
		"total_evolution_points": total_evolution_points,
		"position": global_position
	}
	
	# Dosyaya kaydet
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_file.store_string(JSON.stringify(save_data))
	save_file.close()

func load_game():
	# Kayıtlı oyunu yükle
	if FileAccess.file_exists("user://savegame.save"):
		var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
		var json_string = save_file.get_as_text()
		save_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			save_data = json.data
			
			# Verileri uygula
			level = save_data.get("level", 1)
			experience_points = save_data.get("experience_points", 0)
			evolution_points = save_data.get("evolution_points", 0)
			fish_size = save_data.get("fish_size", 0.8)
			fish_speed = save_data.get("fish_speed", 120.0)
			fish_attack = save_data.get("fish_attack", 8)
			fish_defense = save_data.get("fish_defense", 3)
			fish_health = save_data.get("fish_health", 80)
			max_health = save_data.get("max_health", 80)
			active_abilities = save_data.get("active_abilities", [])
			passive_abilities = save_data.get("passive_abilities", [])
			total_fish_eaten = save_data.get("total_fish_eaten", 0)
			total_evolution_points = save_data.get("total_evolution_points", 0)
			
			# Pozisyonu ayarla
			if save_data.has("position"):
				global_position = save_data["position"]
			
			# Görsel güncellemeler
			scale = Vector2(fish_size, fish_size)
			health_bar.max_value = max_health
			health_bar.value = fish_health

func die():
	# Oyuncu ölümü
	game_started = false
	
	# Game Over ekranına geç
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func get_stats_summary() -> Dictionary:
	return {
		"level": level,
		"experience": experience_points,
		"evolution_points": evolution_points,
		"fish_eaten": total_fish_eaten,
		"abilities": active_abilities.size() + passive_abilities.size(),
		"size": fish_size,
		"attack": fish_attack,
		"defense": fish_defense,
		"speed": fish_speed
	} 