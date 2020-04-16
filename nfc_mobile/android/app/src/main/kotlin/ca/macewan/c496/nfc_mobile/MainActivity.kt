package ca.macewan.c496.nfc_mobile

import android.annotation.TargetApi
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

@TargetApi(23)
class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        Log.d("MainActivity", "Configuring Flutter Engine")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "hce").setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (intent.hasExtra("success")) {
                onHCEResult(intent)
            }
        }
    }

    private val channel: MethodChannel by lazy { MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, "hce") }

    override fun onCreate(savedInstanceState: Bundle?) {
        Log.d("MainActivity", "Registering Flutter Engine")
        super.onCreate(savedInstanceState)
        //GeneratedPluginRegistrant.registerWith(flutterEngine!!)
        if (intent.hasExtra("success")) {
            Log.d("MainActivity","Intent Success: onCreate")
            onHCEResult(intent)
        }
    }

    override fun onNewIntent(intent: Intent) {
        Log.d("MainActivity", "New Intent")
        super.onNewIntent(intent)
        if (intent.hasExtra("success")) {
            Log.d("MainActivity", "Intent Success: onNewIntent")
            onHCEResult(intent)
        }
    }

    private fun onHCEResult(intent: Intent) = intent.getBooleanExtra("success", false).let { success ->
        channel.invokeMethod("onHCEResult", success)
    }

}