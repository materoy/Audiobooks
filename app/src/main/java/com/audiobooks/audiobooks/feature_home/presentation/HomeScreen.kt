package com.audiobooks.audiobooks.feature_home.presentation

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.hilt.navigation.compose.hiltViewModel


@Composable
fun HomeScreen() {
    val viewModel: HomeViewModel = hiltViewModel()
    val state = viewModel.feed.value

    LazyColumn(modifier = Modifier.fillMaxSize()){
        items(state.feed) { item ->
            Text(item.title)
        }
    }
}