package ca.macewan.c496.nfc_mobile

import android.annotation.TargetApi
import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import androidx.annotation.NonNull

@TargetApi(23)
class MainActivity: FlutterActivity() {

    lateinit var fEngine: FlutterEngine;

    fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.d("Flutter MainActivity", "Configuring Flutter Engine")
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    private val channel: MethodChannel by lazy { MethodChannel(flutterView, "hce") }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("Flutter MainActivity", "Forwarding Intent: onCreate")
        //GeneratedPluginRegistrant.registerWith(fEngine)
        flutterView.addFirstFrameListener {
            if (intent.hasExtra("success")) {
                onHCEResult(intent)
            }
        }
    }

    override fun onNewIntent(intent: Intent?) {
        Log.d("Flutter MainActivity", "Loading Intent: onNewIntent")
        super.onNewIntent(intent)
        if (intent != null) {
            onHCEResult(intent)
        }
    }

    private fun onHCEResult(intent: Intent) = intent.getBooleanExtra("success", false).let { success ->
        Log.d("Flutter MainActivity", "Loading Intent: onHCEResult")
        channel.invokeMethod("onHCEResult", success)
    }

}