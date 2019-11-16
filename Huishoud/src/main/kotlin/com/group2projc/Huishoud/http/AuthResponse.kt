package com.group2projc.Huishoud.http

class AuthResponse(id:Int,content:String) {
    private val id:Int
    private val content:String

    init {
        this.id = id
        this.content = content
    }

    fun getId():Int = this.id

    fun getContent():String = this.content

}