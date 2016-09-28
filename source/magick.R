library(magick)
tiger <- image_read('http://jeroenooms.github.io/images/tiger.svg')
image_info(tiger)
image_write(tiger, path = "tiger.png", format = "png")
tiger_png <- image_convert(tiger, "png")
image_info(tiger_png)

# X11 only
# image_display(tiger)

# System dependent
image_browse(tiger)
image_flop(tiger)
image_flip(tiger)

# Example image
frink <- image_read("https://jeroenooms.github.io/images/frink.png")
print(frink)

# Add 20px left/right and 10px top/bottom
image_border(frink, "red", "20x10")

# Trim margins
image_trim(frink)

# Passport pica
image_crop(frink, "100x150+50")

# Resize
image_scale(frink, "300") # width: 300px
image_scale(frink, "x300") # height: 300px

# Rotate or mirror
image_rotate(frink, 45)
image_flip(frink)

# Set a background color
image_background(frink, "pink", flatten = TRUE)
image_fill(frink, "orange", point = "+100+200", fuzz = 30000)

# Add randomness
image_blur(frink, 10, 5)

image_noise(frink)

# This is so ugly it should be illegal
image_frame(frink, "25x25+10+10")

# Silly filters
image_charcoal(frink)
image_oilpaint(frink)
image_edge(frink)
image_negate(frink)

# Add some text
image_annotate(frink, "I like R!", size = 70, gravity = "southwest", color = "green")

# Customize text
image_annotate(frink, "CONFIDENTIAL", size = 30, color = "red", boxcolor = "pink",
               degrees = 60, location = "+50+100")


# Only works if ImageMagick has fontconfig
try(image_annotate(frink, "The quick brown fox", font = 'times-new-roman', size = 30), silent = T)
