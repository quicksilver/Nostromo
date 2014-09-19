import plistlib
import os

wd = os.getenv('HOME') + '/Desktop'

os.system('plutil -convert xml1 -o ~/Desktop/qs_prefs.plist ~/Library/Preferences/com.blacktree.Quicksilver.plist')

ppath = wd + '/qs_prefs.plist'
tpath = wd + '/Theme.plist'
extras = ('QSBezelHasShadow', 'QSBezelIsGlass')

prefs = plistlib.readPlist(ppath)
theme = {k: v for (k, v) in prefs.items() if k.startswith('QSAppearance')}
for setting in extras:
    theme[setting] = prefs.get(setting, True)
plistlib.writePlist(theme, tpath)

os.system('rm ~/Desktop/qs_prefs.plist')
