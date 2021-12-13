package com.audiobooks.audiobooks.explore.presentation

import androidx.compose.runtime.State
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.audiobooks.audiobooks.core.util.Resource
import com.audiobooks.audiobooks.explore.domain.use_case.GetFeed
import com.audiobooks.audiobooks.explore.domain.use_case.GetGenre
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch
import javax.inject.Inject

val genres = listOf("Fiction", "Non-fiction", "Fantasy", "Crime", "Poetry", "Romance",
                    "Sports", "History", "Humour", "Law")

@HiltViewModel
class ExploreViewModel @Inject constructor(
    private val getFeed: GetFeed,
    private val getGenre: GetGenre
) : ViewModel() {

    private val _state = mutableStateOf(ExploreState(genres[0]))
    val state: State<ExploreState> = _state;

    private val _eventFlow = MutableSharedFlow<UIEvent>()
    val eventFlow = _eventFlow.asSharedFlow()

    init {
        viewModelScope.launch {
            getFeed().onEach { result ->
                when (result) {
                    is Resource.Success -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = false
                        )
                    }

                    is Resource.Error -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = false
                        )

                        _eventFlow.emit(UIEvent.ShowSnackBar(
                            result.message ?: "Unknown error occurred"
                        ))
                    }

                    is Resource.Loading -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = true
                        )
                    }
                }
            }.launchIn(this)
        }
    }

    fun selectGenre(genre: String){
       _state.value = ExploreState(genre)
       getGenre(genre)
    }

    private fun getInGenre(genre: String){
        viewModelScope.launch {
            getGenre(genre).onEach { result ->
                when (result) {
                    is Resource.Success -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = false
                        )
                    }

                    is Resource.Error -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = false
                        )

                        _eventFlow.emit(
                            UIEvent.ShowSnackBar(
                                result.message ?: "Unknown error occurred"
                            )
                        )
                    }

                    is Resource.Loading -> {
                        _state.value = state.value.copy(
                            newReleases = result.data ?: emptyList(),
                            isLoading = true
                        )
                    }
                }
            }.launchIn(this)
        }
    }

    sealed class UIEvent {
        data class ShowSnackBar(val message: String): UIEvent()
    }
}