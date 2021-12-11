package com.audiobooks.audiobooks.core.domain.model

data class Audiobook(
    val authors: List<Author>?,
    val copyrightYear: String?,
    val description: String,
    val id: String,
    val language: String,
    val numSections: Int,
    val title: String,
    val totalTime: String,
    val totalTimeSecs: Int,
    val urlLibrivox: String?,
    val urlOther: String?,
    val urlProject: String?,
    val urlRss: String?,
    val urlTextSource: String?,
    val urlZipFile: String
)
