package com.group2projc.Huishoud.auth

import com.google.firebase.FirebaseApp
import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseOptions
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseToken



class authController{

    //Extract user ID from firebase JWT login token
    fun verifyFireBaseToken(idToken:String) = FirebaseAuth.getInstance().verifyIdToken(idToken).uid

}