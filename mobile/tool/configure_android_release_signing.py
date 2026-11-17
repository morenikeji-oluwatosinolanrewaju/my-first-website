"""Configure an Android upload key in an ephemeral CI checkout."""

import base64
import os
from pathlib import Path


def required(name):
    value = os.environ.get(name, "")
    if not value:
        raise SystemExit(f"Missing required GitHub Actions secret: {name}")
    if "\n" in value or "\r" in value:
        raise SystemExit(f"The {name} value must be a single line.")
    return value


def escape_property(value, leading=False):
    escaped = []
    for index, char in enumerate(value):
        if char in "\\:=#!" or (char == " " and (leading or index == 0)):
            escaped.append("\\")
        escaped.append(char)
    return "".join(escaped)


def main():
    encoded = required("ANDROID_UPLOAD_KEYSTORE_BASE64")
    alias = required("ANDROID_KEY_ALIAS")
    store_password = required("ANDROID_STORE_PASSWORD")
    key_password = required("ANDROID_KEY_PASSWORD")

    app_dir = Path("android/app")
    app_dir.mkdir(parents=True, exist_ok=True)
    keystore = app_dir / "upload-keystore.jks"
    try:
        content = base64.b64decode(encoded, validate=True)
    except Exception as error:
        raise SystemExit("ANDROID_UPLOAD_KEYSTORE_BASE64 is not valid base64.") from error
    if len(content) < 1024:
        raise SystemExit("The supplied upload keystore is unexpectedly small.")
    keystore.write_bytes(content)
    keystore.chmod(0o600)

    properties = Path("android/key.properties")
    properties.write_text(
        "\n".join(
            (
                "storePassword=" + escape_property(store_password, leading=True),
                "keyPassword=" + escape_property(key_password, leading=True),
                "keyAlias=" + escape_property(alias, leading=True),
                "storeFile=" + escape_property(str(keystore.resolve())),
                "",
            )
        ),
        encoding="utf-8",
    )
    properties.chmod(0o600)

    gradle_file = Path("android/app/build.gradle.kts")
    script = gradle_file.read_text(encoding="utf-8")
    import_line = "import java.util.Properties\n"
    if import_line not in script:
        script = import_line + script
    anchor = "\nandroid {"
    if anchor not in script:
        raise SystemExit("Could not find the Android Gradle configuration block.")
    properties_block = """
val releaseKeyProperties = Properties()
val releaseKeyPropertiesFile = rootProject.file("key.properties")
releaseKeyPropertiesFile.inputStream().use { releaseKeyProperties.load(it) }
"""
    script = script.replace(anchor, "\n" + properties_block + "\nandroid {", 1)
    signing_block = """android {
    signingConfigs {
        create("release") {
            keyAlias = releaseKeyProperties.getProperty("keyAlias") ?: error("Missing keyAlias")
            keyPassword = releaseKeyProperties.getProperty("keyPassword") ?: error("Missing keyPassword")
            storeFile = file(releaseKeyProperties.getProperty("storeFile") ?: error("Missing storeFile"))
            storePassword = releaseKeyProperties.getProperty("storePassword") ?: error("Missing storePassword")
        }
    }
"""
    script = script.replace("android {", signing_block, 1)
    debug_signing = 'signingConfig = signingConfigs.getByName("debug")'
    if script.count(debug_signing) != 1:
        raise SystemExit("Could not find the generated release debug-signing line exactly once.")
    script = script.replace(debug_signing, 'signingConfig = signingConfigs.getByName("release")', 1)
    gradle_file.write_text(script, encoding="utf-8")
    print("Configured Android release signing from repository secrets.")


if __name__ == "__main__":
    main()
