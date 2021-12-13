package com.audiobooks.audiobooks.explore.presentation

import com.audiobooks.audiobooks.core.domain.model.Audiobook

data class ExploreState(
    val genre: String,
    val newReleases: List<Audiobook> = emptyList(),
    val forYou: List<Audiobook> = emptyList(),
    val popular: List<Audiobook> = emptyList(),
    val authors: List<Audiobook> = emptyList(),
    val isLoading: Boolean = false
)
