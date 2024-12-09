package uz.yangi.app

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.scottyab.rootbeer.RootBeer

class MainActivity : FlutterActivity() {
    private val CHANNEL = "screen_protection"
    private val CHANNEL1 = "root_detection"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "enableSecure" -> {
                    window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE
                    )
                    result.success(null)
                }

                "disableSecure" -> {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }



        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL1
        ).setMethodCallHandler { call, result ->
            if (call.method == "isRooted") {
                val rootBeer = RootBeer(applicationContext)
                val isRooted = rootBeer.isRooted
                result.success(isRooted)
            } else {
                result.notImplemented()
            }
        }
    }
}
