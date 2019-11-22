package com.group2projc.Huishoud.http

import com.group2projc.Huishoud.HuishoudApplication
import com.group2projc.Huishoud.database.DatabaseHelper
import com.group2projc.Huishoud.database.createGroup
import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
class HttpResponseController {
    //TODO: Move corresponding functions to separate Restcontrollers
    //TODO: Update response structures
    private val counter = AtomicLong()
    private val template = "Hello, "

    @RequestMapping("/authRegister")
    fun authRegister(@RequestParam(value = "uid", defaultValue = "TokenNotSet") uid: String,
                     @RequestParam(value= "name", defaultValue = "EmptyName") name:String): HashMap<String,Any?> {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .registerFireBaseUser(uid,name)
        return dbHelper.getUser(uid)
    }

    @RequestMapping("/authCurrent")
    fun authCurrent(@RequestParam(value = "uid", defaultValue = "TokenNotSet") uid: String ): HashMap<String,Any?> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getUser(uid)
        return map
    }

    @RequestMapping("/userUpdateDisplayName")
    fun userUpdateDisplayName(@RequestParam(value = "uid") uid: String,
                                @RequestParam(value = "displayname") displayname: String): HashMap<String, Any?> {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .userUpdateDisplayName(uid, displayname)
        return dbHelper.getUser(uid)
    }

    @RequestMapping("/createGroup")
    fun authcreateGroup(@RequestParam(value = "name", defaultValue = "World") name: String,
                      @RequestParam(value= "uid", defaultValue = "")uid: String): HttpResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .createGroup(name,uid)
        return HttpResponse(counter.incrementAndGet().toInt(),
                template + name)
    }
    @RequestMapping("/addUserToGroup")
    fun authUserGroup(@RequestParam(value = "gid", defaultValue = "") gid: Int,
                      @RequestParam(value= "uid", defaultValue = "")uid: String): HttpResponse {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .addUserToGroup(uid,gid)
        return HttpResponse(counter.incrementAndGet().toInt(),
                template + gid)
    }

    @RequestMapping("/getGroup")
    fun getGroup(@RequestParam(value = "gid", defaultValue = "") gid: Int): HashMap<String, String> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getAllInGroup(gid)
        return map
    }

    @RequestMapping("/getGroupName")
    fun getGroupname(@RequestParam(value = "gid", defaultValue = "TokenNotSet") gid: Int ): HashMap<String,Any?> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getGroupName(gid)
        return map
    }

    @RequestMapping("/getTally")
    fun getTally(@RequestParam(value= "gid",defaultValue = "") gid: Int): HashMap<String, Int> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getTallyforGroup(gid)
        return map

    }

    @RequestMapping("/getTallyByName")
    fun getTallyByName(@RequestParam(value= "gid",defaultValue = "") gid: Int): HashMap<String, HashMap<Int, String>> {
        val map = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .getTallyForGroupByNameAndPic(gid)
        return map

    }

    @RequestMapping("/updateTally")
    fun updateTally(@RequestParam(value="gid",defaultValue = "")gid:Int,
                    @RequestParam(value="authorid",defaultValue = "")authorid:String,
                    @RequestParam(value="targetid",defaultValue = "")targetid:String,
                    @RequestParam(value="mutation",defaultValue = "")mutation:Int):HttpResponse {
        DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .createBeerEntry(gid,authorid,targetid,mutation)
        return HttpResponse(counter.incrementAndGet().toInt(),
                template + gid)
    }

    @RequestMapping("/initDatabase")
    fun initDB():HashMap<String,String> {
        val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                .initDataBase()
        return hashMapOf(Pair<String,String>("success","True"))
    }

    @RequestMapping("/stopRunning")
    fun stopRunning() {
        HuishoudApplication.shutDown()
    }
}