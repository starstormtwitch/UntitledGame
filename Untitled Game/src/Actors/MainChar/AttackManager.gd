extends Node

class_name AttackManager

var kickSound = preload("res://assets/audio/HitAudio/kick_sfx.wav")
var punchSound = preload("res://assets/audio/HitAudio/punch_sfx.wav")
var hitSound = preload("res://assets/audio/HitAudio/Quick Hit Swoosh.wav")

const _START_A_COMBO = 3
const _START_B_COMBO = 3
const COMBOTIME = 1

var isAttacking: bool = false
var _didHitEnemy: bool = false #To check to see if we should play woosh sfx if we missed
var _beingHurt: bool = false
var isLastAttackAKick = false #Used to check which hitmarker to show
var _directionFacing: Vector2 = Vector2.ZERO

var _comboAPoints = _START_A_COMBO;
var _comboBPoints = _START_B_COMBO;

# Injected from player
var _attackResetTimer: Timer
var _shoryukenAudioPlayer: AudioStreamPlayer
var _animationTree: AnimationTree

func _init(attackResetTimer: Timer, shoryukenAudioPlayer: AudioStreamPlayer, animationTree: AnimationTree):
	_attackResetTimer = attackResetTimer
	_shoryukenAudioPlayer = shoryukenAudioPlayer
	_animationTree = animationTree


func resetCombo():
	_comboAPoints = _START_A_COMBO
	_comboBPoints = _START_B_COMBO


func _attack_setup(is_kick: bool):
	isAttacking = true
	_didHitEnemy = false
	isLastAttackAKick = is_kick
	_attackResetTimer.start(COMBOTIME)


func doSideSwipeAttack(scene : Node):
	if !isAttacking:
		_attack_setup(false)
		print("Combo A: " + String(_comboAPoints))
		if _comboAPoints == 1 or _comboBPoints == 1:
			_shoryukenAudioPlayer.play()
			_animationTree.get("parameters/playback").travel("Shoryuken")
			combo_reset()
		elif _comboAPoints == 3:
			SoundPlayer.playSound(scene, punchSound, 5)
			_animationTree.get("parameters/playback").travel("SideSwipe1")
			_comboAPoints = _comboAPoints - 1
			_comboBPoints = 3
		elif _comboAPoints == 2:
			SoundPlayer.playSound(scene, punchSound, 5)
			_animationTree.get("parameters/playback").travel("SideSwipe2")
			_comboAPoints = _comboAPoints - 1
			_comboBPoints = 3


func doSideSwipeKick(scene : Node):
	if !isAttacking:
		_attack_setup(true)
		print("Combo B: " + String(_comboBPoints))
		if _comboBPoints == 1 or _comboAPoints == 1:
			_animationTree.get("parameters/playback").travel("Hadouken")
			combo_reset()
		elif _comboBPoints == 3:
			SoundPlayer.playSound(scene, kickSound, 5)
			_animationTree.get("parameters/playback").travel("SideSwipeKick")
			_comboBPoints = _comboBPoints - 1
			_comboAPoints = 3
		elif _comboBPoints == 2:
			SoundPlayer.playSound(scene, kickSound, 5)
			_animationTree.get("parameters/playback").travel("SideSwipeRightKick2")
			_comboBPoints = _comboBPoints - 1
			_comboAPoints = 3


func playHitSounds(scene : Node):
	SoundPlayer.playSound(scene, hitSound, 5)

func combo_reset() -> void:
	#print("combo reset")
	_comboAPoints = _START_A_COMBO
	_comboBPoints = _START_B_COMBO
