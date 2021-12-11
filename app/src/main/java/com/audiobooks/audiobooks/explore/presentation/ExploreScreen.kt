package com.audiobooks.audiobooks.explore.presentation

import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.LazyRow
import androidx.compose.foundation.lazy.items
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel
import kotlinx.coroutines.flow.collectLatest
import androidx.compose.foundation.layout.Column


@Composable
fun HomeScreen() {
    val viewModel: ExploreViewModel = hiltViewModel()
    val state = viewModel.state.value
    val scaffoldState = rememberScaffoldState()

    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is ExploreViewModel.UIEvent.ShowSnackBar -> {
                    scaffoldState.snackbarHostState.showSnackbar(
                        message = event.message
                    )
                }
            }
        }
    }

    Scaffold(scaffoldState = scaffoldState) {
        Row(modifier = Modifier.fillMaxWidth()) {
            Text(text = "Hi, Harry")
            IconButton(onClick = { /*TODO*/ }) {
                Icon(imageVector = Icons.Default.Search, contentDescription = "search_button")
            }
        }

        GenresRow()

        LazyColumn(modifier = Modifier.fillMaxSize()) {
            items(state.feed) { item ->
                Text(item.title)
            }
        }
    }
}

@Composable
fun GenresRow() {
    LazyRow(modifier = Modifier.fillMaxWidth()) {
        items(genres) { genre ->
            Column(Modifier) {
                Text(text = genre)
                Divider()
            }
        }
    }
}