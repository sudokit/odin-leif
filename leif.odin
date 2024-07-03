package leif

@(extra_linker_flags = "-lxcb -lmvec")
foreign import "system:leif"

import _c "core:c"

MenuItemCallback :: #type proc(menu_item: ^u32)

TextureFiltering :: enum i32 {
	LfTexFilterLinear = 0,
	LfTexFilterNearest,
}

ClickableItemState :: enum i32 {
	LfReleased = -1,
	LfIdle     = 0,
	LfHovered  = 1,
	LfClicked  = 2,
	LfHeld     = 3,
}

Color :: struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
}

KeyEvent :: struct {
	keycode:  i32,
	happened: bool,
	pressed:  bool,
}

MouseButtonEvent :: struct {
	button_code: i32,
	happened:    bool,
	pressed:     bool,
}

CursorPosEvent :: struct {
	x:        i32,
	y:        i32,
	happened: bool,
}

ScrollEvent :: struct {
	xoffset:  i32,
	yoffset:  i32,
	happened: bool,
}

CharEvent :: struct {
	charcode: i32,
	happened: bool,
}

Texture :: struct {
	id:     u32,
	width:  u32,
	height: u32,
}

Font :: struct {
	cdata:        rawptr,
	font_info:    rawptr,
	tex_width:    u32,
	tex_height:   u32,
	line_gap_add: u32,
	font_size:    u32,
	bitmap:       Texture,
	num_glyphs:   u32,
}

TextProps :: struct {
	width:          _c.float,
	height:         _c.float,
	end_x:          i32,
	end_y:          i32,
	rendered_count: u32,
}

InputField :: struct {
	cursor_index:             i32,
	width:                    i32,
	height:                   i32,
	start_height:             i32,
	buf:                      cstring,
	buf_size:                 u32,
	placeholder:              cstring,
	selected:                 bool,
	max_chars:                u32,
	selection_start:          i32,
	selection_end:            i32,
	mouse_selection_start:    i32,
	mouse_selection_end:      i32,
	selection_dir:            i32,
	mouse_dir:                i32,
	init:                     bool,
	char_callback:            #type proc(char: _c.char),
	insert_override_callback: #type proc(data: rawptr),
	key_callback:             #type proc(data: rawptr),
	retain_height:            bool,
}

Slider :: struct {
	val:          rawptr,
	handle_pos:   i32,
	init:         bool,
	min:          _c.float,
	max:          _c.float,
	held:         bool,
	selcted:      bool,
	width:        _c.float,
	height:       _c.float,
	handle_size:  u32,
	handle_color: Color,
}

UIElementProps :: struct {
	color:            Color,
	hover_color:      Color,
	text_color:       Color,
	hover_text_color: Color,
	border_color:     Color,
	padding:          _c.float,
	margin_left:      _c.float,
	margin_right:     _c.float,
	margin_top:       _c.float,
	margin_bottom:    _c.float,
	border_width:     _c.float,
	corner_radius:    _c.float,
}

AABB :: struct {
	pos:  vec2s,
	size: vec2s,
}

Theme :: struct {
	button_props:                     UIElementProps,
	div_props:                        UIElementProps,
	text_props:                       UIElementProps,
	image_props:                      UIElementProps,
	inputfield_props:                 UIElementProps,
	checkbox_props:                   UIElementProps,
	slider_props:                     UIElementProps,
	scrollbar_props:                  UIElementProps,
	font:                             Font,
	div_smooth_scroll:                bool,
	div_scroll_acceleration:          _c.float,
	div_scroll_max_velocity:          _c.float,
	div_scroll_amount_px:             _c.float,
	div_scroll_velocity_deceleration: _c.float,
	scrollbar_width:                  _c.float,
}

Div :: struct {
	id:             i64,
	aabb:           AABB,
	interact_state: ClickableItemState,
	scrollable:     bool,
	total_area:     vec2s,
}

