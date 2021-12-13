package com.audiobooks.audiobooks.core.data.remote.dto

data class BookShelfDto(
    val author: String,
    val description: String,
    val id: Int,
    val imgUrl: String,
    val price: String,
    val review: String,
    val source: String,
    val title: String
)