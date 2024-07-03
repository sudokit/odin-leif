package leif

import "vendor:glfw"

Color :: distinct [4]u8
vec2 :: distinct [2]f32
vec3 :: distinct [3]f32
vec4 :: distinct [4]f16

//+ structs

// events
KeyEvent :: struct {
	keycode:           i32,
	happened, pressed: bool,
}

MouseButtonEvent :: struct {
	button_code:       i32,
	happened, pressed: bool,
}

CursorPosEvent :: struct {
	x, y:     i32,
	happened: bool,
}

ScrollEvent :: struct {
	xoffset, yoffset: i32,
	happened:         bool,
}

CharEvent :: struct {
	charcode: i32,
	happened: bool,
}

// other
AABB :: struct {
	pos, size: [2]f32,
}

Texture :: struct {
	id:            u32,
	width, height: u32,
}

Font :: struct {
	cdata:                   rawptr,
	font_info:               rawptr,
	tex_width, tex_height:   u32,
	line_gap_add, font_size: u32,
	bitmap:                  Texture,
	num_glyphs:              u32,
}

TextProps :: struct {
	width, height:  f32,
	end_x, end_y:   i32,
	rendered_count: u32,
}

InputField :: struct {
	cursor_index, width, height, start_height:                                  i32,
	buf:                                                                        cstring,
	buf_size:                                                                   u32,
	placeholder:                                                                cstring,
	selected:                                                                   bool,
	max_chars:                                                                  u32,
	selection_start, selection_end, mouse_selection_start, mouse_selection_end: i32,
	selection_dir, mouse_dir:                                                   i32,
	_init:                                                                      bool,
	char_callback:                                                              proc "c" (
		input: u8,
	),
	insert_override_callback:                                                   proc "c" (
		data: rawptr,
	),
	key_callback:                                                               proc "c" (
		data: rawptr,
	),
}

Slider :: struct {
	val:            rawptr,
	handle_pos:     i32,
	_init:          bool,
	min, max:       f32,
	held, selected: bool,
	width, height:  f32,
	handle_size:    u32,
	handle_color:   Color,
}

UIElementProps :: struct {
	color, hover_color:           Color,
	text_color, hover_text_color: Color,
	border_color:                 Color,
	padding:                      f32,
	margin_left, margin_right:    f32,
	margin_top, margin_bottom:    f32,
	border_width, border_height:  f32,
	corner_radius:                f32,
}

Theme :: struct {
	button_props, div_props, text_props, image_props, inputfield_props, checkbox_props, slider_props, scrollbar_props: UIElementProps,
	font:                                                                                                              Font,
	div_smooth_scroll:                                                                                                 bool,
	div_scroll_acceleration, div_scroll_max_velocity:                                                                  f32,
	div_scroll_amount_px:                                                                                              f32,
	div_scroll_velocity_deceleration:                                                                                  f32,
	scrollbar_width:                                                                                                   f32,
}

Div :: struct {
	id:             i64,
	aabb:           AABB,
	interact_state: ClickableItemState,
	scrollable:     bool,
	total_area:     vec2,
}

// idk
MenuItemCallback :: #type proc "c" (item: u32)

//+ enums
TextureFiltering :: enum {
	TEX_FILTER_LINEAR = 0,
	TEX_FILTER_NEAREST,
}

ClickableItemState :: enum {
	RELEASED = -1,
	IDLE     = 0,
	HOVERED  = 1,
	CLICKED  = 2,
	HELD     = 3,
}

//+ defines

PRIMARY_ITEM_COLOR :: Color{133, 136, 148, 255}
SECONDARY_ITEM_COLOR :: Color{96, 100, 107, 255}

NO_COLOR :: Color{0, 0, 0, 0}
WHITE :: Color{255, 255, 255, 255}
BLACK :: Color{0, 0, 0, 255}
RED :: Color{255, 0, 0, 255}
GREEN :: Color{0, 255, 0, 255}
BLUE :: Color{0, 0, 255, 255}

//+ functions
@(extra_linker_flags = "-lxcb -lmvec")
foreign import leiflib "system:leif"

