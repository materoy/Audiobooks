package com.audiobooks.audiobooks.explore.presentation

import com.audiobooks.audiobooks.core.domain.model.Audiobook

data class FeedState(
    val feed: List<Audiobook> = emptyList(),
    val isLoading: Boolean = false
)
