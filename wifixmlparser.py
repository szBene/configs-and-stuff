import os
import xml.etree.ElementTree as ET

output_file = 'passwords.txt'
root_dir = os.path.dirname(os.path.abspath(__file__))

# loop through all xml files in root_dir
for filename in os.listdir(root_dir):
    if not filename.endswith('.xml'): # skip non-xml files
        continue
    
    file_path = os.path.join(root_dir, filename)
    tree = ET.parse(file_path)
    root = tree.getroot()
    
    ns = {'ns': 'http://www.microsoft.com/networking/WLAN/profile/v1'}
    name_elem = root.find('ns:name', ns)
    
    if name_elem is None: # if name element is not found
        print(f'Error: Name element not found in {filename}')
        continue
    
    name = name_elem.text
    password_elem = root.find('.//ns:keyMaterial', ns)
    
    if password_elem is None: # if password element is not found
        print(f'Error: Password element not found in {filename}')
        continue
    
    password = password_elem.text
    
    with open(output_file, 'a') as f:
        f.write(f'{name}:{password}\n')
