tool
class_name AnimatedButton
extends Button

enum Transitions {
	TRANS_LINEAR = 0,
	TRANS_SINE = 1,
	TRANS_QUINT = 2,
	TRANS_QUART = 3,
	TRANS_QUAD = 4,
	TRANS_EXPO = 5,
	TRANS_ELASTIC = 6,
	TRANS_CUBIC = 7,
	TRANS_CIRC = 8,
	TRANS_BOUNCE = 9,
	TRANS_BACK = 10,
}

enum Easing {
	EASE_IN = 0,
	EASE_OUT = 1,
	EASE_IN_OUT = 2,
	EASE_OUT_IN = 3,

}

export(String, FILE, "*.tscn") var next_scene

export(bool) var play_hover := true
export(bool) var play_pressed := true

export(bool) var refresh_theme := false setget set_refresh_theme
export(Transitions) var transition_type := Transitions.TRANS_BACK
export(Easing) var easing_type := Easing.EASE_OUT

export(bool) var override_text_colors := false
export(Color) var normal_text_color := Color( 0.88, 0.88, 0.88, 1 )
export(Color) var hover_text_color := Color( 1, 1, 1, 1 )
export(Color) var pressed_text_color :=  Color( 0.94, 0.94, 0.94, 1 )
export(Color) var disabled_text_color := Color( 0.9, 0.9, 0.9, 0.2 )

export(float) var normal_timing := 0.1
export(float) var hover_timing := 0.2
export(float) var pressed_timing := 0.02
export(float) var disabled_timing := 0.0

export(StyleBoxFlat) var normal_style: StyleBoxFlat = null setget \
		set_normal_style
export(StyleBoxFlat) var hover_style: StyleBoxFlat
export(StyleBoxFlat) var pressed_style: StyleBoxFlat
export(StyleBoxFlat) var disabled_style: StyleBoxFlat

var is_mouse_inside := false
var previous_disabled := false
var pressing := false
var focused := false
var started_scene_transition := false
var current_focused: Control

onready var t := $Tween
onready var bg := $BG
onready var hover_sfx := $HoverSFX
onready var pressed_sfx := $PressedSFX


func _ready() -> void:
	refresh_theme()
	if not Engine.editor_hint:
		get_viewport().connect("gui_focus_changed", self, "_on_focus_changed")


# Goes to next_scene if the next_scene variable is set
func _pressed() -> void:
	if started_scene_transition:
		return
	if next_scene:
		started_scene_transition = true
		SceneHandler.goto_scene(next_scene)
	if play_pressed:
		pressed_sfx.play()


# Setget used to refresh theme
func set_refresh_theme(val: bool) -> void:
	refresh_theme()


# Sets the styling of the button to match the theme or the override
func refresh_theme() -> void:
	if Engine.editor_hint:
		if normal_style:
			$BG.add_stylebox_override("panel", normal_style)
		else:
			var current_theme := get_theme()
			if current_theme:
				$BG.add_stylebox_override("panel", current_theme.get_stylebox(
						"normal", "Button"))
	else:
		cover_overrides()
		var curr_text_color := Color()
		if disabled:
			curr_text_color = disabled_text_color
		elif pressed:
			curr_text_color = pressed_text_color
		else:
			curr_text_color = normal_text_color
		previous_disabled = disabled
		add_color_override("font_color", curr_text_color)
		add_color_override("font_color_disabled", curr_text_color)
		add_color_override("font_color_hover", curr_text_color)
		add_color_override("font_color_pressed", curr_text_color)
		add_color_override("font_color_focus", curr_text_color)
		if disabled and disabled_style:
			if not disabled_style.draw_center:
				disabled_style.draw_center = true
				disabled_style.bg_color = Color.transparent
			$BG.add_stylebox_override("panel", disabled_style.duplicate())
		elif pressed and pressed_style:
			if not pressed_style.draw_center:
				pressed_style.draw_center = true
				pressed_style.bg_color = Color.transparent
			$BG.add_stylebox_override("panel", pressed_style.duplicate())
		elif normal_style:
			if not normal_style.draw_center:
				normal_style.draw_center = true
				normal_style.bg_color = Color.transparent
			$BG.add_stylebox_override("panel", normal_style.duplicate())


# Gets the theme of the scene or null if there is none
func get_theme() -> Theme:
	var curr = get_parent()
	var curr_theme: Theme = .get_theme()
	while curr and curr is Control and not curr_theme:
		curr_theme = curr.get_theme()
		curr = curr.get_parent()
	return curr_theme


