package com.group2projc.Huishoud.filetransfer.storage

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.stereotype.Component

@ConfigurationProperties(prefix="storage")
class StorageProperties {

    /**
     * Folder location for storing files
     */
    var location = "upload-dir"

}
