package com.audiobooks.audiobooks.local_media.data.local

import androidx.room.*
import com.audiobooks.audiobooks.local_media.data.local.entity.LocalAlbumDto

@Dao
interface LocalAlbumsDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(album: LocalAlbumDto)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(albums: List<LocalAlbumDto>)

    @Query("SELECT * FROM albums")
    suspend fun getAll(): List<LocalAlbumDto>

    @Query("SELECT * FROM albums WHERE albumId IN (:albumId)")
    suspend fun getById(albumId: Long): LocalAlbumDto

    @Delete
    suspend fun delete(albums: LocalAlbumDto)
}