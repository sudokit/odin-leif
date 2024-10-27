package leif

div_begin :: proc(pos, size: vec2s, scrollable: bool) -> ^Div {
	@(static)
	scroll: f32 = 0
	@(static)
	scroll_velocity: f32 = 0
	return div_begin_loc(pos, size, scrollable, &scroll, &scroll_velocity)
}

slider_int_inl_ex :: proc(
	slider_val: rawptr,
	slider_min, slider_max, slider_width, slider_height: f32,
	slider_handle_size: u32,
	state: ^ClickableItemState,
) {
	@(static)
	slider: Slider
	slider.val = slider_val
	slider.handle_pos = 0
	slider.min = slider_min
	slider.max = slider_max
	slider.width = slider_width
	slider.height = slider_height
	slider.handle_size = slider_handle_size
	state^ = slider_int_loc(&slider)
}

input_text_inl_ex :: proc(
	input_width: i32,
	buffer: cstring,
	buffer_size: u32,
	placeholder_str: cstring,
) {
	@(static)
	input: InputField
	input.cursor_index = 0
	input.width = input_width
	input.buf = buffer
	input.buf_size = buffer_size
	input.placeholder = placeholder_str
	input.selected = false
	input_text_loc(&input)
}

