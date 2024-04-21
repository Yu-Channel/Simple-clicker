extends Node2D

# ==============================================================================
# Section: ファイルの読み込み準備 ===================================================
var background_sprite_texture = load("res://sprite/BG001.png")

# ==============================================================================
# Section: ノードの読み込み準備 =====================================================
onready var bg_sprite_node = $Sprite

# ==============================================================================
# Section: 変数の宣言 ============================================================

# ==============================================================================
# Section: ノードの準備 ===========================================================
func _ready():
	bg_sprite_node.texture = background_sprite_texture

