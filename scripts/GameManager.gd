extends Node
class_name GameManager

# Oyun durumu
var game_state: String = "menu" # menu, playing, paused, game_over
var player: Player
var ui_manager: UIManager

# Balık spawn sistemi
var fish_spawn_timer: Timer
var spawn_interval: float = 3.0
var max_fish_count: int = 20
var current_fish_count: int = 0

# Balık türleri veritabanı
var fish_database: Dictionary = {
	"small_fish": {
		"name": "Küçük Balık",
		"size": 0.6,
		"speed": 80.0,
		"attack": 5,
		"defense": 2,
		"health": 50,
		"rarity": "common",
		"spawn_chance": 0.4
	},
	"medium_fish": {
		"name": "Orta Balık",
		"size": 1.0,
		"speed": 100.0,
		"attack": 12,
		"defense": 6,
		"health": 80,
		"rarity": "common",
		"spawn_chance": 0.3
	},
	"large_fish": {
		"name": "Büyük Balık",
		"size": 1.4,
		"speed": 90.0,
		"attack": 18,
		"defense": 10,
		"health": 120,
		"rarity": "rare",
		"spawn_chance": 0.2
	},
	"shark": {
		"name": "Köpekbalığı",
		"size": 2.0,
		"speed": 110.0,
		"attack": 25,
		"defense": 15,
		"health": 200,
		"rarity": "epic",
		"spawn_chance": 0.08
	},
	"whale": {
		"name": "Balina",
		"size": 3.0,
		"speed": 70.0,
		"attack": 35,
		"defense": 25,
		"health": 400,
		"rarity": "legendary",
		"spawn_chance": 0.02
	}
}

# Harita ve bölge sistemi
var current_zone: String = "surface" # surface, middle, deep, abyss
var zone_data: Dictionary = {
	"surface": {
		"name": "Yüzey",
		"background_color": Color(0.2, 0.6, 1.0, 0.8),
		"fish_types": ["small_fish", "medium_fish"],
		"depth": 0
	},
	"middle": {
		"name": "Orta Derinlik",
		"background_color": Color(0.1, 0.4, 0.8, 0.9),
		"fish_types": ["medium_fish", "large_fish"],
		"depth": 100
	},
	"deep": {
		"name": "Derin Sular",
		"background_color": Color(0.05, 0.2, 0.6, 0.95),
		"fish_types": ["large_fish", "shark"],
		"depth": 200
	},
	"abyss": {
		"name": "Karanlık Abis",
		"background_color": Color(0.02, 0.1, 0.3, 1.0),
		"fish_types": ["shark", "whale"],
		"depth": 300
	}
}

# Oyun istatistikleri
var game_stats: Dictionary = {
	"total_fish_eaten": 0,
	"total_evolution_points": 0,
	"highest_level": 1,
	"play_time": 0.0,
	"zones_explored": 1
}

func _ready():
	# Singleton olarak ayarla
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Timer oluştur
	fish_spawn_timer = Timer.new()
	fish_spawn_timer.wait_time = spawn_interval
	fish_spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(fish_spawn_timer)

func start_game():
	game_state = "playing"
	game_stats["play_time"] = 0.0
	
	# Oyuncu oluştur
	spawn_player()
	
	# Balık spawn'ını başlat
	fish_spawn_timer.start()
	
	# UI'ı başlat
	if ui_manager:
		ui_manager.show_game_ui()

func spawn_player():
	# Oyuncu balığı oluştur
	var player_scene = preload("res://scenes/Player.tscn")
	player = player_scene.instantiate()
	
	# Oyuncuyu sahneye ekle
	var game_scene = get_tree().current_scene
	game_scene.add_child(player)
	
	# Oyuncu pozisyonunu ayarla
	player.global_position = Vector2(640, 360) # Ekran ortası
	
	# UI bağlantısı
	if ui_manager:
		player.ui_manager = ui_manager

func spawn_fish():
	if current_fish_count >= max_fish_count:
		return
	
	# Balık türü seç
	var fish_type = select_fish_type()
	var fish_data = fish_database[fish_type]
	
	# Balık oluştur
	var fish_scene = preload("res://scenes/Fish.tscn")
	var fish = fish_scene.instantiate()
	
	# Balık özelliklerini ayarla
	fish.fish_id = fish_type
	fish.fish_name = fish_data["name"]
	fish.fish_size = fish_data["size"]
	fish.fish_speed = fish_data["speed"]
	fish.fish_attack = fish_data["attack"]
	fish.fish_defense = fish_data["defense"]
	fish.fish_health = fish_data["health"]
	fish.max_health = fish_data["health"]
	fish.fish_rarity = fish_data["rarity"]
	
	# Sprite'ı ayarla
	setup_fish_sprite(fish, fish_type)
	
	# Rastgele pozisyon
	var spawn_position = get_random_spawn_position()
	fish.global_position = spawn_position
	
	# Sahneye ekle
	var game_scene = get_tree().current_scene
	game_scene.add_child(fish)
	
	# Sinyal bağlantıları
	fish.connect("fish_died", Callable(self, "_on_fish_died"))
	
	current_fish_count += 1

