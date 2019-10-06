package com.group2projc.Huishoud

import com.group2projc.Huishoud.auth.DatabaseHelper
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import com.google.firebase.FirebaseApp
import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseOptions
import java.io.FileInputStream





@SpringBootApplication
class HuishoudApplication {

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<HuishoudApplication>(*args)
//            val serviceAccount = FileInputStream("pathgoeshere")
//
//            val options = FirebaseOptions.Builder()
//                    .setCredentials(GoogleCredentials.fromStream(serviceAccount))
//                    .setDatabaseUrl("https://huishoud-3417b.firebaseio.com")
//                    .build()
//
//            FirebaseApp.initializeApp(options)
            val dbHelper:DatabaseHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
            dbHelper.createUserTable()
            dbHelper.registerFireBaseUser("Tokengoeshere")
            dbHelper.addUserToGroup(1,2)
        }
        fun doSomeThing():String = "Hello, I am the output"
    }


}
