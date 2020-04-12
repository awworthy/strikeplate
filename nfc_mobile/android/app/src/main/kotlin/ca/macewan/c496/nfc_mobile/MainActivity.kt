package ca.macewan.c496.nfc_mobile

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    private val channel: MethodChannel by lazy { MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "hce") }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        if (intent.hasExtra("success")) {
            onHCEResult(intent)
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.hasExtra("success")) {
            onHCEResult(intent)
        }
    }

    private fun onHCEResult(intent: Intent) = intent.getBooleanExtra("success", false).let { success ->
        channel.invokeMethod("onHCEResult", success)
    }

}
