package com.group2projc.Huishoud

import com.group2projc.Huishoud.auth.DatabaseHelper
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HuishoudApplication {

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<HuishoudApplication>(*args)
            val dbHelper:DatabaseHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
            dbHelper.test1()
        }
        fun doSomeThing():String = "Hello, I am the output"
    }


}
