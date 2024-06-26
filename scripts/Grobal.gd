extends Node

### ゲームに使われる要素をできる限り列挙
# 定数
const LIMIT_TIMER_NUM = 30	# 制限時間(s)
const CLICK_POWER_INIT = 1	# クリックの初期攻撃力
const AUTO_CLICK_POWER_INIT = 0	# オートの初期攻撃力

var ThousandsSparatorUnit:Array = ["dummy", "K", "M", "G", "T", "P", "E", "Z", "Y", "R", "Q"]

const SAVEFILE = "res://savedata.hage"
# セーブファイルの初期化用
var save_init = {
	"Money": "",
	"Floor": "",
	"Farm_mode_flag": "",
	"Click_power": "",
	"Auto_click_power": ""
}

# グローバル変数
## ゲーム
var money:int = 0				# お金
var floor_num:int = 1				# 階層
var time_limit:float = LIMIT_TIMER_NUM				# 制限時間(ボスのみ)
var farm_mode_flag:int = 0				# 雑魚ループフラグ

## プレイヤーのステータス
var click_power:int = CLICK_POWER_INIT				# クリック攻撃力
var click_multiplier		# クリック倍率 *実装は未定
var auto_click_power:int = AUTO_CLICK_POWER_INIT		# オートクリック攻撃力
var auto_click_multiplier	# オートクリック倍率 *実装は未定
var auto_click_cooldown		# オートクリック速度

## 転生関連
var ascendant_power			# 転生後の補正値
var ascendant_max_floor		# 最大到達階層

## 敵のステータス
var enemy_type				# 敵の種類(0=通常/1=ボス)
var enemy_id:int = 0				# 敵のグラフィックID
var enemy_max_hp:float = 0			# 敵のHPの最大値
var enemy_hp:float = 0				# 敵のHPの現在値


