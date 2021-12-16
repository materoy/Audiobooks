package com.audiobooks.audiobooks.local_media.domain.model

import androidx.room.Entity
import androidx.room.ForeignKey
import androidx.room.ForeignKey.CASCADE
import androidx.room.PrimaryKey
import com.audiobooks.audiobooks.local_media.data.local.entity.LocalAlbumEntity

@Entity(
    tableName = "recent",
    foreignKeys = [
        ForeignKey(
            entity = LocalAlbumEntity::class,
            parentColumns = arrayOf("albumId"),
            childColumns = arrayOf("albumId"),
            onDelete = CASCADE
        )
    ]
)
data class Recent(
    val albumId: String,
    @PrimaryKey val rank : Int
)
