"""Regenerate every native launcher icon from the original Haven mark. Requires Pillow."""
from pathlib import Path
import json
from PIL import Image, ImageDraw
ROOT = Path(__file__).resolve().parents[1]
BACKGROUND = '#224c3b'
FOREGROUND = '#e7efbe'
def icon(size):
    scale = size * 4 / 64
    image = Image.new('RGB', (size * 4, size * 4), BACKGROUND)
    draw = ImageDraw.Draw(image)
    width = round(3.5 * scale)
    for coords in [[(17,30),(32,17),(47,30),(47,46),(44,49),(20,49),(17,46),(17,30)], [(25,34),(30,39),(40,28)]]:
        points = [(round(x*scale),round(y*scale)) for x,y in coords]
        draw.line(points, fill=FOREGROUND, width=width, joint='curve')
        for x,y in points:
            r=width/2
            draw.ellipse((x-r,y-r,x+r,y+r),fill=FOREGROUND)
    return image.resize((size,size),Image.Resampling.LANCZOS)
for density,size in [('mdpi',48),('hdpi',72),('xhdpi',96),('xxhdpi',144),('xxxhdpi',192)]:
    icon(size).save(ROOT/f'android/app/src/main/res/mipmap-{density}/ic_launcher.png')
folder=ROOT/'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for item in json.loads((folder/'Contents.json').read_text())['images']:
    if 'filename' in item:
        size=round(float(item['size'].split('x')[0])*float(item['scale'][:-1]))
        icon(size).save(folder/item['filename'])
for size in (192,512):
    for prefix in ('Icon','Icon-maskable'):
        icon(size).save(ROOT/f'web/icons/{prefix}-{size}.png')
icon(32).save(ROOT/'web/favicon.png')
icon(512).save(ROOT/'assets/brand/icon-512.png')
icon(1024).save(ROOT/'assets/brand/icon-1024.png')
print('Generated Android, iOS, web and brand icons.')
