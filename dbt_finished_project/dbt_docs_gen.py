import json
import re
import os

PATH_DBT_PROJECT = os.getcwd()

search_str = 'o=[i("manifest","manifest.json"+t),i("catalog","catalog.json"+t)]'

with open(os.path.join(PATH_DBT_PROJECT, 'target', 'index.html'), 'r') as f:
    content_index = f.read()

with open(os.path.join(PATH_DBT_PROJECT, 'target', 'manifest.json'), 'r') as f:
    json_manifest = json.loads(f.read())

with open(os.path.join(PATH_DBT_PROJECT, 'target', 'catalog.json'), 'r') as f:
    json_catalog = json.loads(f.read())

with open(os.path.join(PATH_DBT_PROJECT, 'target', 'index.html'), 'w') as f:
    new_str = "o=[{label: 'manifest', data: " + json.dumps(json_manifest) + "},{label: 'catalog', data: " + json.dumps(json_catalog) + "}]"
    new_content = content_index.replace(search_str, new_str)
    f.write(new_content)