# Replaces the override styles and colors with the one in the button theme
# override. If there is no button override, uses the theme style/color. Only
# overrides if the respective property is not set in the export variable.
func cover_overrides() -> void:
	if normal_style and hover_style and pressed_style and disabled_style and \
			override_text_colors:
		return
	var scene_theme := get_theme()
	if not scene_theme:
		return
	
	if not override_text_colors:
		var color_list := scene_theme.get_color_list("Button")
		
		var normal_override_color = get("custom_colors/font_color")
		if normal_override_color != null:
			normal_text_color = normal_override_color
		elif "font_color" in color_list:
			var normal_theme_color := scene_theme.get_color("font_color",
					"Button")
			normal_text_color = normal_theme_color
		
		var hover_override_color = get("custom_colors/font_color_hover")
		if hover_override_color != null:
			hover_text_color = hover_override_color
		elif "font_color_hover" in color_list:
			var hover_theme_color := scene_theme.get_color("font_color_hover",
					"Button")
			hover_text_color = hover_theme_color
		
		var pressed_override_color = get("custom_colors/font_color_pressed")
		if pressed_override_color != null:
			pressed_text_color = pressed_override_color
		elif "font_color_pressed" in color_list:
			var pressed_theme_color := scene_theme.get_color(
					"font_color_pressed", "Button")
			pressed_text_color = pressed_theme_color
		
		var disabled_override_color = get("custom_colors/font_color_disabled")
		if disabled_override_color != null:
			disabled_text_color = disabled_override_color
		elif "font_color_disabled" in color_list:
			var disabled_theme_color := scene_theme.get_color(
					"font_color_disabled", "Button")
			disabled_text_color = disabled_theme_color
		
	var theme_normal := empty_to_flat(scene_theme.get_stylebox("normal",
			"Button"))
	if theme_normal is StyleBoxFlat and not normal_style:
		normal_style = theme_normal
	var theme_hover := empty_to_flat(scene_theme.get_stylebox("hover",
			"Button"))
	if theme_hover is StyleBoxFlat and not hover_style:
		hover_style = theme_hover
	var theme_pressed := empty_to_flat(scene_theme.get_stylebox("pressed",
			"Button"))
	if theme_pressed is StyleBoxFlat and not pressed_style:
		pressed_style = theme_pressed
	var theme_disabled := empty_to_flat(scene_theme.get_stylebox("disabled",
			"Button"))
	if theme_disabled is StyleBoxFlat and not disabled_style:
		disabled_style = theme_disabled


# Converts empty styleboxes to flat styleboxes. Returns empty if empty is not a
# StyleBoxEmpty
func empty_to_flat(empty: StyleBox) -> StyleBox:
	if empty is StyleBoxEmpty:
		var new_stylebox := StyleBoxFlat.new()
		new_stylebox.bg_color = Color.transparent
		return new_stylebox
	return empty


# Sets the font color overrides to the given color
func set_color(to: Color) -> void:
	set("custom_colors/font_color", to)
	set("custom_colors/font_color_disabled", to)
	set("custom_colors/font_color_hover", to)
	set("custom_colors/font_color_pressed", to)
	set("custom_colors/font_color_focus", to)


