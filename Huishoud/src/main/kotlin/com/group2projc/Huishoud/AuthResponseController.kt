package com.group2projc.Huishoud

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.group2projc.Huishoud.auth.DatabaseHelper

@RestController
class AuthResponseController {
    private val counter = AtomicLong()

    @RequestMapping("/authResponse")
    fun authResponse(@RequestParam(value = "name", defaultValue = "World") name: String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .createUserTable()
                .registerFireBaseUser(name)
                .addUserToGroup(1,2)
        return AuthResponse(counter.incrementAndGet().toInt(),
                String.format(template, name))
    }

    @RequestMapping("/authUserGroup")
    fun authUserGroup(@RequestParam(value = "name", defaultValue = "World") name: Int): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .addUserToGroup(name,2)
        return AuthResponse(counter.incrementAndGet().toInt(),
                template + name)
    }

    companion object {

        private val template = "Hello, %s!"
    }
}