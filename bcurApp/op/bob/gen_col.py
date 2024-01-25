
id_start = 57
id_end = 64 # including
x = 780+130
y = 270

out = []

for i in range(id_start, id_end+1):
  widget=f'''
  <widget type="embedded" version="2.0.0">
    <name>Embedded Display_{i}</name>
    <macros>
      <BlockID>{i}</BlockID>
    </macros>
    <file>gixs_sample_template.bob</file>
    <x>{x}</x>
    <y>{y}</y>
    <width>115</width>
    <height>35</height>
  </widget>
  '''
  out.append(widget)
  y += 50

for i in out:
  print(i)
