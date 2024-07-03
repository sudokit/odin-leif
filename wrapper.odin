package leif

begin :: proc() {
	begin_loc(#file, #line)
}

div_begin :: proc(pos, size: vec2, scrollable: bool) {
	@(static)
	scroll: f32 = 0
	@(static)
	scroll_velocity: f32 = 0
	div_begin_loc(pos, size, scrollable, &scroll, &scroll_velocity, #file, #line)
}

div_begin_ex :: proc(pos, size: vec2, scrollable: bool, scroll_ptr, scroll_velocity_ptr: ^f32) {
	div_begin_loc(pos, size, scrollable, scroll_ptr, scroll_velocity_ptr, #file, #line)
}

// #define lf_item(size) _lf_item_loc(size, __FILE__, __LINE__)
item :: proc(size: vec2) -> ClickableItemState {return item_loc(size, #file, #line)}

// #define lf_button(text) _lf_button_loc(text, __FILE__, __LINE__)
button :: proc(text: cstring) -> ClickableItemState {return button_loc(text, #file, #line)}

// #define lf_image_button(img) _lf_image_button_loc(img, __FILE__, __LINE__)
image_button :: proc(img: Texture) -> ClickableItemState {return image_button_loc(
		img,
		#file,
		#line,
	)}

// #define lf_image_button_fixed(img, width, height) _lf_image_button_fixed_loc(img, width, height, __FILE__, __LINE__)
image_button_fixed :: proc(
	img: Texture,
	width, height: f32,
) -> ClickableItemState {return image_button_fixed_loc(img, width, height, #file, #line)}

// #define lf_button_fixed(text, width, height) _lf_button_fixed_loc(text, width, height, __FILE__, __LINE__)
button_fixed :: proc(text: cstring, width, height: f32) -> ClickableItemState {
	return button_fixed_loc(text, width, height, #file, #line)
}

// #define lf_slider_int(slider) _lf_slider_int_loc(slider, __FILE__, __LINE__)
slider_int :: proc(slider: ^Slider) -> ClickableItemState {return slider_int_loc(
		slider,
		#file,
		#line,
	)}

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

slider_int_inl_ex :: proc(
	slider_val: rawptr,
	slider_min, slider_max: f32,
	slider_width, slider_height: f32,
	slider_handle_size: u32,
	state: ^ClickableItemState,
) {
	slider := Slider {
		val         = slider_val,
		handle_pos  = 0,
		min         = slider_min,
		max         = slider_max,
		width       = slider_width,
		height      = slider_height,
		handle_size = slider_handle_size,
	}
	state^ = slider_int(&slider)
}

// #define lf_slider_int_inl(slider_val, slider_min, slider_max, state) lf_slider_int_inl_ex(slider_val, slider_min, slider_max, lf_get_current_div().aabb.size.x / 2.0f, 5, 0, state)
slider_int_inl :: proc(
	slider_val: rawptr,
	slider_min, slider_max: f32,
	state: ^ClickableItemState,
) {
	slider_int_inl_ex(
		slider_val,
		slider_min,
		slider_max,
		get_current_div().aabb.size.x / 2,
		5,
		0,
		state,
	)
}

// #define lf_progress_bar_val(width, height, min, max, val) _lf_progress_bar_val_loc(width, height, min, max, val, __FILE__, __LINE__)
progress_bar_val :: proc(width, height: f32, min, max, val: i32) -> ClickableItemState {
	return progress_bar_val_loc(width, height, min, max, val, #file, #line)
}

// #define lf_progress_bar_int(val, min, max, width, height) _lf_progress_bar_int_loc(val, min, max, width, height, __FILE__, __LINE__)
progress_bar_int :: proc(val, min, max: f32, width, height: f32) -> ClickableItemState {
	return progress_bar_int_loc(val, min, max, width, height, #file, #line)
}

// #define lf_progress_stripe_int(slider) _lf_progresss_stripe_int_loc(slider , __FILE__, __LINE__)
progress_stripe_int :: proc(slider: ^Slider) -> ClickableItemState {
	return progress_stripe_int_loc(slider, #file, #line)
}

// #define lf_checkbox(text, val, tick_color, tex_color) _lf_checkbox_loc(text, val, tick_color, tex_color, __FILE__, __LINE__)
checkbox :: proc(text: cstring, val: ^bool, tick_color, tex_color: Color) -> ClickableItemState {
	return checkbox_loc(text, val, tick_color, tex_color, #file, #line)
}

// #define lf_menu_item_list(items, item_count, selected_index, per_cb, vertical) _lf_menu_item_list_loc(__FILE__, __LINE__, items, item_count, selected_index, per_cb, vertical)
menu_item_list :: proc(
	items: []cstring,
	item_count, selected_index: i32,
	cb: MenuItemCallback,
	vertical: bool,
) -> i32 {
	return menu_item_list_loc(items, item_count, selected_index, cb, vertical, #file, #line)
}

// #define lf_dropdown_menu(items, placeholder, item_count, width, height, selected_index, opened) _lf_dropdown_menu_loc(items, placeholder, item_count, width, height, selected_index, opened, __FILE__, __LINE__)
dropdown_menu :: proc(
	items: []cstring,
	placeholder: cstring,
	item_count, width, height: u32,
	selected_index: ^i32,
	opened: ^bool,
) {
	dropdown_menu_loc(
		items,
		placeholder,
		item_count,
		width,
		height,
		selected_index,
		opened,
		#file,
		#line,
	)
}

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
input_text_inl_ex :: proc(
	buffer: cstring,
	buffer_size: u32,
	input_width: i32,
	placeholder_str: cstring,
) {
	input := InputField {
		cursor_index = 0,
		width        = input_width,
		buf          = buffer,
		buf_size     = buffer_size,
		placeholder  = placeholder_str,
		selected     = false,
	}
	input_text_loc(&input, #file, #line)
}

// #define lf_input_text_inl(buffer, buffer_size) lf_input_text_inl_ex(buffer, buffer_size, (int32_t)(lf_get_current_div().aabb.size.x / 2), "")
input_text_inl :: proc(buffer: cstring, buffer_size: u32) {
	input_text_inl_ex(buffer, buffer_size, i32(get_current_div().aabb.size.x / 2), "")
}

// #define lf_input_text(input) _lf_input_text_loc(input, __FILE__, __LINE__)
input_text :: proc(input: ^InputField) {
	input_text_loc(input, #file, #line)
}

// #define lf_input_int(input) _lf_input_int_loc(input, __FILE__, __LINE__)
input_int :: proc(input: ^InputField) {
	input_int_loc(input, #file, #line)
}

// #define lf_input_float(input) _lf_input_float_loc(input, __FILE__, __LINE__)
input_float :: proc(input: ^InputField) {
	input_float_loc(input, #file, #line)
}

