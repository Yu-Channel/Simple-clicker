extends Node

### ゲームに使われる要素をできる限り列挙
# 定数
const LIMIT_TIMER_NUM = 30	# 制限時間(s)
const CLICK_POWER_INIT = 1	# クリックの初期攻撃力
const AUTO_CLICK_POWER_INIT = 1	# オートの初期攻撃力

# グローバル変数
## ゲーム
var floor_num				# 階層
var time_limit				# 制限時間(ボスのみ)
var loop_flag				# 雑魚ループフラグ

## プレイヤーのステータス
var click_power				# クリック攻撃力
var click_multiplier		# クリック倍率 *実装は未定
var auto_click_power		# オートクリック攻撃力
var auto_click_multiplier	# オートクリック倍率
var auto_click_cooldown		# オートクリック速度

## 転生関連
var ascendant_power			# 転生後の補正値
var ascendant_max_floor		# 最大到達階層

## 敵のステータス
var enemy_type				# 敵の種類(0=通常/1=ボス)
var enemy_id				# 敵のグラフィックID
var enemy_max_hp			# 敵のHPの最大値
var enemy_hp				# 敵のHPの現在値


