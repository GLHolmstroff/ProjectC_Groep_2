package com.group2projc.Huishoud.auth


import org.apache.http.entity.StringEntity
import org.jetbrains.exposed.dao.*
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction

class DatabaseHelper(url:String){
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

    fun createUserTable() = transaction(db){
            //Write SQL statements to console
            addLogger(StdOutSqlLogger)

            //Create table
            SchemaUtils.create(Users)
        }


    fun registerFireBaseUser(t:String) = transaction(db){
        addLogger(StdOutSqlLogger)
        val fireBaseUser = User.new{
            token = t
            group = null
        }
    }


    fun addUserToGroup(userID:Int,groupID:Int) = transaction(db){
        addLogger(StdOutSqlLogger)
        val user = User.findById(userID)
        println(user.toString())
            user?.group = groupID

    }


}