@(default_calling_convention = "c")
foreign leif {

	@(link_name = "lf_init_glfw")
	init_glfw :: proc(display_width: u32, display_height: u32, glfw_window: rawptr) ---

	@(link_name = "lf_terminate")
	terminate :: proc() ---

	@(link_name = "lf_default_theme")
	default_theme :: proc() -> Theme ---

	@(link_name = "lf_get_theme")
	get_theme :: proc() -> Theme ---

	@(link_name = "lf_set_theme")
	set_theme :: proc(theme: Theme) ---

	@(link_name = "lf_resize_display")
	resize_display :: proc(display_width: u32, display_height: u32) ---

	@(link_name = "lf_load_font")
	load_font :: proc(filepath: cstring, size: u32) -> Font ---

	@(link_name = "lf_load_font_ex")
	load_font_ex :: proc(filepath: cstring, size: u32, bitmap_w: u32, bitmap_h: u32) -> Font ---

	@(link_name = "lf_load_texture")
	load_texture :: proc(filepath: cstring, flip: bool, filter: TextureFiltering) -> Texture ---

	@(link_name = "lf_load_texture_resized")
	load_texture_resized :: proc(filepath: cstring, flip: bool, filter: TextureFiltering, w: u32, h: u32) -> Texture ---

	@(link_name = "lf_load_texture_resized_factor")
	load_texture_resized_factor :: proc(filepath: cstring, flip: bool, filter: TextureFiltering, wfactor: _c.float, hfactor: _c.float) -> Texture ---

	@(link_name = "lf_load_texture_from_memory")
	load_texture_from_memory :: proc(data: rawptr, size: _c.size_t, flip: bool, filter: TextureFiltering) -> Texture ---

	@(link_name = "lf_load_texture_from_memory_resized")
	load_texture_from_memory_resized :: proc(data: rawptr, size: _c.size_t, flip: bool, filter: TextureFiltering, w: u32, h: u32) -> Texture ---

	@(link_name = "lf_load_texture_from_memory_resized_factor")
	load_texture_from_memory_resized_factor :: proc(data: rawptr, size: _c.size_t, flip: bool, filter: TextureFiltering, wfactor: _c.float, hfactor: _c.float) -> Texture ---

	@(link_name = "lf_load_texture_from_memory_resized_to_fit")
	load_texture_from_memory_resized_to_fit :: proc(data: rawptr, size: _c.size_t, flip: bool, filter: TextureFiltering, container_w: i32, container_h: i32) -> Texture ---

	@(link_name = "lf_load_texture_data")
	load_texture_data :: proc(filepath: cstring, width: ^i32, height: ^i32, channels: ^i32, flip: bool) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_resized")
	load_texture_data_resized :: proc(filepath: cstring, w: i32, h: i32, channels: ^i32, flip: bool) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_resized_factor")
	load_texture_data_resized_factor :: proc(filepath: cstring, wfactor: i32, hfactor: i32, width: ^i32, height: ^i32, channels: ^i32, flip: bool) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_from_memory")
	load_texture_data_from_memory :: proc(data: rawptr, size: _c.size_t, width: ^i32, height: ^i32, channels: ^i32, flip: bool) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_from_memory_resized")
	load_texture_data_from_memory_resized :: proc(data: rawptr, size: _c.size_t, channels: ^i32, o_w: ^i32, o_h: ^i32, flip: bool, w: u32, h: u32) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_from_memory_resized_to_fit_ex")
	load_texture_data_from_memory_resized_to_fit_ex :: proc(data: rawptr, size: _c.size_t, o_width: ^i32, o_height: ^i32, i_channels: i32, i_width: i32, i_height: i32, flip: bool, container_w: i32, container_h: i32) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_from_memory_resized_to_fit")
	load_texture_data_from_memory_resized_to_fit :: proc(data: rawptr, size: _c.size_t, o_width: ^i32, o_height: ^i32, o_channels: ^i32, flip: bool, container_w: i32, container_h: i32) -> ^_c.uchar ---

	@(link_name = "lf_load_texture_data_from_memory_resized_factor")
	load_texture_data_from_memory_resized_factor :: proc(data: rawptr, size: _c.size_t, width: ^i32, height: ^i32, channels: ^i32, flip: bool, wfactor: _c.float, hfactor: _c.float) -> ^_c.uchar ---

	@(link_name = "lf_create_texture_from_image_data")
	create_texture_from_image_data :: proc(filter: TextureFiltering, id: ^u32, width: i32, height: i32, channels: i32, data: ^_c.uchar) ---

	@(link_name = "lf_free_texture")
	free_texture :: proc(tex: ^Texture) ---

	@(link_name = "lf_free_font")
	free_font :: proc(font: ^Font) ---

	@(link_name = "lf_load_font_asset")
	load_font_asset :: proc(asset_name: cstring, file_extension: cstring, font_size: u32) -> Font ---

	@(link_name = "lf_load_texture_asset")
	load_texture_asset :: proc(asset_name: cstring, file_extension: cstring) -> Texture ---

	@(link_name = "lf_add_key_callback")
	add_key_callback :: proc(cb: rawptr) ---

	@(link_name = "lf_add_mouse_button_callback")
	add_mouse_button_callback :: proc(cb: rawptr) ---

	@(link_name = "lf_add_scroll_callback")
	add_scroll_callback :: proc(cb: rawptr) ---

	@(link_name = "lf_add_cursor_pos_callback")
	add_cursor_pos_callback :: proc(cb: rawptr) ---

	@(link_name = "lf_key_went_down")
	key_went_down :: proc(key: u32) -> bool ---

	@(link_name = "lf_key_is_down")
	key_is_down :: proc(key: u32) -> bool ---

	@(link_name = "lf_key_is_released")
	key_is_released :: proc(key: u32) -> bool ---

	@(link_name = "lf_key_changed")
	key_changed :: proc(key: u32) -> bool ---

	@(link_name = "lf_mouse_button_went_down")
	mouse_button_went_down :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_is_down")
	mouse_button_is_down :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_is_released")
	mouse_button_is_released :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_changed")
	mouse_button_changed :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_went_down_on_div")
	mouse_button_went_down_on_div :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_is_released_on_div")
	mouse_button_is_released_on_div :: proc(button: u32) -> bool ---

	@(link_name = "lf_mouse_button_changed_on_div")
	mouse_button_changed_on_div :: proc(button: u32) -> bool ---

	@(link_name = "lf_get_mouse_x")
	get_mouse_x :: proc() -> _c.double ---

	@(link_name = "lf_get_mouse_y")
	get_mouse_y :: proc() -> _c.double ---

	@(link_name = "lf_get_mouse_x_delta")
	get_mouse_x_delta :: proc() -> _c.double ---

	@(link_name = "lf_get_mouse_y_delta")
	get_mouse_y_delta :: proc() -> _c.double ---

	@(link_name = "lf_get_mouse_scroll_x")
	get_mouse_scroll_x :: proc() -> _c.double ---

	@(link_name = "lf_get_mouse_scroll_y")
	get_mouse_scroll_y :: proc() -> _c.double ---

	@(private)
	@(link_name = "_lf_div_begin_loc")
	div_begin_loc :: proc(pos: vec2s, size: vec2s, scrollable: bool, scroll: ^_c.float, scroll_velocity: ^_c.float, file: cstring = #file, line: i32 = #line) -> ^Div ---

	@(link_name = "lf_div_end")
	div_end :: proc() ---

	@(link_name = "_lf_item_loc")
	item :: proc(size: vec2s, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_button_loc")
	button :: proc(text: cstring, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_button_wide_loc")
	button_wide :: proc(text: ^_c.wchar_t, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_image_button_loc")
	image_button :: proc(img: Texture, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_image_button_fixed_loc")
	image_button_fixed :: proc(img: Texture, width: _c.float, height: _c.float, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_button_fixed_loc")
	button_fixed :: proc(text: cstring, width: _c.float, height: _c.float, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_button_fixed_wide_loc")
	button_fixed_wide :: proc(text: ^_c.wchar_t, width: _c.float, height: _c.float, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(private)
	@(link_name = "_lf_slider_int_loc")
	slider_int_loc :: proc(slider: ^Slider, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_progress_bar_val_loc")
	progress_bar_val :: proc(width: _c.float, height: _c.float, min: i32, max: i32, val: i32, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_progress_bar_int_loc")
	progress_bar_int :: proc(val: _c.float, min: _c.float, max: _c.float, width: _c.float, height: _c.float, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_progress_stripe_int_loc")
	progress_stripe_int :: proc(slider: ^Slider, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_checkbox_loc")
	checkbox :: proc(text: cstring, val: ^bool, tick_color: Color, tex_color: Color, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_checkbox_wide_loc")
	checkbox_wide :: proc(text: ^_c.wchar_t, val: ^bool, tick_color: Color, tex_color: Color, file: cstring = #file, line: i32 = #line) -> ClickableItemState ---

	@(link_name = "_lf_menu_item_list_loc")
	menu_item_list :: proc(items: ^cstring, item_count: u32, selected_index: i32, per_cb: MenuItemCallback, vertical: bool, file: cstring = #file, line: i32 = #line) -> i32 ---

	@(link_name = "_lf_menu_item_list_loc_wide")
	menu_item_list_wide :: proc(items: ^^_c.wchar_t, item_count: u32, selected_index: i32, per_cb: MenuItemCallback, vertical: bool, file: cstring = #file, line: i32 = #line) -> i32 ---

	@(link_name = "_lf_dropdown_menu_loc")
	dropdown_menu :: proc(items: ^cstring, placeholder: cstring, item_count: u32, width: _c.float, height: _c.float, selected_index: ^i32, opened: ^bool, file: cstring = #file, line: i32 = #line) ---

	@(link_name = "_lf_dropdown_menu_loc_wide")
	dropdown_menu_wide :: proc(items: ^^_c.wchar_t, placeholder: ^_c.wchar_t, item_count: u32, width: _c.float, height: _c.float, selected_index: ^i32, opened: ^bool, file: cstring) ---

	@(private)
	@(link_name = "_lf_input_text_loc")
	input_text_loc :: proc(input: ^InputField, file: cstring = #file, line: i32 = #line) ---

	@(link_name = "_lf_input_int_loc")
	input_int :: proc(input: ^InputField, file: cstring = #file, line: i32 = #line) ---

	@(link_name = "_lf_input_float_loc")
	input_float :: proc(input: ^InputField, file: cstring = #file, line: i32 = #line) ---

	@(link_name = "lf_input_insert_char_idx")
	input_insert_char_idx :: proc(input: ^InputField, c: _c.char, idx: u32) ---

	@(link_name = "lf_input_insert_str_idx")
	input_insert_str_idx :: proc(input: ^InputField, insert: cstring, len: u32, idx: u32) ---

	@(link_name = "lf_input_field_unselect_all")
	input_field_unselect_all :: proc(input: ^InputField) ---

	@(link_name = "lf_input_grabbed")
	input_grabbed :: proc() -> bool ---

	@(link_name = "lf_div_grab")
	div_grab :: proc(div: Div) ---

	@(link_name = "lf_div_ungrab")
	div_ungrab :: proc() ---

	@(link_name = "lf_div_grabbed")
	div_grabbed :: proc() -> bool ---

	@(link_name = "lf_get_grabbed_div")
	get_grabbed_div :: proc() -> Div ---

	@(link_name = "_lf_begin_loc")
	begin :: proc(file: cstring = #file, line: i32 = #line) ---

	@(link_name = "lf_end")
	end :: proc() ---

	@(link_name = "lf_next_line")
	next_line :: proc() ---

	@(link_name = "lf_text_dimension")
	text_dimension :: proc(str: cstring) -> vec2s ---

	@(link_name = "lf_text_dimension_ex")
	text_dimension_ex :: proc(str: cstring, wrap_point: _c.float) -> vec2s ---

	@(link_name = "lf_text_dimension_wide")
	text_dimension_wide :: proc(str: ^_c.wchar_t) -> vec2s ---

	@(link_name = "lf_text_dimension_wide_ex")
	text_dimension_wide_ex :: proc(str: ^_c.wchar_t, wrap_point: _c.float) -> vec2s ---

	@(link_name = "lf_button_dimension")
	button_dimension :: proc(text: cstring) -> vec2s ---

	@(link_name = "lf_get_text_end")
	get_text_end :: proc(str: cstring, start_x: _c.float) -> _c.float ---

	@(link_name = "lf_text")
	text :: proc(text: cstring) ---

	@(link_name = "lf_text_wide")
	text_wide :: proc(text: ^_c.wchar_t) ---

	@(link_name = "lf_set_text_wrap")
	set_text_wrap :: proc(wrap: bool) ---

	@(link_name = "lf_get_current_div")
	get_current_div :: proc() -> Div ---

	@(link_name = "lf_get_selected_div")
	get_selected_div :: proc() -> Div ---

	@(link_name = "lf_get_current_div_ptr")
	get_current_div_ptr :: proc() -> ^Div ---

	@(link_name = "lf_get_selected_div_ptr")
	get_selected_div_ptr :: proc() -> ^Div ---

	@(link_name = "lf_set_ptr_x")
	set_ptr_x :: proc(x: _c.float) ---

	@(link_name = "lf_set_ptr_y")
	set_ptr_y :: proc(y: _c.float) ---

	@(link_name = "lf_set_ptr_x_absolute")
	set_ptr_x_absolute :: proc(x: _c.float) ---

	@(link_name = "lf_set_ptr_y_absolute")
	set_ptr_y_absolute :: proc(y: _c.float) ---

	@(link_name = "lf_get_ptr_x")
	get_ptr_x :: proc() -> _c.float ---

	@(link_name = "lf_get_ptr_y")
	get_ptr_y :: proc() -> _c.float ---

	@(link_name = "lf_get_display_width")
	get_display_width :: proc() -> u32 ---

	@(link_name = "lf_get_display_height")
	get_display_height :: proc() -> u32 ---

	@(link_name = "lf_push_font")
	push_font :: proc(font: ^Font) ---

	@(link_name = "lf_pop_font")
	pop_font :: proc() ---

	@(link_name = "lf_text_render")
	text_render :: proc(pos: vec2s, str: cstring, font: Font, color: Color, wrap_point: i32, stop_point: vec2s, no_render: bool, render_solid: bool, start_index: i32, end_index: i32) -> TextProps ---

	@(link_name = "lf_text_render_wchar")
	text_render_wchar :: proc(pos: vec2s, str: ^_c.wchar_t, font: Font, color: Color, wrap_point: i32, stop_point: vec2s, no_render: bool, render_solid: bool, start_index: i32, end_index: i32) -> TextProps ---

	@(link_name = "lf_rect_render")
	rect_render :: proc(pos: vec2s, size: vec2s, color: Color, border_color: Color, border_width: _c.float, corner_radius: _c.float) ---

	@(link_name = "lf_image_render")
	image_render :: proc(pos: vec2s, color: Color, tex: Texture, border_color: Color, border_width: _c.float, corner_radius: _c.float) ---

	@(link_name = "lf_point_intersects_aabb")
	point_intersects_aabb :: proc(p: vec2s, aabb: AABB) -> bool ---

	@(link_name = "lf_aabb_intersects_aabb")
	aabb_intersects_aabb :: proc(a: AABB, b: AABB) -> bool ---

	@(link_name = "lf_push_style_props")
	push_style_props :: proc(props: UIElementProps) ---

	@(link_name = "lf_pop_style_props")
	pop_style_props :: proc() ---

	@(link_name = "lf_hovered")
	hovered :: proc(pos: vec2s, size: vec2s) -> bool ---

	@(link_name = "lf_area_hovered")
	area_hovered :: proc(pos: vec2s, size: vec2s) -> bool ---

	@(link_name = "lf_mouse_move_event")
	mouse_move_event :: proc() -> CursorPosEvent ---

	@(link_name = "lf_mouse_button_event")
	mouse_button_event :: proc() -> MouseButtonEvent ---

	@(link_name = "lf_mouse_scroll_event")
	mouse_scroll_event :: proc() -> ScrollEvent ---

	@(link_name = "lf_key_event")
	key_event :: proc() -> KeyEvent ---

	@(link_name = "lf_char_event")
	char_event :: proc() -> CharEvent ---

	@(link_name = "lf_set_cull_start_x")
	set_cull_start_x :: proc(x: _c.float) ---

	@(link_name = "lf_set_cull_start_y")
	set_cull_start_y :: proc(y: _c.float) ---

	@(link_name = "lf_set_cull_end_x")
	set_cull_end_x :: proc(x: _c.float) ---

	@(link_name = "lf_set_cull_end_y")
	set_cull_end_y :: proc(y: _c.float) ---

	@(link_name = "lf_unset_cull_start_x")
	unset_cull_start_x :: proc() ---

	@(link_name = "lf_unset_cull_start_y")
	unset_cull_start_y :: proc() ---

	@(link_name = "lf_unset_cull_end_x")
	unset_cull_end_x :: proc() ---

	@(link_name = "lf_unset_cull_end_y")
	unset_cull_end_y :: proc() ---

	@(link_name = "lf_set_image_color")
	set_image_color :: proc(color: Color) ---

	@(link_name = "lf_unset_image_color")
	unset_image_color :: proc() ---

	@(link_name = "lf_set_current_div_scroll")
	set_current_div_scroll :: proc(scroll: _c.float) ---

	@(link_name = "lf_get_current_div_scroll")
	get_current_div_scroll :: proc() -> _c.float ---

	@(link_name = "lf_set_current_div_scroll_velocity")
	set_current_div_scroll_velocity :: proc(scroll_velocity: _c.float) ---

	@(link_name = "lf_get_current_div_scroll_velocity")
	get_current_div_scroll_velocity :: proc() -> _c.float ---

	@(link_name = "lf_set_line_height")
	set_line_height :: proc(line_height: u32) ---

	@(link_name = "lf_get_line_height")
	get_line_height :: proc() -> u32 ---

	@(link_name = "lf_set_line_should_overflow")
	set_line_should_overflow :: proc(overflow: bool) ---

	@(link_name = "lf_set_div_hoverable")
	set_div_hoverable :: proc(hoverable: bool) ---

	@(link_name = "lf_push_element_id")
	push_element_id :: proc(id: i64) ---

	@(link_name = "lf_pop_element_id")
	pop_element_id :: proc() ---

	@(link_name = "lf_color_brightness")
	color_brightness :: proc(color: Color, brightness: _c.float) -> Color ---

	@(link_name = "lf_color_alpha")
	color_alpha :: proc(color: Color, a: u8) -> Color ---

	@(link_name = "lf_color_to_zto")
	color_to_zto :: proc(color: Color) -> vec4s ---

	@(link_name = "lf_color_from_hex")
	color_from_hex :: proc(hex: u32) -> Color ---

	@(link_name = "lf_color_from_zto")
	color_from_zto :: proc(zto: vec4s) -> Color ---

	@(link_name = "lf_image")
	image :: proc(tex: Texture) ---

	@(link_name = "lf_rect")
	rect :: proc(width: _c.float, height: _c.float, color: Color, corner_radius: _c.float) ---

	@(link_name = "lf_seperator")
	seperator :: proc() ---

	@(link_name = "lf_set_clipboard_text")
	set_clipboard_text :: proc(text: cstring) ---

	@(link_name = "lf_get_clipboard_text")
	get_clipboard_text :: proc() -> cstring ---

	@(link_name = "lf_set_no_render")
	set_no_render :: proc(no_render: bool) ---

}

