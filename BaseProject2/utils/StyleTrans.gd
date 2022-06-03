tool
class_name StyleTrans
extends Resource

# Overrideable timing variables
enum TIMING_OVERRIDES {
	bg_color = 1 << 0,
	border_color = 1 << 1,
	border_width = 1 << 2,
	corner_radius = 1 << 3,
	expand_margin = 1 << 4,
	shadow_color = 1 << 5,
	shadow_offset = 1 << 6,
	shadow_size = 1 << 7,
}

# Tween.TransitionType used during export hinting
enum TRANSITION_TYPES { 
	LINEAR = 0,
	SINE = 1,
	QUINT = 2,
	QUART = 3,
	QUAD = 4,
	EXPO = 5,
	ELASTIC = 6,
	CUBIC = 7,
	CIRC = 8,
	BOUNCE = 9,
	BACK = 10,
}

# Tween.EaseType used during export hinting
enum EASE_TYPES {
	IN = 0,
	OUT = 1,
	IN_OUT = 2,
	OUT_IN = 3,
}

var default_timing: float
var default_trans: int
var default_ease: int
var overrides: int setget _set_overrides

var bg_color_timing: float
var bg_color_trans: int
var bg_color_ease: int

var border_width_timing: float
var border_width_trans: int
var border_width_ease: int

var border_color_timing: float
var border_color_trans: int
var border_color_ease: int

var corner_radius_timing: float
var corner_radius_trans: int
var corner_radius_ease: int

var expand_margin_timing: float
var expand_margin_trans: int
var expand_margin_ease: int

var shadow_color_timing: float
var shadow_color_trans: int
var shadow_color_ease: int

var shadow_offset_timing: float
var shadow_offset_trans: int
var shadow_offset_ease: int

var shadow_size_timing: float
var shadow_size_trans: int
var shadow_size_ease: int


# Interpolates using the given tween from the given from_style to the member variable to_style
func trans_style(t: Tween, from_style: StyleBoxFlat, to_style: StyleBoxFlat) -> void:
	if _flags_has(overrides, TIMING_OVERRIDES.bg_color):
		t.interpolate_property(from_style, "bg_color", null, to_style.bg_color, bg_color_timing,
				bg_color_trans, bg_color_ease)
	else:
		t.interpolate_property(from_style, "bg_color", null, to_style.bg_color, default_timing,
				default_trans, default_ease)
	
	if _flags_has(overrides, TIMING_OVERRIDES.border_width):
		t.interpolate_property(from_style, "border_width_left", null, to_style.border_width_left,
				border_width_timing, border_width_trans, border_width_ease)
		t.interpolate_property(from_style, "border_width_right", null, to_style.border_width_right,
				border_width_timing, border_width_trans, border_width_ease)
		t.interpolate_property(from_style, "border_width_bottom", null, to_style.border_width_bottom,
				border_width_timing, border_width_trans, border_width_ease)
		t.interpolate_property(from_style, "border_width_top", null, to_style.border_width_top,
				border_width_timing, border_width_trans, border_width_ease)
	else:
		t.interpolate_property(from_style, "border_width_left", null, to_style.border_width_left,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "border_width_right", null, to_style.border_width_right,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "border_width_bottom", null, to_style.border_width_bottom,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "border_width_top", null, to_style.border_width_top,
				default_timing, default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.border_color):
		t.interpolate_property(from_style, "border_color", null, to_style.border_color,
				border_color_timing, border_color_trans, border_color_ease)
	else:
		t.interpolate_property(from_style, "border_color", null, to_style.border_color, default_timing,
				default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.corner_radius):
		t.interpolate_property(from_style, "corner_radius_bottom_left", null,
				to_style.corner_radius_bottom_left, corner_radius_timing, corner_radius_trans,
				corner_radius_ease)
		t.interpolate_property(from_style, "corner_radius_bottom_right", null,
				to_style.corner_radius_bottom_right, corner_radius_timing, corner_radius_trans,
				corner_radius_ease)
		t.interpolate_property(from_style, "corner_radius_top_left", null,
				to_style.corner_radius_top_left, corner_radius_timing, corner_radius_trans,
				corner_radius_ease)
		t.interpolate_property(from_style, "corner_radius_top_right", null,
				to_style.corner_radius_top_right, corner_radius_timing, corner_radius_trans, 
				corner_radius_ease)
	else:
		t.interpolate_property(from_style, "corner_radius_bottom_left", null,
				to_style.corner_radius_bottom_left, default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "corner_radius_bottom_right", null,
				to_style.corner_radius_bottom_right, default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "corner_radius_top_left", null,
				to_style.corner_radius_top_left, default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "corner_radius_top_right", null,
				to_style.corner_radius_top_right, default_timing, default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.expand_margin):
		t.interpolate_property(from_style, "expand_margin_bottom", null, to_style.expand_margin_bottom,
				expand_margin_timing, expand_margin_trans, expand_margin_ease)
		t.interpolate_property(from_style, "expand_margin_top", null, to_style.expand_margin_top,
				expand_margin_timing, expand_margin_trans, expand_margin_ease)
		t.interpolate_property(from_style, "expand_margin_right", null, to_style.expand_margin_right,
				expand_margin_timing, expand_margin_trans, expand_margin_ease)
		t.interpolate_property(from_style, "expand_margin_left", null, to_style.expand_margin_left,
				expand_margin_timing, expand_margin_trans, expand_margin_ease)
	else:
		t.interpolate_property(from_style, "expand_margin_bottom", null, to_style.expand_margin_bottom,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "expand_margin_top", null, to_style.expand_margin_top,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "expand_margin_right", null, to_style.expand_margin_right,
				default_timing, default_trans, default_ease)
		t.interpolate_property(from_style, "expand_margin_left", null, to_style.expand_margin_left,
				default_timing, default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.shadow_color):
		t.interpolate_property(from_style, "shadow_color", null, to_style.shadow_color,
				shadow_color_timing, shadow_color_trans, shadow_color_ease)
	else:
		t.interpolate_property(from_style, "shadow_color", null, to_style.shadow_color, default_timing,
				default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.shadow_offset):
		t.interpolate_property(from_style, "shadow_offset", null, to_style.shadow_offset,
				shadow_offset_timing, shadow_offset_trans, shadow_offset_ease)
	else:
		t.interpolate_property(from_style, "shadow_offset", null, to_style.shadow_offset, default_timing,
				default_trans, default_ease)

	if _flags_has(overrides, TIMING_OVERRIDES.shadow_size):
		t.interpolate_property(from_style, "shadow_size", null, to_style.shadow_size, shadow_size_timing,
				shadow_size_trans, shadow_size_ease)
	else:
		t.interpolate_property(from_style, "shadow_size", null, to_style.shadow_size, default_timing,
				default_trans, default_ease)


