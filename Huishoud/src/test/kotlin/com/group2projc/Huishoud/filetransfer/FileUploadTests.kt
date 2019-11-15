package com.group2projc.Huishoud.filetransfer

import java.nio.file.Paths
import java.util.stream.Stream

import com.group2projc.Huishoud.filetransfer.storage.StorageFileNotFoundException
import com.group2projc.Huishoud.filetransfer.storage.StorageService
import org.hamcrest.Matchers
import org.junit.Test
import org.junit.runner.RunWith

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.boot.test.mock.mockito.MockBean
import org.springframework.mock.web.MockMultipartFile
import org.springframework.test.context.junit4.SpringRunner
import org.springframework.test.web.servlet.MockMvc

import org.mockito.BDDMockito.given
import org.mockito.BDDMockito.then
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.fileUpload
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.header
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.model
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.status

import org.springframework.core.io.Resource
import java.nio.file.Path

@RunWith(SpringRunner::class)
@AutoConfigureMockMvc
@SpringBootTest
class FileUploadTests {

    @Autowired
    private val mvc: MockMvc? = null

    @MockBean
    private val storageService: StorageService? = null

    @Test
    @Throws(Exception::class)
    fun shouldListAllFiles() {
        given<Stream<Path>>(this.storageService!!.loadAll())
                .willReturn(Stream.of<Path>(Paths.get("first.txt"), Paths.get("second.txt")))

        this.mvc!!.perform(get("/")).andExpect(status().isOk)
                .andExpect(model().attribute("files",
                        Matchers.contains("http://localhost/files/first.txt",
                                "http://localhost/files/second.txt")))
    }

    @Test
    @Throws(Exception::class)
    fun shouldSaveUploadedFile() {
        val multipartFile = MockMultipartFile("file", "test.txt",
                "text/plain", "Spring Framework".toByteArray())
        this.mvc!!.perform(fileUpload("/").file(multipartFile))
                .andExpect(status().isFound)
                .andExpect(header().string("Location", "/"))

        then<StorageService>(this.storageService).should().store(multipartFile)
    }

    @Test
    @Throws(Exception::class)
    fun should404WhenMissingFile() {
        given<Resource>(this.storageService!!.loadAsResource("test.txt"))
                .willThrow(StorageFileNotFoundException::class.java)

        this.mvc!!.perform(get("/files/test.txt")).andExpect(status().isNotFound)
    }

}
