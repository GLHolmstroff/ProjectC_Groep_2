package com.group2projc.Huishoud.auth

import org.jetbrains.exposed.dao.IntIdTable
import org.jetbrains.exposed.sql.*
import org.jetbrains.exposed.sql.transactions.transaction

class DatabaseHelper(url:String){
    val db by lazy {
        Database.connect(url,
                driver = "org.postgresql.Driver",
                user = "postgres",
                password = "admin")

    }
    //SQL : CREATE TABLE IF NOT EXISTS cities (id SERIAL PRIMARY KEY, "name" VARCHAR(50) NOT NULL)
    object Cities : IntIdTable() {
        val name:Column<String> = varchar("name",50)
    }
    fun test1(){
        transaction(db){
            //Write SQL statements to console
            addLogger(StdOutSqlLogger)

            //Create table
            SchemaUtils.create(Cities)

            //Insert into cities
//            val stPeteId = Cities.insertAndGetId {
//                it[name] = "St. Petersburg"
//            }

            //Select * from cities
            println("Cities: ${Cities.selectAll()}")
        }
    }
}
