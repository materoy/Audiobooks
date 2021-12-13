package com.audiobooks.audiobooks.explore.presentation

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.*
import androidx.compose.material.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Search
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.hilt.navigation.compose.hiltViewModel
import kotlinx.coroutines.flow.collectLatest
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.ui.theme.AudiobooksTheme
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.material.icons.filled.ChevronRight


@OptIn(ExperimentalFoundationApi::class)
@Composable
fun ExploreScreen(
    scaffoldState: ScaffoldState? = null
) {
    val viewModel: ExploreViewModel = hiltViewModel()
    val state = viewModel.state.value

    LaunchedEffect(key1 = true) {
        viewModel.eventFlow.collectLatest { event ->
            when (event) {
                is ExploreViewModel.UIEvent.ShowSnackBar -> {
                    scaffoldState!!.snackbarHostState.showSnackbar(
                        message = event.message
                    )
                }
            }
        }
    }

    Scaffold(scaffoldState = scaffoldState!!) {
        Column(Modifier) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 20.dp)
                    .padding(top = 15.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    text = "Hi, Harry", style = MaterialTheme.typography.h5,
                    fontWeight = FontWeight.Bold
                )
                IconButton(onClick = { /*TODO*/ }) {
                    Icon(imageVector = Icons.Default.Search, contentDescription = "search_button")
                }
            }

            GenresRow(state.genre) { genre ->
                viewModel.selectGenre(genre)
            }

            LazyColumn(modifier = Modifier.padding(bottom = 50.dp)) {
                item {
                    ExploreSection("New releases", viewModel.state.value.newReleases)
                }
                item {
                    ExploreSection("Popular", viewModel.state.value.newReleases)
                }
                item {
                    ExploreSection("For you", viewModel.state.value.newReleases)
                }
                item {
                    ExploreSection("Authors", viewModel.state.value.authors)
                }
            }
        }
    }
}

@Composable
fun GenresRow(selectedGenre: String, onSelectGenre: (genre: String) -> Unit) {
    LazyRow(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 10.dp)
            .padding(start = 5.dp)
    ) {
        items(genres) { genre ->
            Column(
                Modifier
                    .padding(horizontal = 15.dp)
                    .clickable {
                        onSelectGenre(genre)
                    }) {
                Text(text = genre)
                if (selectedGenre == genre)
                    Divider(
                        Modifier
                            .height(2.dp)
                            .width(50.dp),
                        color = MaterialTheme.colors.primary
                    )
            }
        }
    }
}

@Composable
fun ExploreSection(title: String, audiobooks: List<Audiobook>) {
    Column(Modifier) {
        Row(
            Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Text(
                text = title,
                style = MaterialTheme.typography.h6,
                modifier = Modifier.padding(horizontal = 15.dp, vertical = 15.dp)
            )
            IconButton(onClick = { /*TODO*/ }) {
                Icon(imageVector = Icons.Default.ChevronRight, contentDescription = "go_to_section")
            }
        }
        LazyRow() {
            items(audiobooks) { item ->
                AudiobookCard(item)
            }
        }
    }
}

@Preview(showBackground = true, showSystemUi = true)
@Composable
fun ExploreScreenPreview() {
    AudiobooksTheme {
        ExploreScreen()
    }
}