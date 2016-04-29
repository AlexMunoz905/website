#!/usr/local/bin/python3.4
'''
http://blog.csdn.net/pwiling/article/details/50596982
Generate an image validator for webpage with python
'''
import random
import string
import sys
import math
from datetime import datetime
#from browser import document, alert

print(sys.version_info)
fontPath = 'Arial.ttf'
number = 4
size = (100, 30)
bgcolor = (255, 255, 255)
fontcolor = (0, 0, 255)
linecolor = (255, 0, 0)
drawLine = True
lineNumber = (1, 5)

# Generate a random string
def generateText():
    source = list(string.ascii_letters)
    for index in range(10):
        source.append(str(index))
    return ''.join(random.sample(source, number))

width, height = size
text = generateText()
with open('./text.txt', 'w') as f:
    f.write(text)
print('At least I am here')

from PIL import Image, ImageDraw, ImageFont, ImageFilter

def generateNoise(draw, width, height):
    begin = (random.randint(0, width), random.randint(0, height))
    end = (random.randint(0, width), random.randint(0, height))
    draw.line([begin, end], fill = linecolor)

image = Image.new('RGBA', (width, height), bgcolor)
font = ImageFont.truetype(fontPath, 25)
draw = ImageDraw.Draw(image)
fontWidth, fontHeight = font.getsize(text)
draw.text(((width - fontWidth) / number, (height - fontHeight) / number), text, font = font, fill = fontcolor)
generateNoise(draw, width, height)
image = image.transform((width + 20, height + 10), Image.AFFINE, (1, -0.3, 0, -0.1, 1, 0), Image.BILINEAR)
image = image.filter(ImageFilter.EDGE_ENHANCE_MORE)
image.save('idencode.png')
