import org.jetbrains.kotlin.gradle.tasks.KotlinCompile
import org.springframework.boot.gradle.tasks.bundling.BootJar

plugins {
	id("org.springframework.boot") version "2.1.8.RELEASE"
	id("io.spring.dependency-management") version "1.0.8.RELEASE"
	kotlin("jvm") version "1.2.71"
	kotlin("plugin.spring") version "1.2.71"
}

group = "com.group2projc"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_1_8
java.targetCompatibility = JavaVersion.VERSION_1_8


//Force JUnit version
extra["junit-jupiter.version"]   = "5.5.2"

dependencies {
	implementation("com.google.firebase:firebase-admin:6.10.0")
	implementation("org.postgresql:postgresql:42.2.2")
	implementation("org.jetbrains.exposed:exposed:0.17.4")
	implementation("org.jetbrains.exposed:spring-transaction:0.17.4")
	implementation("org.springframework.boot:spring-boot-starter")
	implementation("org.springframework:spring-web:5.2.0.RELEASE")
	implementation("org.springframework.boot:spring-boot-starter-web")
	implementation("org.springframework.boot:spring-boot-starter-tomcat")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.5.2")
	{
		exclude(group = "org.junit.vintage", module = "junit-vintage-engine")
	}
}

allprojects {
	repositories {
		jcenter()
		mavenCentral()
	}
}

springBoot {
	mainClassName = "com.group2projc.Huishoud.HuishoudApplication"
}

//tasks.withType<Test> {
//	useJUnitPlatform()
//}

tasks.withType<BootJar> {
	enabled = true
}

tasks.withType<Jar> {
	enabled = true
}

tasks.withType<KotlinCompile>{

	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "1.8"
	}
}
