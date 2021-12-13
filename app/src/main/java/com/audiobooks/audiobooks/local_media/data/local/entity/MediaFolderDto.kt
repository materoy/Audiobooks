package com.rmgennative.audiobooks.data.local.dto

import android.net.Uri
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity
data class MediaFolderDto(
    @PrimaryKey val path : String,
    val name: String
)
