extends MeshInstance3D

@export var focused:bool = false

@onready var bathroom_wall_main_crt_hole: MeshInstance3D = $".."
@onready var interaction_branch: InteractionBranch = $InteractionBranch
@onready var control: Control = $MatchFixing/Control

func _ready() -> void:
	control.hide()

func _process(delta: float) -> void:
	if !bathroom_wall_main_crt_hole.visible: interaction_branch.interactionAllowed = false
	elif !focused: interaction_branch.interactionAllowed = true
	else: interaction_branch.interactionAllowed = false
