package com.audiobooks.audiobooks.core.data.remote.dto

import com.audiobooks.audiobooks.core.domain.model.Author
import com.google.gson.annotations.SerializedName

data class LibrivoxAuthorDto(
    val dob: String,
    val dod: String,
    @SerializedName("first_name")
    val fistName: String,
    val id: String,
    @SerializedName("last_name")
    val lastName: String
) {
    fun toAuthor(): Author {
        return Author(
            fistName = fistName,
            lastName = lastName,
            id = id
        )
    }
}