# Sets the export list properties
func _get_property_list() -> Array:
	var props := []
	props.append({
		name = "timing",
		type = TYPE_NIL,
		usage = PROPERTY_USAGE_CATEGORY
	})
	props.append({
		name = "default_timing",
		type = TYPE_REAL,
		hint = PROPERTY_HINT_RANGE,
		hint_string = "0,1"
	})
	props.append({
		name = "default_trans",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = TRANSITION_TYPES
	})
	props.append({
		name = "default_ease",
		type = TYPE_INT,
		hint = PROPERTY_HINT_ENUM,
		hint_string = EASE_TYPES
	})
	props.append({
		name = "overrides",
		type = TYPE_INT,
		hint = PROPERTY_HINT_FLAGS,
		hint_string = TIMING_OVERRIDES
	})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.bg_color):
		props.append({
			name = "bg_color",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "bg_color"
		})
		props.append({
			name = "bg_color_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "bg_color_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "bg_color_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.border_width):
		props.append({
			name = "border_width",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "border_width"
		})
		props.append({
			name = "border_width_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "border_width_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "border_width_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.border_color):
		props.append({
			name = "border_color",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "border_color"
		})
		props.append({
			name = "border_color_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "border_color_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "border_color_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.corner_radius):
		props.append({
			name = "corner_radius",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "corner_radius"
		})
		props.append({
			name = "corner_radius_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "corner_radius_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "corner_radius_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.expand_margin):
		props.append({
			name = "expand_margin",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "expand_margin"
		})
		props.append({
			name = "expand_margin_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "expand_margin_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "expand_margin_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.shadow_color):
		props.append({
			name = "shadow_color",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "shadow_color"
		})
		props.append({
			name = "shadow_color_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "shadow_color_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "shadow_color_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.shadow_offset):
		props.append({
			name = "shadow_offset",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "shadow_offset"
		})
		props.append({
			name = "shadow_offset_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "shadow_offset_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "shadow_offset_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	#######################################
	if _flags_has(overrides, TIMING_OVERRIDES.shadow_size):
		props.append({
			name = "shadow_size",
			type = TYPE_NIL,
			usage = PROPERTY_USAGE_GROUP,
			hint_string = "shadow_size"
		})
		props.append({
			name = "shadow_size_timing",
			type = TYPE_REAL,
			hint = PROPERTY_HINT_RANGE,
			hint_string = "0,1"
		})
		props.append({
			name = "shadow_size_trans",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = TRANSITION_TYPES
		})
		props.append({
			name = "shadow_size_ease",
			type = TYPE_INT,
			hint = PROPERTY_HINT_ENUM,
			hint_string = EASE_TYPES
		})
	return props


# Updates export list
func _set_overrides(val: int) -> void:
	overrides = val
	property_list_changed_notify()


# Returns true if flags contains the check_flag
func _flags_has(flags: int, check_flag: int) -> bool:
	return flags & check_flag == check_flag
