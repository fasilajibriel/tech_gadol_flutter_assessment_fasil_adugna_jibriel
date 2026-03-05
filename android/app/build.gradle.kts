plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.techgadol.assessment.flutter.fasilajibriel"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion
    flavorDimensions += "environment"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.techgadol.assessment.flutter.fasilajibriel"
        resValue("string", "app_name", "Tech Gadol Assessment")
        manifestPlaceholders["mainActivityClass"] =
            "com.techgadol.assessment.flutter.fasilajibriel.MainActivity"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    productFlavors {
        create("mock") {
            dimension = "environment"
            applicationId = "com.techgadol.assessment.flutter.fasilajibriel.mock"
            resValue("string", "app_name", "Tech Gadol Assessment (Mock)")
            manifestPlaceholders["mainActivityClass"] =
                "com.techgadol.assessment.flutter.fasilajibriel.mock.MainActivity"
        }
        create("dev") {
            dimension = "environment"
            applicationId = "com.techgadol.assessment.flutter.fasilajibriel.dev"
            resValue("string", "app_name", "Tech Gadol Assessment (Dev)")
            manifestPlaceholders["mainActivityClass"] =
                "com.techgadol.assessment.flutter.fasilajibriel.dev.MainActivity"
        }
        create("uat") {
            dimension = "environment"
            applicationId = "com.techgadol.assessment.flutter.fasilajibriel.uat"
            resValue("string", "app_name", "Tech Gadol Assessment (UAT)")
            manifestPlaceholders["mainActivityClass"] =
                "com.techgadol.assessment.flutter.fasilajibriel.uat.MainActivity"
        }
        create("prod") {
            dimension = "environment"
            applicationId = "com.techgadol.assessment.flutter.fasilajibriel"
            resValue("string", "app_name", "Tech Gadol Assessment")
            manifestPlaceholders["mainActivityClass"] =
                "com.techgadol.assessment.flutter.fasilajibriel.MainActivity"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
