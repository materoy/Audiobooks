package com.audiobooks.audiobooks.core.data.remote.dto

import com.google.gson.annotations.SerializedName

data class Author(
    val dob: String,
    val dod: String,
    @SerializedName("first_name")
    val fistName: String,
    val id: String,
    @SerializedName("last_name")
    val lastName: String
)