import requests
import xml.etree.ElementTree as ET

# URLs
route_list_url = "https://retro.umoiq.com/service/publicXMLFeed?command=routeList&a=ttc"
route_config_url = "https://retro.umoiq.com/service/publicXMLFeed?command=routeConfig&a=ttc"

# Obtener la lista de rutas
response = requests.get(route_list_url)
root = ET.fromstring(response.content)

# Extraer los tags de las rutas
route_tags = [route.attrib["tag"] for route in root.findall("route")]

# Filtrar las rutas para solo incluir las 7 y 8
filtered_route_tags = [tag for tag in route_tags if tag in ['7']]

# Crear un elemento raíz para consolidar la respuesta
root_combined = ET.Element("routes")

# Procesar cada ruta y guardar la respuesta en el archivo
for tag in filtered_route_tags:
    print(f"Procesando ruta: {tag}")
    response = requests.get(f"{route_config_url}&r={tag}")
    
    if response.status_code == 200:
        # Agregar la respuesta al XML combinado
        route_data = ET.fromstring(response.content)
        root_combined.append(route_data)
    else:
        print(f"Error con la ruta {tag}: {response.text}")

# Guardar la respuesta consolidada en un archivo XML
tree = ET.ElementTree(root_combined)
with open("routes7.xml", "wb") as f:
    tree.write(f, encoding="utf-8", xml_declaration=True)

print("Archivo guardado como routes.xml")
