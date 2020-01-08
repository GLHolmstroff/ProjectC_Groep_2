package com.group2projc.Huishoud.filetransfer.storage

import com.group2projc.Huishoud.database.DatabaseHelper
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.core.io.Resource
import org.springframework.core.io.UrlResource
import org.springframework.stereotype.Service
import org.springframework.util.FileSystemUtils
import org.springframework.web.multipart.MultipartFile

import java.io.IOException
import java.net.MalformedURLException
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.stream.Stream

@Service
class FileSystemStorageService @Autowired
constructor(@Qualifier("storageProperties") properties: StorageProperties) : StorageService {

    private val rootLocation: Path

    init {
        this.rootLocation = Paths.get(properties.location)
    }
    //Store a file in upload-dir
    override fun store(file: MultipartFile, uid:String) {
        try {
            if (file.isEmpty) {
                throw StorageException("Failed to store empty file " + file.originalFilename!!)
            }
            Files.copy(file.inputStream, this.rootLocation.resolve(file.originalFilename!!))
            val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                    .userUpdatePicture(uid,(file.originalFilename!!).toString())
        } catch (e: IOException) {
            throw StorageException("Failed to store file " + file.originalFilename!!, e)
        }

    }
    //Store a file corresponding to a task in upload-dir
    override fun storeTask(file: MultipartFile, taskid:Int) {
        try {
            if (file.isEmpty) {
                throw StorageException("Failed to store empty file " + file.originalFilename!!)
            }
            Files.copy(file.inputStream, this.rootLocation.resolve(file.originalFilename!!))
            val dbHelper = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres")
                    .updateTaskPicture(taskid,(file.originalFilename!!).toString())
        } catch (e: IOException) {
            throw StorageException("Failed to store file " + file.originalFilename!!, e)
        }

    }

    //Return a list of all stored filenames
    override fun loadAll(): Stream<Path> {
        try {
            return Files.walk(this.rootLocation, 1)
                    .filter { path -> path != this.rootLocation }
                    .map { path -> this.rootLocation.relativize(path) }
        } catch (e: IOException) {
            throw StorageException("Failed to read stored files", e)
        }

    }

    //Return a file location
    override fun load(filename: String): Path {
        return rootLocation.resolve(filename)
    }

    //Return a file
    override fun loadAsResource(filename: String): Resource {
        try {
            val file = load(filename)
            val resource = UrlResource(file.toUri())
            return if (resource.exists() || resource.isReadable) {
                resource
            } else {
                throw StorageFileNotFoundException("Could not read file: $filename")

            }
        } catch (e: MalformedURLException) {
            throw StorageFileNotFoundException("Could not read file: $filename", e)
        }

    }

    //Remove a file
    override fun deleteAll() {
        FileSystemUtils.deleteRecursively(rootLocation.toFile())
    }

    //Initialize storage directory
    override fun init() {
        try {
            Files.createDirectory(rootLocation)
        } catch (e: IOException) {
            throw StorageException("Could not initialize storage", e)
        }

    }
}
