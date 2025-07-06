extends Control
class_name UIManager

# UI bileşenleri
@onready var health_bar: ProgressBar = $GameUI/HealthBar
@onready var level_label: Label = $GameUI/LevelLabel
@onready var xp_bar: ProgressBar = $GameUI/XPBar
@onready var ability_buttons: Array[Button] = [
	$GameUI/AbilityPanel/Ability1,
	$GameUI/AbilityPanel/Ability2,
	$GameUI/AbilityPanel/Ability3
]
@onready var cooldown_labels: Array[Label] = [
	$GameUI/AbilityPanel/Cooldown1,
	$GameUI/AbilityPanel/Cooldown2,
	$GameUI/AbilityPanel/Cooldown3
]
@onready var stats_panel: Panel = $GameUI/StatsPanel
@onready var zone_label: Label = $GameUI/ZoneLabel
@onready var fish_eaten_label: Label = $GameUI/FishEatenLabel

# Menü bileşenleri
@onready var main_menu: Control = $MainMenu
@onready var pause_menu: Control = $PauseMenu
@onready var game_over_menu: Control = $GameOverMenu

# Mesaj sistemi
@onready var message_label: Label = $GameUI/MessageLabel
var message_timer: Timer

# Oyun durumu
var current_player: Player
var game_ui_visible: bool = false

func _ready():
	# Mesaj timer'ı oluştur
	message_timer = Timer.new()
	message_timer.one_shot = true
	message_timer.timeout.connect(_on_message_timeout)
	add_child(message_timer)
	
	# Başlangıçta sadece ana menüyü göster
	show_main_menu()

func show_main_menu():
	main_menu.visible = true
	game_ui_visible = false
	hide_all_ui()

func show_game_ui():
	main_menu.visible = false
	game_ui_visible = true
	show_game_ui_elements()

func show_pause_menu():
	pause_menu.visible = true
	get_tree().paused = true

func hide_pause_menu():
	pause_menu.visible = false
	get_tree().paused = false

func show_game_over_menu():
	game_over_menu.visible = true
	game_ui_visible = false

func hide_all_ui():
	stats_panel.visible = false
	zone_label.visible = false
	fish_eaten_label.visible = false
	message_label.visible = false

func show_game_ui_elements():
	stats_panel.visible = true
	zone_label.visible = true
	fish_eaten_label.visible = true

func update_health_bar(current_health: int, max_health: int):
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health
		
		# Can barı rengini güncelle
		var health_percentage = float(current_health) / float(max_health)
		if health_percentage > 0.6:
			health_bar.modulate = Color.GREEN
		elif health_percentage > 0.3:
			health_bar.modulate = Color.YELLOW
		else:
			health_bar.modulate = Color.RED

func update_level_display(level: int):
	if level_label:
		level_label.text = "Seviye: " + str(level)

func update_xp_bar(current_xp: int, required_xp: int):
	if xp_bar:
		xp_bar.max_value = required_xp
		xp_bar.value = current_xp

func update_ability_cooldown(ability_index: int, cooldown_time: float):
	if ability_index < cooldown_labels.size():
		var label = cooldown_labels[ability_index]
		label.text = str(int(cooldown_time))
		label.visible = true
		
		# Cooldown süresince güncelle
		var tween = create_tween()
		tween.tween_method(update_cooldown_display, cooldown_time, 0.0, cooldown_time)
		tween.tween_callback(func(): label.visible = false)

func update_cooldown_display(time_left: float):
	# Cooldown güncelleme (gerçek zamanlı)
	pass

func update_stats(player: Player):
	if not player:
		return
	
	current_player = player
	
	# Temel istatistikleri güncelle
	update_health_bar(player.fish_health, player.max_health)
	update_level_display(player.level)
	update_xp_bar(player.experience_points, player.level * 100)
	
	# Bölge bilgisini güncelle
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		var zone_info = game_manager.get_current_zone_info()
		zone_label.text = "Bölge: " + zone_info["name"]
	
	# Yenen balık sayısını güncelle
	fish_eaten_label.text = "Yenen Balık: " + str(player.total_fish_eaten)
	
	# Yetenek butonlarını güncelle
	update_ability_buttons()

func update_ability_buttons():
	if not current_player:
		return
	
	for i in range(ability_buttons.size()):
		var button = ability_buttons[i]
		var cooldown_label = cooldown_labels[i]
		
		if i < current_player.active_abilities.size():
			# Yetenek var
			button.visible = true
			button.text = get_ability_display_name(current_player.active_abilities[i])
			button.disabled = false
		else:
			# Yetenek yok
			button.visible = false
			cooldown_label.visible = false

func get_ability_display_name(ability_name: String) -> String:
	match ability_name:
		"dash":
			return "Dash"
		"cloak":
			return "Cloak"
		"toxic_trail":
			return "Toxic"
		"clone":
			return "Clone"
		"shockwave":
			return "Shock"
		_:
			return ability_name

func show_evolution_message(level: int):
	show_message("Seviye " + str(level) + "! Evrimleştin!", 3.0)

func show_xp_gain(amount: int):
	show_message("+" + str(amount) + " XP", 2.0)

func show_message(text: String, duration: float = 2.0):
	if message_label:
		message_label.text = text
		message_label.visible = true
		message_timer.wait_time = duration
		message_timer.start()

func _on_message_timeout():
	if message_label:
		message_label.visible = false

# Menü buton işleyicileri
func _on_start_button_pressed():
	show_game_ui()
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.start_game()

func _on_load_button_pressed():
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.load_game()
	show_game_ui()

func _on_settings_button_pressed():
	# Ayarlar menüsü (gelecekte implement edilecek)
	print("Ayarlar menüsü açıldı")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	hide_pause_menu()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

# Yetenek buton işleyicileri
func _on_ability_1_pressed():
	if current_player and current_player.active_abilities.size() > 0:
		current_player.use_ability_with_cooldown(current_player.active_abilities[0], 0)

func _on_ability_2_pressed():
	if current_player and current_player.active_abilities.size() > 1:
		current_player.use_ability_with_cooldown(current_player.active_abilities[1], 1)

func _on_ability_3_pressed():
	if current_player and current_player.active_abilities.size() > 2:
		current_player.use_ability_with_cooldown(current_player.active_abilities[2], 2)

# Klavye kısayolları
func _input(event):
	if event.is_action_pressed("pause"):
		if game_ui_visible:
			if pause_menu.visible:
				hide_pause_menu()
			else:
				show_pause_menu()

# İstatistik paneli güncelleme
func update_stats_panel():
	if not current_player:
		return
	
	var stats = current_player.get_stats_summary()
	
	# İstatistik etiketlerini güncelle
	var stats_labels = stats_panel.get_children()
	for label in stats_labels:
		if label is Label:
			match label.name:
				"AttackLabel":
					label.text = "Saldırı: " + str(stats["attack"])
				"DefenseLabel":
					label.text = "Savunma: " + str(stats["defense"])
				"SpeedLabel":
					label.text = "Hız: " + str(int(stats["speed"]))
				"SizeLabel":
					label.text = "Boyut: " + str(stats["size"])

# Animasyonlar
func play_ui_animation(animation_name: String):
	# UI animasyonları (gelecekte implement edilecek)
	pass

# Ses efektleri
func play_ui_sound(sound_name: String):
	# UI ses efektleri (gelecekte implement edilecek)
	pass 