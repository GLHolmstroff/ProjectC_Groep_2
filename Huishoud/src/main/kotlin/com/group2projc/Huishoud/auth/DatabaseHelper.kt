package com.group2projc.Huishoud.auth

import org.jetbrains.exposed.dao.*
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction

class DatabaseHelper(url:String){
    //Singleton pattern for Database connection, Multiple connect calls will cause memory leaks.
    val db by lazy {
        Database.connect(url,
                driver = "org.postgresql.Driver",
                user = "postgres",
                password = "admin")

    }
    //SQL : CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, "token" VARCHAR(50) NOT NULL)
    object Users : IntIdTable(){
        val token = varchar("token",50)
        val group = integer("group").nullable()
    }

    class User(id: EntityID<Int>) : IntEntity(id){
        companion object : IntEntityClass<User>(Users)
        var token by Users.token
        var group by Users.group
    }

    fun createUserTable():DatabaseHelper {
        transaction(db) {
            //Write SQL statements to console
            addLogger(StdOutSqlLogger)

            //Create table
            SchemaUtils.create(Users)
        }
        return this@DatabaseHelper
    }


    fun registerFireBaseUser(t:String):DatabaseHelper {
        transaction(db) {
            addLogger(StdOutSqlLogger)
            val fireBaseUser = User.new {
                token = t
                group = null
            }
        }
        return this@DatabaseHelper
    }

    fun addUserToGroup(userID:Int,groupID:Int):DatabaseHelper {
        transaction(db){
            addLogger(StdOutSqlLogger)
            val user = User.findById(userID)
            println(user.toString())
            user?.group = groupID

        }
        return this@DatabaseHelper
    }


}
