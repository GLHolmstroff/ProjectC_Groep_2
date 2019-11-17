package com.group2projc.Huishoud.filetransfer.storage

import java.util.Random

import org.junit.Before
import org.junit.Test

import org.springframework.http.MediaType
import org.springframework.mock.web.MockMultipartFile

import org.assertj.core.api.Assertions.assertThat
import org.junit.After
import kotlin.math.abs

class FileSystemStorageServiceTests {

    private val properties = StorageProperties()
    private var service: FileSystemStorageService? = null

    @Before
    fun init() {
        properties.location = "target-test" + abs(Random().nextLong())
        service = FileSystemStorageService(properties)
        service!!.init()
    }

    @After
    fun destruct() {
        service!!.deleteAll()
    }

    @Test
    fun loadNonExistent() {
        print(properties.location)
        assertThat(service!!.load("foo.txt")).doesNotExist()
    }

    @Test
    fun saveAndLoad() {
        service!!.store(MockMultipartFile("foo", "foo.txt", MediaType.TEXT_PLAIN_VALUE,
                "Hello World".toByteArray()),"001")
        assertThat(service!!.load("foo.txt")).exists()
    }

    @Test(expected = StorageException::class)
    fun saveNotPermitted() {
        service!!.store(MockMultipartFile("foo", "../foo.txt",
                MediaType.TEXT_PLAIN_VALUE, "Hello World".toByteArray()),"001")
    }

    @Test
    fun savePermitted() {
        service!!.store(MockMultipartFile("foo", "bar/../foo.txt",
                MediaType.TEXT_PLAIN_VALUE, "Hello World".toByteArray()),"001")
    }

}
