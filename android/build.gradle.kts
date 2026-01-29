allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Fix namespace issue for older plugins (isar_flutter_libs)
subprojects {
    afterEvaluate {
        if (project.plugins.hasPlugin("com.android.library")) {
            project.extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.let { android ->
                if (android.namespace == null) {
                    android.namespace = project.group.toString()
                }
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
