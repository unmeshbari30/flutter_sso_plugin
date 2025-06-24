// package com.example.test_1.auth 
package com.rpsmobile.flutter_sso_plugin.auth

import android.app.Service
import android.content.Intent
import android.os.IBinder

class AuthenticatorService : Service() {
    override fun onBind(intent: Intent): IBinder {
        val authenticator = Authenticator(this)
        return authenticator.iBinder
    }
}
