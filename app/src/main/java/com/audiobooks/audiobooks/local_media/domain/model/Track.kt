package com.audiobooks.audiobooks.local_media.domain.model

import androidx.room.PrimaryKey


data class Track(
    @PrimaryKey val id: Long,
    val albumId: Long,
    val album: String,
//    val albumArt: Bitmap?,
//    val albumArtUri: Uri,
//    val art: Bitmap?,
//    val author: String,
//    val artist: String,
//    val discNumber: Int,
//    val duration: Long,
//    val genre: String,
//    val uri: Uri,
//    val numTracks: Int,
//    val rating: Rating?,
//    val title: String,
//    val userRating: Rating?,
//    val year: Long,
)
