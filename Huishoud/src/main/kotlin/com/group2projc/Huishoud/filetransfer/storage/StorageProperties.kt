package com.group2projc.Huishoud.filetransfer.storage

import org.springframework.boot.context.properties.ConfigurationProperties


@ConfigurationProperties("storage")
class StorageProperties {

    /**
     * Folder location for storing files
     */
    var location = "upload-dir"

}
