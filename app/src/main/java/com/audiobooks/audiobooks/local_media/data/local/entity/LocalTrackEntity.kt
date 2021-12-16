package com.rmgennative.audiobooks.data.local.dto

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.PrimaryKey
import com.audiobooks.audiobooks.local_media.data.local.entity.LocalAlbumEntity
import com.audiobooks.audiobooks.local_media.domain.model.Track

@Entity(
    tableName = "local_audiobooks",
    foreignKeys = [
        ForeignKey(
            entity = LocalAlbumEntity::class,
            parentColumns = arrayOf("albumId"),
            childColumns = arrayOf("albumId"),
            onDelete = ForeignKey.CASCADE
        )
    ]
)
data class LocalTrackEntity(
    @PrimaryKey val id: Long,
    val albumId : Long,
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
) {

    fun LocalTrackEntity.toTrack(): Track {
        return Track(
            id = id,
            albumId = albumId,
            album = album
        )
    }

    fun Track.toDto(): LocalTrackEntity {
        return LocalTrackEntity(
            id = id,
            albumId = albumId,
            album = album
        )
    }
}