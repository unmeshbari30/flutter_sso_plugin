package com.rpsmobile.flutter_sso_plugin.auth

import android.accounts.AbstractAccountAuthenticator
import android.accounts.AccountAuthenticatorResponse
import android.accounts.NetworkErrorException
import android.content.Context
import android.os.Bundle

class Authenticator(context: Context) : AbstractAccountAuthenticator(context) {
    override fun editProperties(response: AccountAuthenticatorResponse, accountType: String): Bundle {
        throw UnsupportedOperationException()
    }

    override fun addAccount(
        response: AccountAuthenticatorResponse,
        accountType: String,
        authTokenType: String?,
        requiredFeatures: Array<out String>?,
        options: Bundle?
    ): Bundle? {
        return null
    }

    override fun confirmCredentials(
        response: AccountAuthenticatorResponse,
        account: android.accounts.Account,
        options: Bundle?
    ): Bundle? {
        return null
    }

    override fun getAuthToken(
        response: AccountAuthenticatorResponse,
        account: android.accounts.Account,
        authTokenType: String,
        options: Bundle?
    ): Bundle {
        throw UnsupportedOperationException()
    }

    override fun getAuthTokenLabel(authTokenType: String): String {
        throw UnsupportedOperationException()
    }

    override fun updateCredentials(
        response: AccountAuthenticatorResponse,
        account: android.accounts.Account,
        authTokenType: String?,
        options: Bundle?
    ): Bundle? {
        return null
    }

    override fun hasFeatures(
        response: AccountAuthenticatorResponse,
        account: android.accounts.Account,
        features: Array<out String>
    ): Bundle {
        return Bundle().apply { putBoolean("booleanResult", false) }
    }
}