@(default_calling_convention = "c", link_prefix = "lf_")
foreign leiflib {
	// void lf_init_glfw(uint32_t display_width, uint32_t display_height, void* glfw_window);
	init_glfw :: proc(display_width, display_height: u32, glfw_window: glfw.WindowHandle) ---

	// void lf_terminate();
	terminate :: proc() ---

	// LfTheme lf_default_theme();
	default_theme :: proc() -> Theme ---

	// LfTheme lf_get_theme();
	get_theme :: proc() -> Theme ---

	// void lf_set_theme(LfTheme theme);
	set_theme :: proc(theme: Theme) ---

	// void lf_resize_display(uint32_t display_width, uint32_t display_height);
	resize_display :: proc(display_width, display_height: u32) ---

	// LfFont lf_load_font(const char* filepath, uint32_t size);
	load_font :: proc(filepath: cstring, size: u32) -> Font ---

	// LfFont lf_load_font_ex(const char* filepath, uint32_t size, uint32_t bitmap_w, uint32_t bitmap_h);
	load_font_ex :: proc(filepath: cstring, size, bitmap_w, bitmap_h: u32) -> Font ---

	// LfTexture lf_load_texture(const char* filepath, bool flip, LfTextureFiltering filter);
	load_texture :: proc(filepath: cstring, flip: bool, filter: TextureFiltering) -> Texture ---

	// LfTexture lf_load_texture_resized(const char* filepath, bool flip, LfTextureFiltering filter, uint32_t w, uint32_t h);
	load_texture_resied :: proc(filepath: cstring, flip: bool, filter: TextureFiltering, w, h: u32) -> Texture ---

	// LfTexture lf_load_texture_resized_factor(const char* filepath, bool flip, LfTextureFiltering filter, float wfactor, float hfactor);
	load_texture_resized_factor :: proc(filepath: cstring, flip: bool, filter: TextureFiltering, wfactor, hfactor: f32) -> Texture ---

	// LfTexture lf_load_texture_from_memory(const void* data, size_t size, bool flip, LfTextureFiltering filter);
	load_texture_from_memory :: proc(data: rawptr, size: uint, flip: bool, filter: TextureFiltering) -> Texture ---

	// LfTexture lf_load_texture_from_memory_resized(const void* data, size_t size, bool flip, LfTextureFiltering filter, uint32_t w, uint32_t h);
	load_texture_from_memory_resized :: proc(data: rawptr, size: uint, flip: bool, filter: TextureFiltering, w, h: u32) -> Texture ---

	// LfTexture lf_load_texture_from_memory_resized_factor(const void* data, size_t size, bool flip, LfTextureFiltering filter, float wfactor, float hfactor);
	load_texture_from_memory_resized_factor :: proc(data: rawptr, size: uint, flip: bool, filter: TextureFiltering, wfactor, hfactor: f32) -> Texture ---

	// LfTexture lf_load_texture_from_memory_resized_to_fit(const void* data, size_t size, bool flip, LfTextureFiltering filter, int32_t container_w, int32_t container_h);
	load_texture_from_memory_resized_to_fit :: proc(data: rawptr, size: uint, flip: bool, filter: TextureFiltering, container_w, container_h: i32) -> Texture ---

	// unsigned char* lf_load_texture_data(const char* filepath, int32_t* width, int32_t* height, int32_t* channels, bool flip);
	load_texture_data :: proc(filepath: cstring, width, height, channels: ^i32, flip: bool) -> ^u8 ---

	// unsigned char* lf_load_texture_data_resized(const char* filepath, int32_t w, int32_t h, int32_t* channels, bool flip);
	load_texture_data_resized :: proc(filepath: cstring, w, h: i32, channels: ^i32, flip: bool) -> ^u8 ---

	// unsigned char* lf_load_texture_data_resized_factor(const char* filepath, int32_t wfactor, int32_t hfactor, int32_t* width, int32_t* height, int32_t* channels, bool flip);
	load_texture_data_resized_factor :: proc(filepath: cstring, wfactor, hfactor: i32, width, height, channels: ^i32, flip: bool) -> ^u8 ---

	// unsigned char* lf_load_texture_data_from_memory(const void* data, size_t size, int32_t* width, int32_t* height, int32_t* channels, bool flip);
	load_texture_data_from_memory :: proc(data: rawptr, size: uint, width, height, channels: ^i32, flip: bool) -> ^u8 ---

	// unsigned char* lf_load_texture_data_from_memory_resized(const void* data, size_t size, int32_t* channels, int32_t* o_w, int32_t* o_h, bool flip, uint32_t w, uint32_t h);
	load_texture_data_from_memory_resized :: proc(data: rawptr, size: uint, channels, o_w, o_h: ^i32, flip: bool, w, h: u32) -> ^u8 ---

	// unsigned char* lf_load_texture_data_from_memory_resized_to_fit_ex(const void* data, size_t size, int32_t* o_width, int32_t* o_height, int32_t i_channels, 
	//     int32_t i_width, int32_t i_height, bool flip, int32_t container_w, int32_t container_h);
	load_texture_from_memory_resized_to_fit_ex :: proc(data: rawptr, size: uint, o_width, o_height: ^i32, i_channels, i_width, i_height: i32, flip: bool, container_w, container_h: i32) -> ^u8 ---

	// unsigned char* lf_load_texture_data_from_memory_resized_to_fit(const void* data, size_t size, int32_t* o_width, int32_t* o_height, int32_t* o_channels,
	//     bol flip, int32_t container_w, int32_t container_h);
	load_texture_data_from_memory_resized_to_fit :: proc(data: rawptr, size: uint, o_width, o_height, o_channels: ^i32, flip: bool, container_w, container_h: i32) -> ^u8 ---

	// unsigned char* lf_load_texture_data_from_memory_resized_factor(const void* data, size_t size, int32_t* width, int32_t* height, int32_t* channels, bool flip, float wfactor, float hfactor);
	load_texture_data_from_memory_resized_factor :: proc(data: rawptr, size: uint, width, height, channels: ^i32, flip: bool, wfactor, hfactor: f32) -> ^u8 ---

	// void lf_create_texture_from_image_data(LfTextureFiltering filter, uint32_t* id, int32_t width, int32_t height, int32_t channels, unsigned char* data); 
	create_texture_from_image_data :: proc(filter: TextureFiltering, id: ^u32, width, height, channels: i32, data: rawptr) ---

	// void lf_free_texture(LfTexture* tex);
	free_texture :: proc(tex: ^Texture) ---

	// void lf_free_font(LfFont* font);
	free_font :: proc(font: ^Font) ---

	// LfFont lf_load_font_asset(const char* asset_name, const char* file_extension, uint32_t font_size);
	load_font_asset :: proc(asset_name: cstring, file_extension: cstring, font_size: u32) -> Font ---

	// LfTexture lf_load_texture_asset(const char* asset_name, const char* file_extension); 
	load_texture_asset :: proc(asset_name: cstring, file_extension: cstring) -> Texture ---

	// void lf_add_key_callback(void* cb);
	add_key_callback :: proc(cb: rawptr) ---

	// void lf_add_mouse_button_callback(void* cb);
	add_mouse_button_callback :: proc(cb: rawptr) ---

	// void lf_add_scroll_callback(void* cb);
	add_scroll_callback :: proc(cb: rawptr) ---

	// void lf_add_cursor_pos_callback(void* cb);
	add_cursor_pos_callback :: proc(cb: rawptr) ---

	// bool lf_key_went_down(uint32_t key);
	key_went_down :: proc(key: u32) ---

	// bool lf_key_is_down(uint32_t key);
	key_is_down :: proc(key: u32) ---

	// bool lf_key_is_released(uint32_t key);
	key_is_released :: proc(key: u32) ---

	// bool lf_key_changed(uint32_t key);
	key_changed :: proc(key: u32) ---

	// bool lf_mouse_button_went_down(uint32_t button);
	mouse_button_went_down :: proc(button: u32) ---

	// bool lf_mouse_button_is_down(uint32_t button);
	mouse_button_is_down :: proc(button: u32) ---

	// bool lf_mouse_button_is_released(uint32_t button);
	mouse_button_is_released :: proc(button: u32) ---

	// bool lf_mouse_button_changed(uint32_t button);
	mouse_button_changed :: proc(button: u32) ---

	// bool lf_mouse_button_went_down_on_div(uint32_t button);
	mouse_button_went_down_on_div :: proc(button: u32) ---

	// bool lf_mouse_button_is_released_on_div(uint32_t button);
	mouse_button_is_released_on_div :: proc(button: u32) ---

	// bool lf_mouse_button_changed_on_div(uint32_t button);
	mouse_button_changed_on_div :: proc(button: u32) ---

	// double lf_get_mouse_x();
	get_mouse_x :: proc() -> f64 ---

	// double lf_get_mouse_y();
	get_mouse_y :: proc() -> f64 ---

	// double lf_get_mouse_x_delta();
	get_mouse_x_delta :: proc() -> f64 ---

	// double lf_get_mouse_y_delta();
	get_mouse_y_delta :: proc() -> f64 ---

	// double lf_get_mouse_scroll_x();
	get_mouse_scroll_x :: proc() -> f64 ---

	// double lf_get_mouse_scroll_y();
	get_mouse_scroll_y :: proc() -> f64 ---

	// void lf_div_end();
	div_end :: proc() ---

	// void lf_input_insert_char_idx(LfInputField* input, char c, uint32_t idx);
	input_insert_char_idx :: proc(input: ^InputField, c: u8, idx: u32) ---

	// void lf_input_insert_str_idx(LfInputField* input, const char* insert, uint32_t len, uint32_t idx);
	input_insert_str_idx :: proc(input: ^InputField, insert: ^u8, len, idx: u32) ---

	// void lf_input_field_unselect_all(LfInputField* input);
	input_field_unselect_all :: proc(input: ^InputField) ---

	// bool lf_input_grabbed();
	input_grabbed :: proc() -> bool ---

	// void lf_div_grab(LfDiv div);
	div_grab :: proc(div: Div) ---

	// void lf_div_ungrab();
	div_ungrab :: proc() ---

	// bool lf_div_grabbed();
	div_grabbed :: proc() -> bool ---

	// LfDiv lf_get_grabbed_div();
	get_grabbed_div :: proc() -> Div ---


	// void lf_end();
	end :: proc() ---

	// void lf_next_line();
	next_line :: proc() ---

	// vec2s lf_text_dimension(const char* str);
	text_dimension :: proc(str: cstring) -> vec2 ---

	// vec2s lf_text_dimension_ex(const char* str, float wrap_point);
	text_dimension_ex :: proc(str: cstring, wrap_point: f32) -> vec2 ---

	// vec2s lf_text_dimension_wide(const wchar_t* str);
	// text_dimension_wide :: proc(str: cstring) -> vec2 ---

	// vec2s lf_text_dimension_wide_ex(const wchar_t* str, float wrap_point);
	// text_dimension_wide_ex :: proc(str: cstring, wrap_point: f32) -> vec2 ---

	// vec2s lf_button_dimension(const char* text);
	button_dimensions :: proc(text: cstring) -> vec2 ---

	// float lf_get_text_end(const char* str, float start_x);
	get_text_end :: proc(str: cstring, start_x: f32) -> f32 ---

	// void lf_text(const char* text);
	text :: proc(text: cstring) ---

	// void lf_text_wide(const wchar_t* text);
	// text_wide :: proc(text: cstring) --- // not sure

	// void lf_set_text_wrap(bool wrap);
	set_text_wrap :: proc(wrap: bool) ---

	// LfDiv lf_get_current_div();
	get_current_div :: proc() -> Div ---

	// LfDiv lf_get_selected_div();
	get_selected_div :: proc() -> Div ---

	// LfDiv* lf_get_current_div_ptr();
	get_current_div_ptr :: proc() -> ^Div ---

	// LfDiv* lf_get_selected_div_ptr();
	get_selected_div_ptr :: proc() -> ^Div ---

	// void lf_set_ptr_x(float x);
	set_ptr_x :: proc(x: f32) ---

	// void lf_set_ptr_y(float y);
	set_ptr_y :: proc(y: f32) ---

	// void lf_set_ptr_x_absolute(float x);
	set_ptr_x_absolute :: proc(x: f32) ---

	// void lf_set_ptr_y_absolute(float y);
	set_ptr_y_absolute :: proc(y: f32) ---

	// float lf_get_ptr_x();
	get_ptr_x :: proc() -> f32 ---

	// float lf_get_ptr_y();
	get_ptr_y :: proc() -> f32 ---

	// uint32_t lf_get_display_width();
	get_display_width :: proc() -> u32 ---

	// uint32_t lf_get_display_height();
	get_display_height :: proc() -> u32 ---

	// void lf_push_font(LfFont* font);
	push_font :: proc(font: ^Font) ---

	// void lf_pop_font();
	pop_font :: proc() ---

	// LfTextProps lf_text_render(vec2s pos, const char* str, LfFont font, LfColor color, 
	//         int32_t wrap_point, vec2s stop_point, bool no_render, bool render_solid, int32_t start_index, int32_t end_index);
	text_render :: proc(pos: vec2, str: cstring, font: Font, color: Color, wrap_point: i32, stop_point: vec2, no_render, render_solid: bool, start_index, end_index: i32) -> TextProps ---

	// LfTextProps lf_text_render_wchar(vec2s pos, const wchar_t* str, LfFont font, LfColor color, 
	//                            int32_t wrap_point, vec2s stop_point, bool no_render, bool render_solid, int32_t start_index, int32_t end_index);
	// text_render_wchar :: proc(pos: vec2, str: cstring, font: Font, color: Color, wrap_point: i32, stop_point: vec2, no_render, render_solid: bool, start_index, end_index: i32) -> TextProps --- // not sure

	// void lf_rect_render(vec2s pos, vec2s size, LfColor color, LfColor border_color, float border_width, float corner_radius);
	rect_render :: proc(pos, size: vec2, color, border_color: Color, border_width, corner_radius: f32) ---

	// void lf_image_render(vec2s pos, LfColor color, LfTexture tex, LfColor border_color, float border_width, float corner_radius);
	image_render :: proc(pos: vec2, color: Color, tex: Texture, border_color: Color, border_width, corner_radius: f32) ---

	// bool lf_point_intersects_aabb(vec2s p, LfAABB aabb);
	point_intersects_aabb :: proc(p: vec3, aabb: AABB) -> bool ---

	// bool lf_aabb_intersects_aabb(LfAABB a, LfAABB b);
	aabb_intersects_aabb :: proc(a, b: AABB) -> bool ---

	// void lf_push_style_props(LfUIElementProps props);
	push_style_props :: proc(props: UIElementProps) ---

	// void lf_pop_style_props();
	pop_style_props :: proc() ---

	// bool lf_hovered(vec2s pos, vec2s size);
	hovered :: proc(pos, size: vec2) -> bool ---

	// bool lf_area_hovered(vec2s pos, vec2s size);
	area_hovered :: proc(pos, size: vec2) -> bool ---

	// LfCursorPosEvent lf_mouse_move_event();
	mouse_move_event :: proc() -> CursorPosEvent ---

	// LfMouseButtonEvent lf_mouse_button_event();
	mouse_button_event :: proc() -> MouseButtonEvent ---

	// LfScrollEvent lf_mouse_scroll_event();
	mouse_scroll_event :: proc() -> ScrollEvent ---

	// LfKeyEvent lf_key_event();
	key_event :: proc() -> KeyEvent ---

	// LfCharEvent lf_char_event();
	char_event :: proc() -> CharEvent ---

	// void lf_set_cull_start_x(float x);
	set_cull_start_x :: proc(x: f32) ---

	// void lf_set_cull_start_y(float y);
	set_cull_start_y :: proc(y: f32) ---

	// void lf_set_cull_end_x(float x);
	set_cull_end_x :: proc(x: f32) ---

	// void lf_set_cull_end_y(float y);  
	set_cull_end_y :: proc(y: f32) ---

	// void lf_unset_cull_start_x();
	unset_cull_start_x :: proc() ---

	// void lf_unset_cull_start_y();
	unset_cull_start_y :: proc() ---

	// void lf_unset_cull_end_x();
	unset_cull_end_x :: proc() ---

	// void lf_unset_cull_end_y();
	unset_cull_end_y :: proc() ---

	// void lf_set_image_color(LfColor color);
	set_image_color :: proc(color: Color) ---

	// void lf_unset_image_color();
	unset_image_color :: proc() ---

	// void lf_set_current_div_scroll(float scroll); 
	set_current_div_scroll :: proc(scroll: f32) ---

	// float lf_get_current_div_scroll(); 
	get_current_div_scroll :: proc() -> f32 ---

	// void lf_set_current_div_scroll_velocity(float scroll_velocity);
	set_current_div_scroll_velocity :: proc(scroll_velocity: f32) ---

	// float lf_get_current_div_scroll_velocity();
	get_current_div_scroll_velocity :: proc() -> f32 ---

	// void lf_set_line_height(uint32_t line_height);
	set_line_height :: proc(line_height: u32) ---

	// uint32_t lf_get_line_height();
	get_line_height :: proc() -> u32 ---

	// void lf_set_line_should_overflow(bool overflow);
	set_line_should_overflow :: proc(overflow: bool) ---

	// void lf_set_div_hoverable(bool hoverable);
	set_div_hoverable :: proc(hoverable: bool) ---

	// void lf_push_element_id(int64_t id);
	push_element_id :: proc(id: i64) ---

	// void lf_pop_element_id();
	pop_element_id :: proc() ---

	// LfColor lf_color_brightness(LfColor color, float brightness);
	color_brightness :: proc(color: Color, brightness: f32) -> Color ---

	// LfColor lf_color_alpha(LfColor color, uint8_t a);
	color_alpha :: proc(color: Color, a: u8) -> Color ---

	// vec4s lf_color_to_zto(LfColor color);
	color_to_zto :: proc(color: Color) -> vec4 ---

	// LfColor lf_color_from_hex(uint32_t hex);
	color_from_hex :: proc(hex: u32) -> Color ---

	// LfColor lf_color_from_zto(vec4s zto);
	color_from_zto :: proc(zto: vec4) -> Color ---

	// void lf_image(LfTexture tex);
	image :: proc(tex: Texture) ---

	// void lf_rect(float width, float height, LfColor color, float corner_radius);
	rect :: proc(width, height: f32, color: Color, corner_radius: f32) ---

	// void lf_seperator();
	seperator :: proc() ---

	// void lf_set_clipboard_text(const char* text);
	set_clipboard_text :: proc(text: cstring) ---

	// char* lf_get_clipboard_text();
	get_clipboard_text :: proc() -> cstring ---

	// void lf_set_no_render(bool no_render);
	set_no_render :: proc(no_render: bool) ---
}


