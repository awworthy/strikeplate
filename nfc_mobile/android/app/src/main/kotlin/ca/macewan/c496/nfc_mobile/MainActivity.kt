package ca.macewan.c496.nfc_mobile

import android.annotation.TargetApi
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

@TargetApi(23)
class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        print("Configuring Flutter Engine")
        Log.d("TAG", "Configuring Flutter Engine")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    private val channel: MethodChannel by lazy { MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "hce") }

    override fun onCreate(savedInstanceState: Bundle?) {
        print("Loading MainActivity")
        Log.d("TAG", "Loading MainActivity in OnCreate")
        super.onCreate(savedInstanceState)
        // GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        if (intent.hasExtra("success")) {
            onHCEResult(intent)
        }

    }

    override fun onNewIntent(intent: Intent) {
        print("Loading Intent: onNewIntent")
        Log.d("TAG", "Loading Intent: onNewIntent")
        super.onNewIntent(intent)
        if (intent.hasExtra("success")) {
            onHCEResult(intent)
        }
    }

    private fun onHCEResult(intent: Intent) = intent.getBooleanExtra("success", false).let { success ->
        print("Loading Intent: onHCEResult")
        Log.d("TAG", "Loading Intent: onHCEResult")
        channel.invokeMethod("onHCEResult", success)
    }

}
