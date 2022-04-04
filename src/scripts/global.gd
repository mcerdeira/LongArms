extends Node
var MANA = 0.0
var TOTAL_MANA = 0.0
var MANA_COST = 0.0
var LIFE = 0.0
var TOTAL_LIFE = 0.0

func _ready():
	TOTAL_MANA = 12.0
	MANA_COST = 4.0
	MANA = TOTAL_MANA
	TOTAL_LIFE = 10.0
	LIFE = TOTAL_LIFE

func AddMana():
	MANA += MANA_COST
	if MANA > TOTAL_MANA:
		MANA = TOTAL_MANA

func PlayerHit(value):
	LIFE -= value
	if LIFE < 0:
		LIFE = 0

func AddLife(value:= 1):
	LIFE += value
	if LIFE > TOTAL_LIFE:
		LIFE = TOTAL_LIFE
