package com.saoirse.epi

import android.net.Uri
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.saoirse.epi/fileprovider"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getUri") {
                val path = call.arguments as String
                val file = File(path)

                val uri: Uri = FileProvider.getUriForFile(
                    this,
                    "com.saoirse.epi.fileprovider", // ✅ FIX HERE
                    file
                )

                result.success(uri.toString())
            } else {
                result.notImplemented()
            }
        }
    }
}