@(private)
@(default_calling_convention = "c", link_prefix = "_lf_")
foreign leiflib {

	// #define lf_begin() _lf_begin_loc(__FILE__, __LINE__)
	// void _lf_begin_loc(const char* file, int32_t line);
	begin_loc :: proc(file: cstring, line: i32) ---

	// #define lf_div_begin(pos, size, scrollable) {\
	//     static float scroll = 0.0f; \
	//     static float scroll_velocity = 0.0f; \
	//     _lf_div_begin_loc(pos, size, scrollable, &scroll, &scroll_velocity, __FILE__, __LINE__);\
	// }

	// #define lf_div_begin_ex(pos, size, scrollable, scroll_ptr, scroll_velocity_ptr) _lf_div_begin_loc(pos, size, scrollable, scroll_ptr, scroll_velocity_ptr, __FILE__, __LINE__);

	// LfDiv* _lf_div_begin_loc(vec2s pos, vec2s size, bool scrollable, float* scroll, 
	//         float* scroll_velocity, const char* file, int32_t line);
	div_begin_loc :: proc(pos, size: vec2, scrollable: bool, scroll, scroll_velocity: ^f32, file: cstring, line: i32) -> ^Div ---

	// LfClickableItemState _lf_item_loc(vec2s size,  const char* file, int32_t line);
	// #define lf_item(size) _lf_item_loc(size, __FILE__, __LINE__)
	item_loc :: proc(size: vec2, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_button(text) _lf_button_loc(text, __FILE__, __LINE__)
	// LfClickableItemState _lf_button_loc(const char* text, const char* file, int32_t line);
	button_loc :: proc(text: cstring, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_button_wide(text) _lf_button_wide_loc(text, __FILE__, __LINE__)
	// LfClickableItemState _lf_button_wide_loc(const wchar_t* text, const char* file, int32_t line);

	// #define lf_image_button(img) _lf_image_button_loc(img, __FILE__, __LINE__)
	// LfClickableItemState _lf_image_button_loc(LfTexture img, const char* file, int32_t line);
	image_button_loc :: proc(img: Texture, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_image_button_fixed(img, width, height) _lf_image_button_fixed_loc(img, width, height, __FILE__, __LINE__)
	// LfClickableItemState _lf_image_button_fixed_loc(LfTexture img, float width, float height, const char* file, int32_t line);
	image_button_fixed_loc :: proc(img: Texture, width, height: f32, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_button_fixed(text, width, height) _lf_button_fixed_loc(text, width, height, __FILE__, __LINE__)
	// LfClickableItemState _lf_button_fixed_loc(const char* text, float width, float height, const char* file, int32_t line);
	button_fixed_loc :: proc(text: cstring, width, height: f32, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_button_fixed_wide(text, width, height) _lf_button_fixed_loc_wide(text, width, height, __FILE__, __LINE__)
	// LfClickableItemState _lf_button_fixed_wide_loc(const wchar_t* text, float width, float height, const char* file, int32_t line);

	// #define lf_slider_int(slider) _lf_slider_int_loc(slider, __FILE__, __LINE__)
	// LfClickableItemState _lf_slider_int_loc(LfSlider* slider, const char* file, int32_t line);
	slider_int_loc :: proc(slider: ^Slider, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_slider_int_inl_ex(slider_val, slider_min, slider_max, slider_width, slider_height, slider_handle_size, state) { \
	//   static LfSlider slider = { \
	//     .val = slider_val, \
	//     .handle_pos = 0, \
	//     .min = slider_min, \
	//     .max = slider_max, \
	//     .width = slider_width, \
	//     .height = slider_height, \
	//     .handle_size = slider_handle_size \
	//   }; \
	//   state = lf_slider_int(&slider); \
	// } \

	// #define lf_slider_int_inl(slider_val, slider_min, slider_max, state) lf_slider_int_inl_ex(slider_val, slider_min, slider_max, lf_get_current_div().aabb.size.x / 2.0f, 5, 0, state)

	// #define lf_progress_bar_val(width, height, min, max, val) _lf_progress_bar_val_loc(width, height, min, max, val, __FILE__, __LINE__)
	// LfClickableItemState _lf_progress_bar_val_loc(float width, float height, int32_t min, int32_t max, int32_t val, const char* file, int32_t line);
	progress_bar_val_loc :: proc(width, height: f32, min, max, val: i32, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_progress_bar_int(val, min, max, width, height) _lf_progress_bar_int_loc(val, min, max, width, height, __FILE__, __LINE__)
	// LfClickableItemState _lf_progress_bar_int_loc(float val, float min, float max, float width, float height, const char* file, int32_t line);
	progress_bar_int_loc :: proc(val, min, max, width, height: f32, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_progress_stripe_int(slider) _lf_progresss_stripe_int_loc(slider , __FILE__, __LINE__)
	// LfClickableItemState _lf_progress_stripe_int_loc(LfSlider* slider, const char* file, int32_t line);
	progress_stripe_int_loc :: proc(slider: ^Slider, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_checkbox(text, val, tick_color, tex_color) _lf_checkbox_loc(text, val, tick_color, tex_color, __FILE__, __LINE__)
	// LfClickableItemState _lf_checkbox_loc(const char* text, bool* val, LfColor tick_color, LfColor tex_color, const char* file, int32_t line);
	checkbox_loc :: proc(text: cstring, val: ^bool, tick_color, tex_color: Color, file: cstring, line: i32) -> ClickableItemState ---

	// #define lf_checkbox_wide(text, val, tick_color, tex_color) _lf_checkbox_wide_loc(text, val, tick_color, tex_color, __FILE__, __LINE__)
	// LfClickableItemState _lf_checkbox_wide_loc(const wchar_t* text, bool* val, LfColor tick_color, LfColor tex_color, const char* file, int32_t line);

	// #define lf_menu_item_list(items, item_count, selected_index, per_cb, vertical) _lf_menu_item_list_loc(__FILE__, __LINE__, items, item_count, selected_index, per_cb, vertical)
	// int32_t _lf_menu_item_list_loc(const char** items, uint32_t item_count, int32_t selected_index, LfMenuItemCallback per_cb, bool vertical, const char* file, int32_t line);
	menu_item_list_loc :: proc(items: []cstring, item_count, selected_index: i32, per_cb: MenuItemCallback, vertical: bool, file: cstring, line: i32) -> i32 ---

	// #define lf_menu_item_list_wide(items, item_count, selected_index, per_cb, vertical) _lf_menu_item_list_loc_wide(__FILE__, __LINE__, items, item_count, selected_index, per_cb, vertical)
	// int32_t _lf_menu_item_list_loc_wide(const wchar_t** items, uint32_t item_count, int32_t selected_index, LfMenuItemCallback per_cb, bool vertical, const char* file, int32_t line);

	// #define lf_dropdown_menu(items, placeholder, item_count, width, height, selected_index, opened) _lf_dropdown_menu_loc(items, placeholder, item_count, width, height, selected_index, opened, __FILE__, __LINE__)
	// void _lf_dropdown_menu_loc(const char** items, const char* placeholder, uint32_t item_count, float width, float height, int32_t* selected_index, bool* opened, const char* file, int32_t line);
	dropdown_menu_loc :: proc(items: []cstring, placeholder: cstring, item_count: u32, width, height: u32, selected_index: ^i32, opened: ^bool, file: cstring, line: i32) ---

	// #define lf_dropdown_menu_wide(items, placeholder, item_count, width, height, selected_index, opened) _lf_dropdown_menu_loc_wide(items, placeholder, item_count, width, height, selected_index, opened, __FILE__, __LINE__)
	// void _lf_dropdown_menu_loc_wide(const wchar_t** items, const wchar_t* placeholder, uint32_t item_count, float width, float height, int32_t* selected_index, bool* opened, const char* file, int32_t line);

	// #define lf_input_text_inl_ex(buffer, buffer_size, input_width, placeholder_str)         \
	//     {                                                                                   \
	//     static LfInputField input = {                                                       \
	//         .cursor_index = 0,                                                              \
	//         .width = input_width,                                                           \
	//         .buf = buffer,                                                                  \
	//         .buf_size = buffer_size,                                                        \
	//         .placeholder = (char*)placeholder_str,                                          \
	//         .selected = false                                                               \
	//     };                                                                                  \
	//     _lf_input_text_loc(&input, __FILE__, __LINE__);                                     \
	//     }                                                                                   \

	// #define lf_input_text_inl(buffer, buffer_size) lf_input_text_inl_ex(buffer, buffer_size, (int32_t)(lf_get_current_div().aabb.size.x / 2), "")

	// #define lf_input_text(input) _lf_input_text_loc(input, __FILE__, __LINE__)
	// void _lf_input_text_loc(LfInputField* input, const char* file, int32_t line);
	input_text_loc :: proc(input: ^InputField, file: cstring, line: i32) ---

	// #define lf_input_int(input) _lf_input_int_loc(input, __FILE__, __LINE__)
	// void _lf_input_int_loc(LfInputField* input, const char* file, int32_t line);
	input_int_loc :: proc(input: ^InputField, file: cstring, line: i32) ---

	// #define lf_input_float(input) _lf_input_float_loc(input, __FILE__, __LINE__)
	// void _lf_input_float_loc(LfInputField* input, const char* file, int32_t line);
	input_float_loc :: proc(input: ^InputField, file: cstring, line: i32) ---
}

