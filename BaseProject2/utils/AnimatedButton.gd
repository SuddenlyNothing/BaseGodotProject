tool
extends ToolButton

var style_normal_override: StyleBoxFlat setget _set_style_normal_override
var style_hover_override: StyleBoxFlat setget _set_style_hover_override
var style_pressed_override: StyleBoxFlat setget _set_style_pressed_override

var timing_normal: StyleTrans
var timing_hover: StyleTrans
var timing_pressed: StyleTrans

var _hovered := false

onready var _hover_sfx := $HoverSFX
onready var _pressed_sfx := $PressedSFX
onready var _t := $Tween
onready var _bg := $BG


func _ready() -> void:
	if not Engine.editor_hint:
		_apply_default_styles()
		if style_normal_override:
			_bg.add_stylebox_override("panel", style_normal_override.duplicate())


func trans_style(timing: StyleTrans, to_style: StyleBoxFlat) -> void:
	if not timing or not to_style or not style_normal_override:
		return
	_t.remove_all()
	timing.trans_style(_t, _bg.get_stylebox("panel"), to_style)
	_t.start()


func _get_property_list() -> Array:
	var props := []
	props.append({
		name = "Animation",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY
	})
	props.append({
		name = "Styles",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
		hint_string = "style_"
	})
	props.append({
		name = "style_normal_override",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleBoxFlat",
	})
	props.append({
		name = "style_hover_override",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleBoxFlat",
	})
	props.append({
		name = "style_pressed_override",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleBoxFlat",
	})
	props.append({
		name = "Timing",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_GROUP,
		hint_string = "timing_"
	})
	props.append({
		name = "timing_normal",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleTrans"
	})
	props.append({
		name = "timing_hover",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleTrans"
	})
	props.append({
		name = "timing_pressed",
		type = TYPE_OBJECT,
		hint = PROPERTY_HINT_RESOURCE_TYPE,
		hint_string = "StyleTrans"
	})
	return props


func _set_style_normal_override(val: StyleBoxFlat) -> void:
	if val:
		val.anti_aliasing = false
		if val == style_hover_override or val == style_pressed_override:
			val = val.duplicate()
	if is_inside_tree():
		if val:
			$BG.add_stylebox_override("panel", val)
		else:
			$BG.add_stylebox_override("panel", null)
	style_normal_override = val


func _set_style_hover_override(val: StyleBoxFlat) -> void:
	if val:
		val.anti_aliasing = false
		val = val.duplicate()
	style_hover_override = val


func _set_style_pressed_override(val: StyleBoxFlat) -> void:
	if val:
		val.anti_aliasing = false
		val = val.duplicate()
	style_pressed_override = val


func _on_AnimatedButton_pressed() -> void:
	_pressed_sfx.play()


func _on_AnimatedButton_button_down() -> void:
	trans_style(timing_pressed, style_pressed_override)


func _on_AnimatedButton_button_up() -> void:
	if _hovered:
		trans_style(timing_hover, style_hover_override)
	else:
		trans_style(timing_normal, style_normal_override)


func _on_AnimatedButton_mouse_entered() -> void:
	_hovered = true
	_hover_sfx.play()
	trans_style(timing_hover, style_hover_override)


func _on_AnimatedButton_mouse_exited() -> void:
	_hovered = false
	trans_style(timing_normal, style_normal_override)


func _on_AnimatedButton_resized() -> void:
	rect_pivot_offset = rect_size / 2
	$BG.rect_pivot_offset = rect_size / 2


func _get_theme():
	var curr_node = self
	var find_theme = null
	while curr_node and "theme" in curr_node:
		find_theme = curr_node.theme
		if find_theme:
			break
		curr_node = curr_node.get_parent()
	return find_theme


func _apply_default_styles() -> void:
	if not style_normal_override or not style_hover_override or not style_pressed_override:
		var use_theme := _get_theme() as Theme
		if use_theme:
			if not style_normal_override:
				_set_style_normal_override(use_theme.get_stylebox("normal", "Button"))
			if not style_hover_override:
				_set_style_hover_override(use_theme.get_stylebox("hover", "Button"))
			if not style_pressed_override:
				_set_style_pressed_override(use_theme.get_stylebox("pressed", "Button"))
