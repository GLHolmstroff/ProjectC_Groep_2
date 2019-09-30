package com.group2projc.Huishoud

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class HuishoudApplication {

    companion object {
        @JvmStatic
        fun main(args: Array<String>) {
            runApplication<HuishoudApplication>(*args)
        }
        fun doSomeThing():String = "Hello, I am the output"
    }


}
