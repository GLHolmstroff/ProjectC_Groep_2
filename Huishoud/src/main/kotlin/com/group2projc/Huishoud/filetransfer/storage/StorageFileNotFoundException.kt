package com.group2projc.Huishoud.filetransfer.storage

class StorageFileNotFoundException : StorageException {

    constructor(message: String) : super(message) {}

    constructor(message: String, cause: Throwable) : super(message, cause) {}
}