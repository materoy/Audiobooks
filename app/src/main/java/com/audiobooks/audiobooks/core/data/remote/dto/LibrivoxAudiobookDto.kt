package com.audiobooks.audiobooks.core.data.remote.dto

import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.google.gson.annotations.SerializedName

data class LibrivoxAudiobookDto(
    val authors: List<LibrivoxAuthorDto>,
    @SerializedName("copyright_year")
    val copyrightYear: String,
    val description: String,
    val id: String,
    val language: String,
    @SerializedName("num_sections")
    val numSections: String,
    val title: String,
    @SerializedName("totaltime")
    val totalTime: String,
    @SerializedName("totaltimesecs")
    val totalTimeSecs: Int,
    @SerializedName("url_librivox")
    val urlLibrivox: String,
    @SerializedName("url_other")
    val urlOther: String,
    @SerializedName("url_project")
    val urlProject: String,
    @SerializedName("url_rss")
    val urlRss: String,
    @SerializedName("url_text_source")
    val urlTextSource: String,
    @SerializedName("url_zip_file")
    val urlZipFile: String
) {
    fun toAudiobook(): Audiobook{
        return Audiobook(
            authors = authors.map { it.toAuthor() },
            copyrightYear = copyrightYear,
        description = description,
        id = id,
        language = language,
        numSections = numSections.toInt(),
        title = title,
        totalTime = totalTime,
        totalTimeSecs = totalTimeSecs,
        urlLibrivox = urlLibrivox,
        urlOther = urlOther,
        urlProject = urlProject,
        urlRss = urlRss,
        urlTextSource = urlTextSource,
        urlZipFile= urlZipFile
        )
    }
}