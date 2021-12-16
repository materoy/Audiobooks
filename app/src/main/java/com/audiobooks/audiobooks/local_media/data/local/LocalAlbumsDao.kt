package com.audiobooks.audiobooks.local_media.data.local

import androidx.room.*
import com.audiobooks.audiobooks.local_media.data.local.entity.LocalAlbumEntity

@Dao
interface LocalAlbumsDao {

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(album: LocalAlbumEntity)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertAll(albums: List<LocalAlbumEntity>)

    @Query("SELECT * FROM albums")
    suspend fun getAll(): List<LocalAlbumEntity>

    @Query("SELECT * FROM albums WHERE albumId IN (:albumId)")
    suspend fun getById(albumId: Long): LocalAlbumEntity

    @Delete
    suspend fun delete(albums: LocalAlbumEntity)
}