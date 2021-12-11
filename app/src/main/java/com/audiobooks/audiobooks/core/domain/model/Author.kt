package com.audiobooks.audiobooks.core.domain.model

data class Author(
    val fistName: String,
    val id: String,
    val lastName: String,
    val imageUrl: String? = null
)
