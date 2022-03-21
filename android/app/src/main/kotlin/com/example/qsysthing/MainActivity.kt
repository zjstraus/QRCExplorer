package com.example.qsysthing

import android.content.Context
import android.net.wifi.WifiManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var mLock: WifiManager.MulticastLock? = null
    private val CHANNEL = "com.github/zjstraus/QRCExplorer/multicast"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // Note: this method is invoked on the main thread.
            call, result ->
            if (call.method == "enableMulticast") {
                val funResult = acquireMulticastLock()
                result.success(funResult)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun acquireMulticastLock(): Boolean {
        val wifi: WifiManager = getApplicationContext().getSystemService(Context.WIFI_SERVICE) as WifiManager
        this.mLock = wifi.createMulticastLock("discovery-multicast-lock")
        this.mLock?.acquire();
        return true;
    }
}
