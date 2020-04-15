package ca.macewan.c496.nfc_mobile

import android.annotation.TargetApi
import android.content.Intent
import android.content.SharedPreferences
import android.nfc.cardemulation.HostApduService
import android.os.Bundle
import android.preference.PreferenceManager
import android.util.Log

@TargetApi(23)
class HostCardEmulatorService : HostApduService() {

    companion object {
        val TAG = "Host Card Emulator"
        val STATUS_SUCCESS = "9000"
        val STATUS_FAILED = "6F00"
        val CLA_NOT_SUPPORTED = "6E00"
        val INS_NOT_SUPPORTED = "6D00"
        val AID = "F0001234567890"
        val SELECT_INS = "A4"
        val DEFAULT_CLA = "00"
        val MIN_APDU_LENGTH = 12
    }

    override fun onDeactivated(reason: Int) {
        Log.d(TAG, "Deactivated: $reason")
    }

    override fun processCommandApdu(commandApdu: ByteArray?, extras: Bundle?): ByteArray {
        print("Received Command...Processing...")

        if (commandApdu == null) {
            return Utils.hexStringToByteArray(STATUS_FAILED)
        }

        val hexCommandApdu = Utils.toHex(commandApdu)
        if (hexCommandApdu.length < MIN_APDU_LENGTH) {
            return Utils.hexStringToByteArray(STATUS_FAILED)
        }

        if (hexCommandApdu.substring(0, 2) != DEFAULT_CLA) {
            return Utils.hexStringToByteArray(CLA_NOT_SUPPORTED)
        }

        if (hexCommandApdu.substring(2, 4) != SELECT_INS) {
            return Utils.hexStringToByteArray(INS_NOT_SUPPORTED)
        }

        if (hexCommandApdu.substring(10, 24) == AID)  {
            val prefs: SharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)
            val response = prefs.getString("reader", "NULL")
            print("Reader preparing to broadcast: $response")
            if (!response.equals("NULL")) {
                forwardTheResult()
                return Utils.hexStringToByteArray(response!!)
            } else {
                return Utils.hexStringToByteArray(STATUS_FAILED)
            }
        } else {
            return Utils.hexStringToByteArray(STATUS_FAILED)
        }
    }

    private fun forwardTheResult(){
        print("Pushing result")
        Log.d(TAG, "Pushing Result")
        startActivity(
            Intent(this, MainActivity::class.java)
                .apply {
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    putExtra("success", true)
                }
        )
    }

}