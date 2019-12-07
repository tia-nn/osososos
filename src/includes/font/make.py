code = open('hankaku.txt').read()

fonts = code.split('\n\n')

print('FONT_8_16:')

for i in fonts:
    a = i.split('\n')
    print('.' + a[0].replace(' ', '_') + ':')
    for j in a[1:]:
        print('db 0b' + j.replace('.', '0').replace('*', '1'))
