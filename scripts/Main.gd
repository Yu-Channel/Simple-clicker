extends Node2D

# 定数
const LIMIT_TIMER_NUM = 30	# 制限時間(s)
const CLICK_POWER_INIT = 1	# クリックの初期攻撃力
const AUTO_CLICK_POWER_INIT = 1	# オートの初期攻撃力

# グローバル変数
## ゲーム
var floor_num				# 階層
var limit_timer				# 制限時間(ボスのみ)

## プレイヤーのステータス
var click_power				# クリック攻撃力
var click_multiplier		# クリック倍率 *実装は未定
var auto_click_power		# オートクリック攻撃力
var auto_click_multiplier	# オートクリック倍率
var auto_click_cooldown		# オートクリック速度

## 敵のステータス
var enemy_type				# 敵の種類 0 = 通常 1 = ボス
var enemy_id				# 敵のID
var enemy_max_hp			# 敵のHPの最大値
var enemy_hp				# 敵のHPの現在値


func _ready():
	pass # Replace with function body.