func setup_fish_sprite(fish: Fish, fish_type: String):
	var sprite = fish.get_node("Sprite2D")
	if not sprite:
		return
	
	# Balık türüne göre sprite yükle
	var sprite_path = ""
	match fish_type:
		"small_fish":
			sprite_path = "res://assets/sprites/small_fish.svg"
		"medium_fish":
			sprite_path = "res://assets/sprites/medium_fish.svg"
		"large_fish":
			sprite_path = "res://assets/sprites/large_fish.svg"
		"shark":
			sprite_path = "res://assets/sprites/shark.svg"
		"whale":
			sprite_path = "res://assets/sprites/whale.svg"
		_:
			sprite_path = "res://assets/sprites/fish_simple.svg"
	
	# Sprite'ı yükle
	var texture = load(sprite_path)
	if texture:
		sprite.texture = texture
		sprite.scale = Vector2(fish.fish_size, fish.fish_size)

func select_fish_type() -> String:
	var available_fish = zone_data[current_zone]["fish_types"]
	var total_chance = 0.0
	
	# Toplam şansı hesapla
	for fish_type in available_fish:
		total_chance += fish_database[fish_type]["spawn_chance"]
	
	# Rastgele seç
	var random_value = randf() * total_chance
	var current_chance = 0.0
	
	for fish_type in available_fish:
		current_chance += fish_database[fish_type]["spawn_chance"]
		if random_value <= current_chance:
			return fish_type
	
	# Varsayılan olarak ilk balık türü
	return available_fish[0]

func get_random_spawn_position() -> Vector2:
	# Ekran dışından rastgele pozisyon
	var screen_size = get_viewport().get_visible_rect().size
	var side = randi() % 4
	
	match side:
		0: # Üst
			return Vector2(randf_range(0, screen_size.x), -50)
		1: # Sağ
			return Vector2(screen_size.x + 50, randf_range(0, screen_size.y))
		2: # Alt
			return Vector2(randf_range(0, screen_size.x), screen_size.y + 50)
		3: # Sol
			return Vector2(-50, randf_range(0, screen_size.y))
	
	return Vector2.ZERO

func _on_spawn_timer_timeout():
	spawn_fish()

func _on_fish_died(fish: Fish):
	current_fish_count -= 1
	
	# Eğer ölen balık oyuncu tarafından yenildiyse
	if player and fish != player:
		player.eat_fish(fish)
		game_stats["total_fish_eaten"] += 1

func change_zone(new_zone: String):
	if new_zone in zone_data:
		current_zone = new_zone
		game_stats["zones_explored"] += 1
		
		# Arka plan rengini değiştir
		update_background()
		
		# Balık spawn şanslarını güncelle
		update_spawn_chances()

func update_background():
	var background = get_node_or_null("/root/Game/Background")
	if background and current_zone in zone_data:
		background.modulate = zone_data[current_zone]["background_color"]

func update_spawn_chances():
	# Derinlik arttıkça daha nadir balıkların şansı artar
	var depth_factor = zone_data[current_zone]["depth"] / 300.0
	
	for fish_type in fish_database:
		var base_chance = fish_database[fish_type]["spawn_chance"]
		var rarity = fish_database[fish_type]["rarity"]
		
		match rarity:
			"legendary":
				fish_database[fish_type]["spawn_chance"] = base_chance * (1 + depth_factor)
			"epic":
				fish_database[fish_type]["spawn_chance"] = base_chance * (1 + depth_factor * 0.7)
			"rare":
				fish_database[fish_type]["spawn_chance"] = base_chance * (1 + depth_factor * 0.5)

func pause_game():
	if game_state == "playing":
		game_state = "paused"
		fish_spawn_timer.paused = true
		get_tree().paused = true

func resume_game():
	if game_state == "paused":
		game_state = "playing"
		fish_spawn_timer.paused = false
		get_tree().paused = false

func game_over():
	game_state = "game_over"
	fish_spawn_timer.stop()
	
	# İstatistikleri güncelle
	if player:
		game_stats["highest_level"] = max(game_stats["highest_level"], player.level)
	
	# Game Over ekranına geç
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")

func save_game():
	if player:
		player.save_game()
	
	# Oyun istatistiklerini kaydet
	var stats_file = FileAccess.open("user://game_stats.save", FileAccess.WRITE)
	stats_file.store_string(JSON.stringify(game_stats))
	stats_file.close()

func load_game():
	if player:
		player.load_game()
	
	# Oyun istatistiklerini yükle
	if FileAccess.file_exists("user://game_stats.save"):
		var stats_file = FileAccess.open("user://game_stats.save", FileAccess.READ)
		var json_string = stats_file.get_as_text()
		stats_file.close()
		
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			game_stats = json.data

func _process(delta):
	if game_state == "playing":
		game_stats["play_time"] += delta
		
		# Derinlik kontrolü (oyuncu pozisyonuna göre)
		if player:
			var player_depth = player.global_position.y
			check_zone_change(player_depth)

func check_zone_change(player_depth: float):
	var new_zone = current_zone
	
	if player_depth < 100:
		new_zone = "surface"
	elif player_depth < 200:
		new_zone = "middle"
	elif player_depth < 300:
		new_zone = "deep"
	else:
		new_zone = "abyss"
	
	if new_zone != current_zone:
		change_zone(new_zone)

func get_game_stats() -> Dictionary:
	return game_stats

func get_current_zone_info() -> Dictionary:
	return zone_data[current_zone] 