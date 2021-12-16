package com.audiobooks.audiobooks.local_media.data.local.entity

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.audiobooks.audiobooks.local_media.domain.model.Album

@Entity(tableName = "albums")
internal data class LocalAlbumEntity (
    @PrimaryKey val albumId : Long,
    val title: String,
    val duration: Long,
    val currentTrackIndex: Int,
    val coverageDuration: Long,
    val albumArt: ByteArray?
) {
    fun LocalAlbumEntity.toAlbum(): Album {
        var albumArtBitmap: Bitmap? = null
        if (albumArt != null) {
            val bmp: Bitmap = BitmapFactory.decodeByteArray(albumArt, 0, albumArt.size)
            albumArtBitmap = bmp.copy(Bitmap.Config.ARGB_8888, true)
        }
        return Album(
            albumId = albumId,
            title = title,
            duration = duration,
            currentTrackIndex = currentTrackIndex,
            coverageDuration = coverageDuration,
            albumArt = albumArtBitmap
        )
    }

    fun Album.toDto(): LocalAlbumEntity {
        return LocalAlbumEntity(
            albumId = albumId,
            title = title,
            duration = duration,
            currentTrackIndex = currentTrackIndex,
            coverageDuration = coverageDuration,
            albumArt = null
        )
    }
}

