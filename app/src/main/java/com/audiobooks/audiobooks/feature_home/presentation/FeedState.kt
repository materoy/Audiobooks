package com.audiobooks.audiobooks.feature_home.presentation

import com.audiobooks.audiobooks.core.domain.model.Audiobook

data class FeedState(
    val feed: List<Audiobook> = emptyList(),
    val isLoading: Boolean = false
)
