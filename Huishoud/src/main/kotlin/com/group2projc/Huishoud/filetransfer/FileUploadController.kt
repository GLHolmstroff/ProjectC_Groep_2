package com.group2projc.Huishoud.filetransfer
import com.group2projc.Huishoud.database.DatabaseHelper
import java.io.IOException
import java.util.stream.Collectors

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.core.io.Resource
import org.springframework.http.HttpHeaders
import org.springframework.http.ResponseEntity
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.ResponseBody
import org.springframework.web.multipart.MultipartFile
import org.springframework.web.servlet.mvc.method.annotation.MvcUriComponentsBuilder
import org.springframework.web.servlet.mvc.support.RedirectAttributes

import com.group2projc.Huishoud.filetransfer.storage.StorageFileNotFoundException
import com.group2projc.Huishoud.filetransfer.storage.StorageService
import com.group2projc.Huishoud.filetransfer.storage.StorageProperties
import org.springframework.boot.context.properties.EnableConfigurationProperties

@Controller
class FileUploadController @Autowired
constructor(private val storageService: StorageService) {

    @GetMapping("/files/readall")
    @Throws(IOException::class)
    fun listUploadedFiles(model: Model): String {

        model.addAttribute("files", storageService.loadAll().map(
                { path ->
                    MvcUriComponentsBuilder.fromMethodName(FileUploadController::class.java,
                            "serveFile", path.getFileName().toString()).build().toString()
                })
                .collect(Collectors.toList<Any>()))

        return "uploadForm"
    }

    @GetMapping("/files/{filename:.+}")
    @ResponseBody
    fun serveFile(@PathVariable filename: String): ResponseEntity<Resource> {

        val file = storageService.loadAsResource(filename)
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file)
    }

    @GetMapping("/files/users")
    @ResponseBody
    fun serveFileByUser(@RequestParam("uid",defaultValue= "TokenNotSet") uid: String): ResponseEntity<Resource> {

        val filename:String = DatabaseHelper("jdbc:postgresql://localhost:5432/postgres").getUser(uid)["picture_link"].toString()
        val file = storageService.loadAsResource(filename)
        return ResponseEntity.ok().header(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"" + file.getFilename() + "\"").body(file)
    }

    @PostMapping("/files/upload")
    fun handleFileUpload(@RequestParam("file") file: MultipartFile,
                         @RequestParam("uid" ,defaultValue = "TokenNotSet") uid: String,
                         redirectAttributes: RedirectAttributes): String {

        storageService.store(file,uid)
        redirectAttributes.addFlashAttribute("message",
                "You successfully uploaded " + file.originalFilename + "!")

        return "redirect:/files/readall"
    }

    @ExceptionHandler(StorageFileNotFoundException::class)
    fun handleStorageFileNotFound(exc: StorageFileNotFoundException): ResponseEntity<*> {
        return ResponseEntity.notFound().build<Any>()
    }

}
