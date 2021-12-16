package com.rmgennative.audiobooks.data.local

import androidx.room.Dao
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import com.audiobooks.audiobooks.local_media.data.local.entity.MediaFolderEntity

@Dao
interface MediaFoldersDao {

    @Query("SELECT * FROM MediaFolderEntity")
    suspend fun getAll() : List<MediaFolderEntity>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(mediaFolder: MediaFolderEntity)
}