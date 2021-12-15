package com.audiobooks.audiobooks.core.domain.model

import android.net.Uri

data class Media(
    val title: String,
    val author: String,
    val progress: Double,
    val imageUrl: String,
    val localImageUri: Uri,
)
