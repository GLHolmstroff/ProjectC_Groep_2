import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
	id("org.springframework.boot") version "2.1.8.RELEASE"
	id("io.spring.dependency-management") version "1.0.8.RELEASE"
	kotlin("jvm") version "1.2.71"
	kotlin("plugin.spring") version "1.2.71"
}

group = "com.group2projc"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_1_8


//Force JUnit version
ext["junit-jupiter.version"]   = "5.5.2"

dependencies {
	compile("org.jetbrains.exposed:exposed:0.17.4")
	implementation("org.springframework.boot:spring-boot-starter")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	{
		exclude(group = "org.junit.vintage", module = "junit-vintage-engine")
	}
	testRuntimeOnly("org.junit.jupiter:junit-jupiter-engine:5.5.2")
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
//	include("com/group2projc/Huishoud/**")
//}

tasks.withType<KotlinCompile>{

	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "1.8"
	}
}
