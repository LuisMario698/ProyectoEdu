allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    
    // Configuración para evitar problemas con el NDK
    project.plugins.withId("com.android.application") {
        project.extensions.configure<com.android.build.gradle.BaseExtension> {
            // Usar una versión de NDK disponible o dejar que Gradle use la predeterminada
            // ndkVersion = "21.4.7075529" // Versión alternativa del NDK
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
