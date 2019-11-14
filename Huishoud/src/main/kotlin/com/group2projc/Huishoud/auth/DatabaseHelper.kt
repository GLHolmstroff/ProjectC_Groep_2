package com.group2projc.Huishoud.auth

import com.group2projc.Huishoud.auth.DatabaseHelper.BeerTallies.count
import com.group2projc.Huishoud.auth.DatabaseHelper.BeerTallies.userid
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction
import java.time.LocalDate

class DatabaseHelper(url: String) {
    //Singleton pattern for Database connection, Multiple connect calls will cause memory leaks.
    val db by lazy {
        Database.connect(url,
                driver = "org.postgresql.Driver",
                user = "postgres",
                password = "admin")

    }
    //Table definitions

    object Groups : Table() {
        val id = integer("groupid").primaryKey().autoIncrement()
        val created_at = varchar("created_at", 20)
        val name = varchar("name", 50)
    }

    //SQL : CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, "token" VARCHAR(50) NOT NULL, "group" INT)
    object Users : Table() {
        val id = varchar("userid", 50).primaryKey()
        val groupid = reference("groupid", Groups.id).nullable()
        val global_permissions = varchar("global_permissions", 10)
        val displayname = varchar("displayname", 20)
    }

    object GroupPermissions : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val userid = reference("userid", Users.id).primaryKey()
        val permission = varchar("permission", 10)
    }

    object Schedules : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val useridto = reference("useridto", Users.id).primaryKey()
        val datedue = varchar("datetime", 20).primaryKey()
        val useridby = reference("useridby", Users.id)
        val description = varchar("description", 50)
    }

    object BeerTallies : Table() {
        val groupid = reference("groupid", Groups.id).primaryKey()
        val userid = reference("userid", Users.id).primaryKey()
        val count = integer("count")
    }
//TODO: Find out if it's Possible to use DAO, find way to pass EntityID to postgres

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


    fun initDataBase(): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            SchemaUtils.create(Groups, Users, GroupPermissions, Schedules, BeerTallies)
        }

        return this@DatabaseHelper
    }

//    fun createGroup(n: String, uid: String): DatabaseHelper {
//        transaction(db) {
//            addLogger(StdOutSqlLogger)
//            val group = Groups.insert {
//                it[created_at] = LocalDate.now().toString()
//                it[name] = n
//            }
//            addUserToGroup(uid, group[Groups.id], creator = true)
//        }
//        return this@DatabaseHelper
//    }

    fun registerFireBaseUser(t: String, n: String): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val query: Query = Users.select { Users.id eq t }
            if (query.count() == 0) {
                Users.insert {
                    it[id] = t
                    it[groupid] = null
                    it[global_permissions] = "user"
                    it[displayname] = n
                }
            }

        }
        return this@DatabaseHelper
    }

    fun getUser(uid: String): HashMap<String, Any?> {
        var out = HashMap<String, Any?>()
        transaction(db) {
            Users.select({ Users.id eq uid }).forEach {
                out["uid"] = it[Users.id]
                out["groupid"] = it[Users.groupid]
                out["global_permissions"] = it[Users.global_permissions]
                out["display_name"] = it[Users.displayname]
            }
        }
        return out
    }

    fun userUpdateDisplayName(uid: String, displayname1: String) : DatabaseHelper {
        transaction(db) {
            Users.update({Users.id eq uid}){
                it[displayname] = displayname1
            }
        }
        return this@DatabaseHelper
    }


    fun getGroupName(gid: Int): HashMap<String, Any?> {
        var out = HashMap<String, Any?>()
        transaction(db) {
            Groups.select({ Groups.id eq gid }).forEach {
                out["groupid"] = it[Groups.id]
                out["created_at"] = it[Groups.created_at]
                out["name"] = it[Groups.name]
            }
        }
        return out
    }

    fun addUserToGroup(uid: String, gid: Int, makeUserAdmin: Boolean = false): DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            var group = 0
            Groups.select { Groups.id eq gid }.forEach {
                group = it[Groups.id]
            }
            Users.update({ Users.id eq uid }) {
                it[groupid] = group
            }

            var p = "user"
            if (makeUserAdmin)
                p = "groupAdmin"

            setGroupPermission(gid, uid, p)
            createBeerEntry(gid, uid)
        }
        return this@DatabaseHelper
    }

    fun setGroupPermission(gid: Int, uid: String, p: String): DatabaseHelper {
        transaction(db) {
            var gpg = 0
            var gpu = ""
            //Find if There is an entry for a permission for this user in this group

            GroupPermissions.select { (GroupPermissions.groupid eq gid) and (GroupPermissions.userid eq uid) }.forEach {
                gpg = it[GroupPermissions.groupid]
                gpu = it[GroupPermissions.userid]
            }
            //If yes, update it
            if (gpg != 0 && gpu != "") {
                GroupPermissions.update({ (GroupPermissions.groupid eq gpg) and (GroupPermissions.userid eq gpu) }) {
                    it[permission] = p
                }
                //If no, create it
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

    fun getTallyforGroup(gid: Int): HashMap<String, Int> {
        var out = HashMap<String, Int>()
        transaction(db) {
            BeerTallies.select { (BeerTallies.groupid eq gid) }.forEach {
                out[it[userid]] = it[count]
            }
        }
        return out;
    }

    fun getTallyforGroupByName(gid: Int): HashMap<String, Int> {
        var temp = HashMap<String, Int>()
        var out = HashMap<String, Int>()
        transaction(db) {
            BeerTallies.select { (BeerTallies.groupid eq gid) }.forEach {
                temp[it[userid]] = it[count]
            }
            temp.forEach { k, v ->
                Users.select { (Users.id eq k) }.forEach {
                    out[it[Users.displayname]] = v
                }
            }

        }
        return out;
    }

    fun createBeerEntry(gid: Int, uid: String): DatabaseHelper {
        transaction(db) {

            BeerTallies.insert {
                it[groupid] = gid
                it[userid] = uid
                it[count] = 0
            }
        }
        return this@DatabaseHelper
    }

    fun updateBeerEntry(gid: Int, uid: String, count: Int): DatabaseHelper {
        var bg = 0
        var bu = ""
        transaction(db) {
            BeerTallies.select { (BeerTallies.groupid eq gid) and (BeerTallies.userid eq uid) }.forEach {
                bg = it[BeerTallies.groupid]
                bu = it[BeerTallies.userid]
            }
            if (bg != 0 && bu != "") {
                BeerTallies.update({ (BeerTallies.groupid eq gid) and (BeerTallies.userid eq uid) }) {
                    it[BeerTallies.count] = count
                }
            } else {
                createBeerEntry(gid, uid)
            }
        }
        return this@DatabaseHelper
    }

    fun getAllInGroup(gid: Int): HashMap<String, String> {
        var uid = ""
        var uname = ""
        var out = HashMap<String, String>()
        transaction(db) {
            var i = 0
            Users.select { (Users.groupid eq gid) }.forEach {
                out["UserId${i}"] = it[Users.id]
                i++
            }
        }
        return out
    }

}

fun DatabaseHelper.createGroup(n: String, uid: String): DatabaseHelper {
    transaction(db) {
        addLogger(StdOutSqlLogger)
        val group = DatabaseHelper.Groups.insert {
            it[created_at] = LocalDate.now().toString()
            it[name] = n
        }
        addUserToGroup(uid, group[DatabaseHelper.Groups.id], makeUserAdmin = true)
    }
    return this
}