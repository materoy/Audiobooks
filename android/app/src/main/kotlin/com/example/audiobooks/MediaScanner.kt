package com.noysi.media_scanner_scan_file

import android.content.Context
import android.content.Intent
import android.media.MediaScannerConnection
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File
import java.util.*


class MediaScannerScanFilePlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var context: Context

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "media_scanner")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "scan") {
      val path: String? = call.argument("fileUri")
      result.success(scan(path))
    } else {
      result.notImplemented()
    }
  }

  private fun scan(path: String?): HashMap<String,Any?> {
    return try {
      if (path == null)
        throw NullPointerException()
      val file = File(path)
      if (android.os.Build.VERSION.SDK_INT < 29) {
        context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.fromFile(file)))
      } else {
        MediaScannerConnection.scanFile(context, arrayOf(file.toString()),
                arrayOf(file.name), null)
      }
      SaveResultModel(isSuccess = true, filePath = path, errorMessage = null).toHashMap()
    } catch (e: Exception) {
      SaveResultModel(isSuccess = false, filePath = null, errorMessage = e.toString()).toHashMap()
    }

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

class SaveResultModel (var isSuccess: Boolean,
                       var filePath: String? = null,
                       var errorMessage: String? = null) {
  fun toHashMap(): HashMap<String, Any?> {
    val hashMap = HashMap<String, Any?>()
    hashMap["isSuccess"] = isSuccess
    hashMap["filePath"] = filePath
    hashMap["errorMessage"] = errorMessage
    return hashMap
  }
}