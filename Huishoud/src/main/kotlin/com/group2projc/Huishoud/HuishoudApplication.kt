package com.group2projc.Huishoud

import com.group2projc.Huishoud.auth.DatabaseHelper
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import com.google.firebase.FirebaseApp
import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseOptions
import java.io.FileInputStream
import org.springframework.web.server.adapter.WebHttpHandlerBuilder.applicationContext
import org.springframework.boot.SpringApplication
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.ExitCodeGenerator
import org.springframework.boot.actuate.autoconfigure.security.servlet.EndpointRequest
import org.springframework.context.ApplicationContext
import org.springframework.context.ConfigurableApplicationContext
import org.springframework.context.annotation.Configuration
import kotlin.system.exitProcess




@SpringBootApplication
class HuishoudApplication: ExitCodeGenerator {

    override fun getExitCode(): Int {
        return 0
    }

    companion object {
        lateinit var ctx : ConfigurableApplicationContext
        @JvmStatic
        fun main(args: Array<String>) {
            ctx = runApplication<HuishoudApplication>(*args)
//            val serviceAccount = FileInputStream("pathgoeshere"
//
//            val options = FirebaseOptions.Builder()
//                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
//                    .setDatabaseUrl("https://huishoud-3417b.firebaseio.com")
//                    .build()
//
//            FirebaseApp.initializeApp(options)


            val dbHelper:DatabaseHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres").initDataBase()
        }

        fun shutDown() {
            val exitCode = SpringApplication.exit(ctx, ExitCodeGenerator {
                // no errors
                0
            })
            exitProcess(exitCode);
        }
        fun doSomeThing():String = "Hello, I am the output"
    }
}
