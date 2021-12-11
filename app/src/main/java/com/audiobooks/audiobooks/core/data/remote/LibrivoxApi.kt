package com.audiobooks.audiobooks.core.data.remote

import com.audiobooks.audiobooks.core.data.remote.dto.LibrivoxAudiobookDto
import retrofit2.http.GET

interface LibrivoxApi {
    @GET("/feed/audiobooks")
    suspend fun getFeed(): List<LibrivoxAudiobookDto>

    companion object {
        const val BASE_URL = "https://librivox.org/api/"
    }
}