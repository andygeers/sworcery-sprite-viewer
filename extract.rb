#!/usr/bin/ruby

require 'fileutils'

puts "#sworcery"

file = ARGV[0]
extension = File.extname(file)
sprite = File.basename(file, extension)
path = file.sub(extension, ".sdat")

unless File.exists?(path)
	puts "File not found: #{path}"
	exit
end

str = File.binread(path)
bits = str.unpack("C*")

def pop_bytes(bits, count)
	n = 0
	v = 0
	count.times do
		byte = bits.shift
		if byte.nil?
			puts "Ran out!"
			exit
		end
		v += byte << n
		n += 8
	end
	return v
end

def read_string(bits, len)
	my_string = ""
	len.times do
		char = bits.shift		
		my_string << char.chr if char != 0
	end
	return my_string
end


# 10 bytes for file type
file_type = read_string(bits, 10)

puts "File type: #{file_type}"

# # 4 bytes for something (2 0 0 0)
# pop_bytes(bits, 4)

# 4 bytes for a number like 90 (number of animations?)
anim_count = pop_bytes(bits, 4)
puts "#{anim_count} animations?"

def process_animation(bits, sprite)
	# Then each animation:
	# 32 bytes for animation name
	anim_name = read_string(bits, 32)

	# 4 bytes for number of frames
	frame_count = pop_bytes(bits, 4)

	puts "Animation #{anim_name} : #{frame_count} frame(s)"

	anim_css = ""
	anim_js = <<EOF
	anim_frames['#{anim_name}'] = #{frame_count};
EOF

	(0 ... frame_count).each do |frame_num|
		anim_css << read_frame(bits, sprite, anim_name, frame_num)		
	end

	return anim_css, anim_js
end

def read_frame(bits, sprite, anim_name, frame_num)
	# Then for each frame:
	# 4 bytes for frame rate??? 60, 40, 20, etc
	frame_rate = pop_bytes(bits, 4)
	
	# 4 bytes for a big 11111 number
	x_offset = pop_bytes(bits, 4)
	y_offset = pop_bytes(bits, 4)	

	# Convert from unsigned to signed
	x_offset = [x_offset].pack('S*').unpack('s*')[0]
	y_offset = [y_offset].pack('S*').unpack('s*')[0]

	# 4 bytes for x
	x = pop_bytes(bits, 4)
	# 4 bytes for y
	y = pop_bytes(bits, 4)
	# 4 bytes for w
	w = pop_bytes(bits, 4)
	# 4 bytes for h
	h = pop_bytes(bits, 4)

	margin_x = x_offset * 4
	margin_y = y_offset * 4 + 128

	css = <<EOF
.#{sprite}.anim-#{anim_name}.frame-#{frame_num} {
	background-position: -#{x}px -#{y}px;
	width: #{w}px;
	height: #{h}px;

	margin-left: #{margin_x}px;
	margin-top: #{margin_y}px;
}
EOF
	
	return css
end

css = <<EOF
.#{sprite} {
	background-image: url(../../../data/#{sprite}.png);
	position:  absolute;
	left:  50%;
	top:  50%;
	transform:  scale(4.0);	
	image-rendering: auto;
    image-rendering: crisp-edges;
    image-rendering: pixelated;
}
EOF

js = <<EOF
var anim_frames = {};
var anim_offset_xs = {};
var anim_offset_ys = {};
EOF

anim_count.times do
	(anim_css, anim_js) = process_animation(bits, sprite)
	css << anim_css
	js << anim_js
end


FileUtils.mkdir_p("assets/css/gen")
FileUtils.mkdir_p("assets/javascript/gen")
File.write("assets/css/gen/#{sprite}.css", css, mode: "w")
File.write("assets/javascript/gen/#{sprite}.js", js, mode: "w")