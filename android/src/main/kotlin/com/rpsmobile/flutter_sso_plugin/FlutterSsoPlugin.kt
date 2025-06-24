// package com.example.flutter_sso_plugin
package com.rpsmobile.flutter_sso_plugin


import android.accounts.Account
import android.accounts.AccountManager
import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class FlutterSsoPlugin: FlutterPlugin, MethodChannel.MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private val ACCOUNT_TYPE = "com.rpsmobile.sso.account"

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    channel = MethodChannel(binding.binaryMessenger, "com.rpsmobile.sso/account")
    channel.setMethodCallHandler(this)

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    val accountManager = AccountManager.get(context)

    when (call.method) {
      "getPlatformVersion" -> {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }
      
      "checkAccount" -> {
        val accounts = accountManager.getAccountsByType(ACCOUNT_TYPE)
        if (accounts.isNotEmpty()) {
          val account = accounts[0]
          val accessToken = accountManager.getPassword(account)
          val refreshToken = accountManager.getUserData(account, "refreshToken")
          val profileJson = accountManager.getUserData(account, "profile")

          result.success(mapOf(
            "username" to account.name,
            "accessToken" to accessToken,
            "refreshToken" to refreshToken,
            "profile" to profileJson
          ))
        } else {
          result.success(null)
        }
      }

      "addAccount" -> {
        val username = call.argument<String>("username")
        val accessToken = call.argument<String>("accessToken")
        val refreshToken = call.argument<String>("refreshToken")
        val profileJson = call.argument<String>("profile")

        if (username != null && accessToken != null) {
          val account = Account(username, ACCOUNT_TYPE)
          if (accountManager.addAccountExplicitly(account, accessToken, null)) {
            refreshToken?.let {
              accountManager.setUserData(account, "refreshToken", it)
            }
            profileJson?.let {
              accountManager.setUserData(account, "profile", it)
            }
            result.success(true)
          } else {
            result.error("ACCOUNT_ERROR", "Account exists or failed", null)
          }
        } else {
          result.error("ARGUMENT_ERROR", "Missing username or accessToken", null)
        }
      }


      "removeAccount" -> {
    val accounts = accountManager.getAccountsByType(ACCOUNT_TYPE)
    if (accounts.isNotEmpty()) {
        val account = accounts[0]
        val removed = if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1) {
            accountManager.removeAccountExplicitly(account)
        } else {
            @Suppress("DEPRECATION")
            accountManager.removeAccount(account, null, null)
            true
        }
        result.success(removed)
    } else {
        result.success(false)
    }
}

      

      else -> result.notImplemented()
    }
  }
}
