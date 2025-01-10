import requests
import xml.etree.ElementTree as ET
import os

# URLs
route_list_url = "https://retro.umoiq.com/service/publicXMLFeed?command=routeList&a=ttc"
route_config_url = "https://retro.umoiq.com/service/publicXMLFeed?command=routeConfig&a=ttc"

# Crear la carpeta Toronto si no existe
folder_name = "Toronto"
if not os.path.exists(folder_name):
    os.makedirs(folder_name)

# Obtener la lista de rutas
response = requests.get(route_list_url)
root = ET.fromstring(response.content)

# Extraer los tags de las rutas
route_tags = [route.attrib["tag"] for route in root.findall("route")]

# Procesar cada ruta y guardar la respuesta en el archivo
for tag in route_tags:
    print(f"Procesando ruta: {tag}")
    response = requests.get(f"{route_config_url}&r={tag}")
    
    if response.status_code == 200:
        # Crear el XML para la ruta sin el contenedor principal
        route_data = ET.fromstring(response.content)

        # Guardar la respuesta de esta ruta en un archivo independiente dentro de la carpeta "Toronto"
        tree = ET.ElementTree(route_data)
        filename = os.path.join(folder_name, f"route_{tag}.xml")
        with open(filename, "wb") as f:
            tree.write(f, encoding="utf-8", xml_declaration=True)
        print(f"Archivo guardado como {filename}")
    else:
        print(f"Error con la ruta {tag}: {response.text}")
