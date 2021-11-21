package com.example.secure_bridges_app

import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService

class Application: FlutterApplication(), PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate()
        FlutterFirebaseMessagingService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        FirebaseCloudMessagingPluginRegistrant.registerWith(registry)
    }
}

class FirebaseCloudMessagingPluginRegistrant {
    companion object {
        fun registerWith(registry: PluginRegistry) {
            if (alreadyRegisteredWith(registry)) {
                return;
            }
            FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"))
        }

        private fun alreadyRegisteredWith(registry: PluginRegistry): Boolean {
            val key = FirebaseCloudMessagingPluginRegistrant::class.java.name
            if (registry.hasPlugin(key)) {
                return true
            }
            registry.registrarFor(key)
            return false
        }
    }
}