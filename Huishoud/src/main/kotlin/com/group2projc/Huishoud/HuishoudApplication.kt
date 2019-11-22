package com.group2projc.Huishoud

import com.group2projc.Huishoud.database.DatabaseHelper
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import com.group2projc.Huishoud.filetransfer.storage.FileSystemStorageService

import org.springframework.boot.SpringApplication
import org.springframework.boot.ExitCodeGenerator
import org.springframework.context.ConfigurableApplicationContext
import kotlin.system.exitProcess
import com.group2projc.Huishoud.filetransfer.storage.StorageService
import com.group2projc.Huishoud.filetransfer.storage.StorageProperties
import org.springframework.context.annotation.Bean


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


            val dbHelper: DatabaseHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres").initDataBase()

            val count = dbHelper.getTallyforGroup(1)
            print(count)
            val fsss:FileSystemStorageService = FileSystemStorageService(StorageProperties())
            fsss.deleteAll()
            fsss.init()
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

    @Bean
    fun init(storageService: StorageService): (Array<String>) -> Unit {
        return { args ->
            storageService.deleteAll()
            storageService.init()
        }
    }
}
