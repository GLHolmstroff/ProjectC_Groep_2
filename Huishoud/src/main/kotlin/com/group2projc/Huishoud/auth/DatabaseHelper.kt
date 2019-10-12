package com.group2projc.Huishoud.auth

import org.apache.http.entity.StringEntity
import org.jetbrains.exposed.dao.*
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.time.LocalDate
import org.postgresql.jdbc.*

class DatabaseHelper(url:String){
    //Singleton pattern for Database connection, Multiple connect calls will cause memory leaks.
    val db by lazy {
        Database.connect(url,
                driver = "org.postgresql.Driver",
                user = "postgres",
                password = "admin")

    }
    //Table definitions

    object Groups : Table(){
        val id = integer("groupid").primaryKey().autoIncrement()
        val created_at = varchar("created_at", 20)
        val name = varchar("name", 50)
    }
    //SQL : CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, "token" VARCHAR(50) NOT NULL, "group" INT)
    object Users : Table(){
        val id = varchar("userid",50).primaryKey()
        val groupid = reference("groupid",Groups.id).nullable()
        val global_permissions = varchar("global_permissions",10)
        val displayname = varchar("displayname", 20)
    }

    object GroupPermissions : Table(){
        val groupid = reference("groupid", Groups.id).primaryKey()
        val userid = reference("userid",Users.id).primaryKey()
        val permission = varchar("permission",10)
    }

    object Schedules : Table(){
        val groupid = reference("groupid", Groups.id).primaryKey()
        val useridto = reference("useridto",Users.id).primaryKey()
        val datedue = varchar("datetime",20).primaryKey()
        val useridby = reference("useridby",Users.id)
        val description = varchar("description", 50)
    }

    object BeerTallies : Table(){
        val groupid = reference("groupid", Groups.id).primaryKey()
        val userid = reference("userid",Users.id).primaryKey()
        val count = integer("count")
    }

//    //Entity (Row) objects for main tables.
//    // Support for Entities on tables with multiple primary keys is not supported yet :/
//    class Group(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<Group>(Groups)
//        var createdAt by Groups.created_at
//        var name by Groups.name
//        var permissions by User via GroupPermissions
//
//    }
//
//    class User(id:EntityID<String>) : Entity<String>(id){
//        companion object : EntityClass<String, User>(Users)
//        var groupid by Group optionalReferencedOn Users.groupid
//        var globalPermissions by Users.global_permissions
//        var displayName by Users.displayname
//    }
//
//    class GroupPermission(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<GroupPermission>(GroupPermissions)
//        var groupid by Group referencedOn GroupPermissions.groupid
//        var userid by User referencedOn GroupPermissions.userid
//        var permission by GroupPermissions.permission
//    }
//
//    class Schedule(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<Schedule>(Schedules)
//        var groupid by Group referencedOn Schedules.groupid
//        var useridto by User referencedOn Schedules.useridto
//        var useridby by User referencedOn Schedules.useridby
//        var datedue by Schedules.datedue
//        var description by Schedules.description
//    }
//
//    class BeerTally(id:EntityID<Int>) : IntEntity(id){
//        companion object : IntEntityClass<BeerTally>(BeerTallies)
//        var groupid by Group referencedOn BeerTallies.groupid
//        var userid by User referencedOn BeerTallies.userid
//        var count by BeerTallies.count
//    }


    fun initDataBase():DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            SchemaUtils.create(Groups,Users,GroupPermissions,Schedules,BeerTallies)
        }

        return this@DatabaseHelper
    }

    fun createGroup(n:String):DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val group = Groups.insert {
                it[created_at] = LocalDate.now().toString()
                it[name] = n
            }
        }
        return this@DatabaseHelper
    }

    fun registerFireBaseUser(t:String,n:String):DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)

            Users.insert {
                it[id] = t
                it[groupid] = null
                it[global_permissions] = "user"
                it[displayname] = n

            }

        }
        return this@DatabaseHelper
    }

    fun addUserToGroup(uid:String,gid:Int,creator:Boolean=false):DatabaseHelper {
        transaction(db){
            addLogger(StdOutSqlLogger)
            var group = 0
            Groups.select {Groups.id eq gid}.forEach{
                group = it[Groups.id]
            }
            Users.update ({ Users.id eq uid }) {
                it[Users.groupid] = group
            }

            var p = "user"
            if (creator)
                p = "groupAdmin"

            setGroupPermission(gid,uid,p)
        }
        return this@DatabaseHelper
    }

    fun setGroupPermission(gid: Int, uid:String, p:String):DatabaseHelper {
        val group = 0
        val user = ""
        transaction(db){
            var gpg = 0
            var gpu = ""
            //Find if There is an entry for a permission for this user in this group

            GroupPermissions.select { (GroupPermissions.groupid eq gid) and (GroupPermissions.userid eq uid)}.forEach {
                gpg = it[GroupPermissions.groupid]
                gpu = it[GroupPermissions.userid]
            }
            //If yes, update it
            if (gpg != 0 && gpu != "") {
                GroupPermissions.update ({ (GroupPermissions.groupid eq gpg) and (GroupPermissions.userid eq gpu) }) {
                    it[permission] = p
                }
            //If no, create it
            } else if (group == null || user == null) {
                println("bruh")
                //TODO: Add error Handling
            } else {
                GroupPermissions.insert {
                    it[groupid] = gid
                    it[userid] = uid
                    it[permission] = p
                }
            }
        }
        return this@DatabaseHelper
    }

}

