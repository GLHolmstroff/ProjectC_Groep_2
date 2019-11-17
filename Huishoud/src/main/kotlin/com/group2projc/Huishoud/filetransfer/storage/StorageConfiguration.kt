package com.group2projc.Huishoud.filetransfer.storage

import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
@EnableConfigurationProperties(StorageProperties::class)
class StorageConfiguration {

    @Bean
    fun storageProperties():StorageProperties {
        return StorageProperties()
    }
}