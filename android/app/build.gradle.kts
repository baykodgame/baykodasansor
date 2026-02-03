plugins {
    id("com.android.application")
    id("kotlin-android")

    // 🔥 FIREBASE (ZORUNLU)
    id("com.google.gms.google-services")

    // Flutter Gradle Plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // 🔴 Firebase'deki package name ile AYNI OLMALI
    namespace = "com.baykod.asansor.takip"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
    isCoreLibraryDesugaringEnabled = true
}


    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // 🔴 Firebase'deki package name ile AYNI OLMALI
        applicationId = "com.baykod.asansor.takip"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}


    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
