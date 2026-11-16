from pathlib import Path
import xml.etree.ElementTree as ET

manifest = Path("android/app/src/main/AndroidManifest.xml")
tree = ET.parse(manifest)
root = tree.getroot()
android_ns = "http://schemas.android.com/apk/res/android"
ET.register_namespace("android", android_ns)
permission = "android.permission.INTERNET"
present = any(
    element.tag == "uses-permission"
    and element.get(f"{{{android_ns}}}name") == permission
    for element in root
)
if not present:
    node = ET.Element("uses-permission")
    node.set(f"{{{android_ns}}}name", permission)
    root.insert(0, node)
    tree.write(manifest, encoding="utf-8", xml_declaration=True)
print("Android INTERNET permission verified.")
