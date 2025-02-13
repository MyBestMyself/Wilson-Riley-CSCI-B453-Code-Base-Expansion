extends RigidBody2D

class_name Raumschiff


var m_mass = 1
var init_pos
var gravity_handle
export (int) var crystals = 0
var dead = false
var explosion = preload("res://materials/Explosion.tres")

var nearby_planets = {}

signal crystal_collected(new_count)

func _ready():
	init_pos = global_position
	gravity_handle = get_node("Camera2D/CanvasLayer/GravityHandle")

func _process(_delta):
	if not dead:
		if Input.is_action_just_released("increase") && m_mass < 50:
			m_mass += 5
			gravity_handle.position.x -= (4.24 * 5)
		if Input.is_action_just_released("decrease") && m_mass > -50:
			m_mass -= 5
			gravity_handle.position.x += (4.24 * 5)
		if Input.is_action_just_released("explode") && OS.is_debug_build():
			explode()
		if Input.is_action_just_released("completelvl") && OS.is_debug_build():
			win()
		
		if Input.is_action_just_pressed("m1"):
			#boost
			apply_central_impulse(-500 *$Lineup.transform.y.rotated(rotation) * abs(m_mass))
		
		if Input.is_action_pressed("m2"):
			pass

func _physics_process(delta):
	var mass_absolute = abs(m_mass)
	
	if m_mass < 0:
		gravity_scale = -5
	elif m_mass == 0:
		gravity_scale = 0
	else:
		gravity_scale = 5
	
	if mass_absolute > 0:
		mass = mass_absolute
	
	if not dead:
		$Lineup.rotation = to_local(get_global_mouse_position()).angle() + PI / 2
		rotate_away_from(get_nearest_planet(), delta)
	
	$Label.text = str(rotation_degrees)

func collect_crystal(crystal : Crystal):
	crystals += 1
	print_debug("crystal collected: " + str(crystals))
	crystal.hide_and_reparent(self)
	get_node("CollectJingleSFX").play()
	emit_signal("crystal_collected", crystals)
	
func _on_Raumschiff_body_entered(body):
	if body.name == "Sun":
		burn_up(body)
	else:
		print_debug("collided with: " + str(body))
		get_node("CollisionSFX").play()
	
func register_gravity_well(planet):
	print_debug("entered gravity well of " + str(planet))
	if not nearby_planets.has(planet.name):
		nearby_planets[planet.name] = planet

func unregister_gravity_well(planet):
	print_debug("exited gravity well of " + str(planet))
	if nearby_planets.has(planet.name):
		nearby_planets.erase(planet.name)
		if planet.name == "Sun":
			freeze()
		
func get_nearest_planet():
	var result = null
	var closest_distance = 1e6
	for p in nearby_planets.values():
		var dist = global_position.distance_to(p.global_position)
		if dist < closest_distance and p.name != "Sun":
			result = p
			closest_distance = dist
	return result
	
func rotate_away_from(target : Node2D, delta):
	var angle = 0
	if target != null:
		var dir = target.global_position - global_position
		if dir.length() < 250:
			angle = dir.angle() - PI / 2
	
	var coll = get_node("Collider")
	var diff = short_angle_dist(coll.rotation, angle)
	coll.rotation += diff * delta * 2 # quasi-lerp

func rotate_towards(target: Node2D, delta):
	var angle = 0
	if target != null:
		var dir = target.global_position - global_position
		if dir.length() < 250:
			angle = dir.angle() + PI / 2
	
	var coll = get_node("Collider")
	var diff = short_angle_dist(coll.rotation, angle)
	coll.rotation += diff * delta * 2 # quasi-lerp


func short_angle_dist(from, to):
	return fmod(to - from + PI, PI * 2) - PI

func burn_up(_sun):
	print_debug("burned up!")
	get_node("Collider/Sprite").hide()
	explode()
	die(1)
	
func explode():
	print_debug("boom")
	get_node("ExplosionPFX").restart()
	get_node("ExplosionSFX").play()

func freeze():
	print_debug("frozen solid!")
	get_node("Collider/Sprite/Ice").show()
	get_node("FreezingSFX").play()
	die(2)

func die(reason):
	dead = true
	var deathOverlay
	if reason == 1:
		deathOverlay = get_node("Camera2D/CanvasLayer/Death1")
	elif reason == 2:
		deathOverlay = get_node("Camera2D/CanvasLayer/Death2")
	
	yield(get_tree().create_timer(2.0), "timeout")
	deathOverlay.visible = true
	yield(deathOverlay.get_child(0), "pressed")
	get_node("/root/Game").restart_current_level()

func win():
	get_node("/root/Game").load_next()
	
