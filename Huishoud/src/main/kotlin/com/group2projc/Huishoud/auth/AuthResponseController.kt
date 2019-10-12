package com.group2projc.Huishoud.auth

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
class AuthResponseController {
    private val counter = AtomicLong()

    @RequestMapping("/authRegister")
    fun authResponse(@RequestParam(value = "uid", defaultValue = "TokenNotSet") uid: String,
                     @RequestParam(value= "name", defaultValue = "EmptyName") name:String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .registerFireBaseUser(uid,name)
        return AuthResponse(counter.incrementAndGet().toInt(),
                String.format(template, uid))
    }

    @RequestMapping("/createGroup")
    fun authUserGroup(@RequestParam(value = "name", defaultValue = "World") name: String,
                      @RequestParam(value= "uid", defaultValue = "")uid: String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .createGroup(name,uid)
        return AuthResponse(counter.incrementAndGet().toInt(),
                template + name)
    }

    

    companion object {

        private val template = "Hello, %s!"
    }
}