package com.audiobooks.audiobooks.core.data.remote.dto

import com.google.gson.annotations.SerializedName
import java.time.Year

data class LibrivoxAudiobookDto(
    val authors: List<Author>,
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
)