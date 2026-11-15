package com.rajagull.learnenglishflutter

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.rajagull.learnenglishflutter/speech"
    private val REQ_RECORD_AUDIO = 1001
    private val REQ_SPEECH_INTENT = 1002

    private var methodChannel: MethodChannel? = null
    private var speechRecognizer: SpeechRecognizer? = null
    private var pendingPermissionResult: MethodChannel.Result? = null
    private var isListening = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "checkOrRequestPermission" -> {
                    if (hasAudioPermission()) {
                        result.success(true)
                    } else {
                        pendingPermissionResult = result
                        ActivityCompat.requestPermissions(
                            this,
                            arrayOf(Manifest.permission.RECORD_AUDIO),
                            REQ_RECORD_AUDIO
                        )
                    }
                }
                "startListening" -> {
                    val locale = call.argument<String>("locale") ?: "en-US"
                    val usePopup = call.argument<Boolean>("usePopup") ?: false
                    if (!hasAudioPermission()) {
                        result.error("PERMISSION_DENIED", "Microphone permission not granted", null)
                    } else {
                        startSpeechRecognition(locale, usePopup)
                        result.success(true)
                    }
                }
                "stopListening" -> {
                    stopSpeechRecognition()
                    result.success(true)
                }
                "cancelListening" -> {
                    cancelSpeechRecognition()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasAudioPermission(): Boolean {
        return ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.RECORD_AUDIO
        ) == PackageManager.PERMISSION_GRANTED
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQ_RECORD_AUDIO) {
            val granted = grantResults.isNotEmpty() &&
                grantResults[0] == PackageManager.PERMISSION_GRANTED
            pendingPermissionResult?.success(granted)
            pendingPermissionResult = null
        }
    }

    private fun startSpeechRecognition(locale: String, usePopup: Boolean) {
        runOnUiThread {
            try {
                if (usePopup || !SpeechRecognizer.isRecognitionAvailable(this)) {
                    launchSystemSpeechDialog(locale)
                    return@runOnUiThread
                }

                if (speechRecognizer == null) {
                    speechRecognizer = SpeechRecognizer.createSpeechRecognizer(this)
                    speechRecognizer?.setRecognitionListener(object : RecognitionListener {
                        override fun onReadyForSpeech(params: Bundle?) {
                            isListening = true
                            sendEvent(mapOf("type" to "status", "status" to "listening"))
                        }

                        override fun onBeginningOfSpeech() {
                            sendEvent(mapOf("type" to "status", "status" to "speaking"))
                        }

                        override fun onRmsChanged(rmsdB: Float) {
                            sendEvent(mapOf("type" to "rms", "rms" to rmsdB.toDouble()))
                        }

                        override fun onBufferReceived(buffer: ByteArray?) {}

                        override fun onEndOfSpeech() {
                            isListening = false
                            sendEvent(mapOf("type" to "status", "status" to "processing"))
                        }

                        override fun onError(error: Int) {
                            isListening = false
                            val msg = mapSpeechError(error)
                            sendEvent(
                                mapOf(
                                    "type" to "error",
                                    "errorCode" to error,
                                    "message" to msg
                                )
                            )
                        }

                        override fun onResults(results: Bundle?) {
                            isListening = false
                            val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                            val text = matches?.firstOrNull()?.trim() ?: ""
                            sendEvent(
                                mapOf(
                                    "type" to "result",
                                    "text" to text,
                                    "isFinal" to true
                                )
                            )
                        }

                        override fun onPartialResults(partialResults: Bundle?) {
                            val matches = partialResults?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
                            val text = matches?.firstOrNull()?.trim() ?: ""
                            if (text.isNotEmpty()) {
                                sendEvent(
                                    mapOf(
                                        "type" to "result",
                                        "text" to text,
                                        "isFinal" to false
                                    )
                                )
                            }
                        }

                        override fun onEvent(eventType: Int, params: Bundle?) {}
                    })
                } else if (isListening) {
                    speechRecognizer?.cancel()
                }

                val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                    putExtra(
                        RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                        RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
                    )
                    putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale)
                    putExtra(RecognizerIntent.EXTRA_PARTIAL_RESULTS, true)
                    putExtra(RecognizerIntent.EXTRA_MAX_RESULTS, 3)
                    putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_COMPLETE_SILENCE_LENGTH_MILLIS, 1800L)
                    putExtra(RecognizerIntent.EXTRA_SPEECH_INPUT_POSSIBLY_COMPLETE_SILENCE_LENGTH_MILLIS, 1500L)
                }

                speechRecognizer?.startListening(intent)
            } catch (e: Exception) {
                launchSystemSpeechDialog(locale)
            }
        }
    }

    private fun launchSystemSpeechDialog(locale: String) {
        try {
            val intent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
                putExtra(
                    RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                    RecognizerIntent.LANGUAGE_MODEL_FREE_FORM
                )
                putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale)
                putExtra(RecognizerIntent.EXTRA_PROMPT, "Speak in English to Emma (AI Coach)...")
            }
            sendEvent(mapOf("type" to "status", "status" to "listening"))
            startActivityForResult(intent, REQ_SPEECH_INTENT)
        } catch (e: Exception) {
            sendEvent(
                mapOf(
                    "type" to "error",
                    "errorCode" to -1,
                    "message" to "Speech recognition is not available on this device."
                )
            )
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQ_SPEECH_INTENT) {
            isListening = false
            if (resultCode == Activity.RESULT_OK && data != null) {
                val results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS)
                val text = results?.firstOrNull()?.trim() ?: ""
                sendEvent(
                    mapOf(
                        "type" to "result",
                        "text" to text,
                        "isFinal" to true
                    )
                )
            } else {
                sendEvent(mapOf("type" to "status", "status" to "idle"))
            }
        }
    }

    private fun stopSpeechRecognition() {
        runOnUiThread {
            try {
                isListening = false
                speechRecognizer?.stopListening()
            } catch (_: Exception) {}
        }
    }

    private fun cancelSpeechRecognition() {
        runOnUiThread {
            try {
                isListening = false
                speechRecognizer?.cancel()
            } catch (_: Exception) {}
        }
    }

    private fun sendEvent(payload: Map<String, Any>) {
        runOnUiThread {
            methodChannel?.invokeMethod("onSpeechEvent", payload)
        }
    }

    private fun mapSpeechError(error: Int): String {
        return when (error) {
            SpeechRecognizer.ERROR_AUDIO -> "Audio recording error"
            SpeechRecognizer.ERROR_CLIENT -> "Client side speech error"
            SpeechRecognizer.ERROR_INSUFFICIENT_PERMISSIONS -> "Microphone permission required"
            SpeechRecognizer.ERROR_NETWORK -> "Network error during speech recognition"
            SpeechRecognizer.ERROR_NETWORK_TIMEOUT -> "Network timeout"
            SpeechRecognizer.ERROR_NO_MATCH -> "Didn't catch that. Tap the mic and speak clearly."
            SpeechRecognizer.ERROR_RECOGNIZER_BUSY -> "Speech recognizer is busy"
            SpeechRecognizer.ERROR_SERVER -> "Speech server error"
            SpeechRecognizer.ERROR_SPEECH_TIMEOUT -> "No speech detected. Tap the mic to speak."
            else -> "Speech recognition error ($error)"
        }
    }

    override fun onDestroy() {
        runOnUiThread {
            try {
                speechRecognizer?.destroy()
                speechRecognizer = null
            } catch (_: Exception) {}
        }
        super.onDestroy()
    }
}
