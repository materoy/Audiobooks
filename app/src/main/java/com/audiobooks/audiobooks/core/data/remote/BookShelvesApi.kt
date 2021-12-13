package com.audiobooks.audiobooks.core.data.remote

import com.audiobooks.audiobooks.core.data.remote.dto.BookShelvesBooksDto
import retrofit2.http.GET
import retrofit2.http.Headers


interface BookShelvesApi {

    @GET("books")
    @Headers("x-rapidapi-host: bookshelves.p.rapidapi.com",
             "x-rapidapi-key: a7cd7625eamsh3742058a38145acp1a6a6ejsn64d594cba35a"
    )
    suspend fun getBookMetadata(): BookShelvesBooksDto

    companion object {
        val BASE_URL = "https://bookshelves.p.rapidapi.com/"
        val API_KEY = "a7cd7625eamsh3742058a38145acp1a6a6ejsn64d594cba35a"
    }
}