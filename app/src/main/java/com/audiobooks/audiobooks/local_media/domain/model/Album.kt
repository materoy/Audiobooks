package com.audiobooks.audiobooks.local_media.domain.model

import android.graphics.Bitmap
import android.os.Parcelable
import androidx.room.Entity
import androidx.room.PrimaryKey
import kotlinx.parcelize.Parcelize


@Parcelize
data class Album(
    val albumId : Long,
    val title: String,
    val duration: Long,
    val currentTrackIndex: Int,
    val coverageDuration: Long,
    val albumArt: Bitmap?
) : Parcelable
