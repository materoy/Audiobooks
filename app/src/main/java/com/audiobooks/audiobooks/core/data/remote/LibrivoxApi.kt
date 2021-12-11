package com.audiobooks.audiobooks.core.data.remote

import com.audiobooks.audiobooks.core.data.remote.dto.LibrivoxAudiobookDto
import com.audiobooks.audiobooks.core.data.remote.dto.LibrivoxAudiobooksDto
import retrofit2.http.GET

interface LibrivoxApi {

    @GET("feed/audiobooks/format/json/")
    suspend fun getFeed(): LibrivoxAudiobooksDto

    @GET("feed/audiobooks/format/json/genre/^{genre}")
    suspend fun getGenre(genre: String): LibrivoxAudiobooksDto

    @GET("feed/audiobooks/format/json/title/^{title}")
    suspend fun getTitle(title: String): LibrivoxAudiobooksDto

    @GET("feed/audiobooks/format/json/author/^{author}")
    suspend fun getAuthor(author: String): LibrivoxAudiobooksDto

    companion object {
        const val BASE_URL = "https://librivox.org/api/"
    }
}