import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Muat konfigurasi penandatanganan rilis dari android/key.properties (bila ada).
// File ini berisi password & lokasi keystore, JANGAN di-commit ke git.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// Aktifkan signing rilis HANYA bila key.properties ada DAN file keystore yang
// ditunjuk benar-benar ada. Dengan begitu, template berisi placeholder tidak
// membuat build rilis gagal sampai keystore sungguhan disiapkan.
val releaseStoreFilePath = keystoreProperties["storeFile"] as String?
val hasReleaseSigning = keystorePropertiesFile.exists() &&
        releaseStoreFilePath != null &&
        file(releaseStoreFilePath).exists()

android {
    namespace = "com.nunopedia.tumbang"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.nunopedia.tumbang"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (hasReleaseSigning) {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = file(releaseStoreFilePath!!)
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            // Pakai signing rilis bila keystore sungguhan tersedia; bila tidak,
            // jatuh ke debug agar build tetap jalan saat development.
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}
