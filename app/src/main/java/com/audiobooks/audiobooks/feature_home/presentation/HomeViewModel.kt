package com.audiobooks.audiobooks.feature_home.presentation

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.feature_home.domain.use_case.GetFeed
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onCompletion
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import javax.inject.Inject


@HiltViewModel
class HomeViewModel @Inject constructor(
    private val getFeed: GetFeed
) : ViewModel() {

    private val _feed = mutableStateOf(FeedState())
    val feed: State<FeedState> = _feed;

    init {
        viewModelScope.launch {
            getFeed().onEach { result ->
                when (result) {
                    is Resource.Success -> {
                        _feed.value = feed.value.copy(
                            result.data ?: emptyList(),
                            isLoading = false
                        )
                    }

                    is Resource.Error -> {

                    }

                    is Resource.Loading -> {

                    }
                }
            }.launchIn(this)
        }
    }
}