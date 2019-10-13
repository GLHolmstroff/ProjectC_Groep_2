package com.group2projc.Huishoud.auth

import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
class AuthResponseController {
    //TODO: Move corresponding functions to separate Restcontrollers
    //TODO: Update response structures
    private val counter = AtomicLong()
    private val template = "Hello, "

    @RequestMapping("/authRegister")
    fun authRegister(@RequestParam(value = "uid", defaultValue = "TokenNotSet") uid: String,
                     @RequestParam(value= "name", defaultValue = "EmptyName") name:String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .registerFireBaseUser(uid,name)
        return AuthResponse(counter.incrementAndGet().toInt(),
                template + uid)
    }

    @RequestMapping("/authCurrent")
    fun authCurrent(@RequestParam(value = "uid", defaultValue = "TokenNotSet") uid: String ): HashMap<String,Any?> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getUser(uid)
        return map
    }

    @RequestMapping("/createGroup")
    fun authcreateGroup(@RequestParam(value = "name", defaultValue = "World") name: String,
                      @RequestParam(value= "uid", defaultValue = "")uid: String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .createGroup(name,uid)
        return AuthResponse(counter.incrementAndGet().toInt(),
                template + name)
    }
    @RequestMapping("/addUserToGroup")
    fun authUserGroup(@RequestParam(value = "gid", defaultValue = "") gid: Int,
                      @RequestParam(value= "uid", defaultValue = "")uid: String): AuthResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .addUserToGroup(uid,gid)
        return AuthResponse(counter.incrementAndGet().toInt(),
                template + gid)
    }

    @RequestMapping("/getGroup")
    fun getGroup(@RequestParam(value = "gid", defaultValue = "") gid: Int): HashMap<String, String> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getAllInGroup(gid)
        return map
    }
    @RequestMapping("/getTally")
    fun getTally(@RequestParam(value= "gid",defaultValue = "") gid: Int): HashMap<String, Int> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getTallyforGroup(gid)
        return map

    }
}