# Animates the current styling to the new given to style
func set_style(to: String) -> void:
	if started_scene_transition:
		return
	var from := bg.get_stylebox("panel") as StyleBoxFlat
	var style: StyleBoxFlat = null
	var timing := 0.0
	var new_color := Color()
	match to:
		"normal":
			style = normal_style
			timing = normal_timing
			new_color = normal_text_color
		"hover":
			style = hover_style
			timing = hover_timing
			new_color = hover_text_color
		"pressed":
			style = pressed_style
			timing = pressed_timing
			new_color = pressed_text_color
		"disabled":
			style = disabled_style
			timing = disabled_timing
			new_color = disabled_text_color
	t.remove_all()
	t.interpolate_method(self, "set_color", get("custom_colors/font_color"),
			new_color, timing)
	if from and style:
		if (not from.bg_color.a or not from.draw_center) and style.draw_center:
			var old_color := style.bg_color
			old_color.a = 0
			t.interpolate_property(from, "bg_color", old_color,
					style.bg_color, timing)
		elif not style.bg_color.a or not style.draw_center:
			t.interpolate_property(from, "bg_color:a", null,
					0, timing)
		else:
			t.interpolate_property(from, "bg_color", null,
					style.bg_color, timing)
		
		t.interpolate_property(from, "skew", null,
				style.skew, timing, transition_type, easing_type)
		
		t.interpolate_property(from, "border_width_top", null,
				style.border_width_top, timing, transition_type, easing_type)
		t.interpolate_property(from, "border_width_right", null,
				style.border_width_right, timing, transition_type, easing_type)
		t.interpolate_property(from, "border_width_bottom", null,
				style.border_width_bottom, timing, transition_type, easing_type)
		t.interpolate_property(from, "border_width_left", null,
				style.border_width_left, timing, transition_type, easing_type)
		
		if not style.border_color.a or (not style.border_width_top and not\
				style.border_width_bottom and not style.border_width_right\
				and not style.border_width_left):
			t.interpolate_property(from, "border_color:a", null,
					0, timing)
		elif not from.border_color.a or (not from.border_width_top and not\
				from.border_width_bottom and not from.border_width_right\
				and not from.border_width_left):
			var old_color := style.border_color
			old_color.a = 0
			t.interpolate_property(from, "border_color", old_color,
					style.border_color, timing)
		else:
			t.interpolate_property(from, "border_color", null,
					style.border_color, timing)
		
		t.interpolate_property(from, "corner_radius_top_right", null, 
				style.corner_radius_top_right, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "corner_radius_bottom_right", null, 
				style.corner_radius_bottom_right, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "corner_radius_bottom_left", null, 
				style.corner_radius_bottom_left, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "corner_radius_top_left", null, 
				style.corner_radius_top_left, timing, transition_type,
				easing_type)
		
		t.interpolate_property(from, "expand_margin_top", null, 
				style.expand_margin_top, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "expand_margin_right", null, 
				style.expand_margin_right, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "expand_margin_bottom", null, 
				style.expand_margin_bottom, timing, transition_type,
				easing_type)
		t.interpolate_property(from, "expand_margin_left", null, 
				style.expand_margin_left, timing, transition_type,
				easing_type)
		
		if not style.shadow_color.a or not style.shadow_size:
			t.interpolate_property(from, "shadow_color:a", null,
					0, timing)
		elif not from.shadow_color.a or not from.shadow_size:
			var old_color := style.shadow_color
			old_color.a = 0
			t.interpolate_property(from, "shadow_color", old_color,
					style.shadow_color, timing)
		else:
			t.interpolate_property(from, "shadow_color", null,
					style.shadow_color, timing)
		
		t.interpolate_property(from, "shadow_offset", null,
				style.shadow_offset, timing, transition_type, easing_type)
		t.interpolate_property(from, "shadow_size", null,
				style.shadow_size, timing, transition_type, easing_type)
	
	if t and is_instance_valid(t) and t.is_inside_tree():
		t.start()


# Normal style setget.
# Sets the style of the panel
func set_normal_style(style: StyleBoxFlat) -> void:
	normal_style = style
	if is_inside_tree():
		$BG.add_stylebox_override("panel", normal_style)


# Detects hover
func _on_AnimButton_mouse_entered() -> void:
	is_mouse_inside = true
	if disabled:
		return
	if play_hover:
		hover_sfx.play()
	if pressed:
		return
	set_style("hover")
	grab_focus()


# Detects unhover
func _on_AnimButton_mouse_exited() -> void:
	is_mouse_inside = false
	if pressed or disabled:
		return
	set_style("normal")


# Detects pressed
func _on_AnimButton_button_down() -> void:
	if started_scene_transition:
		return
	pressing = true
	if action_mode == ACTION_MODE_BUTTON_PRESS and play_pressed:
		pressed_sfx.play()
	if disabled:
		return
	set_style("pressed")


# Detects released
func _on_AnimButton_button_up() -> void:
	pressing = false
	yield(get_tree(), "idle_frame")
	if action_mode == ACTION_MODE_BUTTON_RELEASE and \
			(is_mouse_inside or not is_visible_in_tree()):
		if play_pressed:
			pressed_sfx.play()
	if pressed or disabled:
		return
	if (is_mouse_inside or focused) and is_visible_in_tree():
		set_style("hover")
	else:
		set_style("normal")


# Detects disabled
func _on_AnimatedButton_draw() -> void:
	if previous_disabled != disabled:
		if disabled:
			set_style("disabled")
		elif pressed:
			set_style("pressed")
		elif is_mouse_inside or focused:
			set_style("hover")
		else:
			set_style("normal")
	previous_disabled = disabled


func _toggled(button_pressed: bool) -> void:
	if pressing or disabled or started_scene_transition:
		return
	if button_pressed:
		set_style("pressed")
	elif is_mouse_inside or focused:
		set_style("hover")
	else:
		set_style("normal")


func _on_AnimatedButton_hide() -> void:
	is_mouse_inside = false
	if disabled or started_scene_transition:
		return
	if current_focused == self:
		find_next_valid_focus().grab_focus()
	set_style("normal")


func _on_AnimatedButton_focus_entered() -> void:
	focused = true
	if disabled or started_scene_transition:
		return
	if play_hover:
		hover_sfx.play()
	if not pressed:
		set_style("hover")


func _on_AnimatedButton_focus_exited() -> void:
	focused = false
	if disabled or started_scene_transition or pressed:
		return
	set_style("normal")


func _on_AnimatedButton_gui_input(event: InputEvent) -> void:
	if not has_focus():
		grab_focus()


func _on_focus_changed(control: Control) -> void:
	current_focused = control
