package com.audiobooks.audiobooks.explore.presentation

import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Card
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.unit.dp
import com.audiobooks.audiobooks.core.domain.model.Audiobook
import com.audiobooks.audiobooks.core.domain.model.Author
import com.skydoves.landscapist.glide.GlideImage
import androidx.compose.foundation.layout.Column
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.foundation.layout.Row
import androidx.compose.ui.Alignment

@Composable
fun AudiobookCard(audiobook: Audiobook) {
    Box(Modifier.padding(horizontal = 8.dp, vertical = 10.dp)) {
        Card(
            modifier = Modifier
                .width(170.dp)
                .height(270.dp)
                .clip(RoundedCornerShape(15.dp))
        ) {
            val author: Author = audiobook.authors?.get(0) ?: Author("", "", "")

            Column(
                modifier = Modifier
                    .fillMaxSize()
            ) {
                GlideImage(
                    imageModel =
                    "https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1470082995l/29056083._SY475_.jpg",
                    contentScale = ContentScale.FillBounds,
                    modifier = Modifier
                        .fillMaxWidth()
                        .height(200.dp)
                        .clip(RoundedCornerShape(15.dp))
                )
                Column(Modifier.padding(10.dp)) {
                    Text(text = audiobook.title, overflow = TextOverflow.Ellipsis, maxLines = 1)
                    Spacer(modifier = Modifier.height(10.dp))
                    Row(
                        Modifier,
                        horizontalArrangement = Arrangement.SpaceBetween,
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Text(
                            text = "${author.fistName} ${author.lastName}",
                            style = MaterialTheme.typography.caption
                        )
                        Spacer(modifier = Modifier.width(10.dp))
                        Text(
                            text = "4.5 ⭐", style = MaterialTheme.typography.caption,
                            color = MaterialTheme.colors.primary
                        )
                    }
                }
            }
        }
    }
}

@Preview
@Composable
fun AudiobooksCardPreview() {
    MaterialTheme {
//        AudiobookCard(audiobook = Audiobook(
//            listOf(Author("J.k", "", "Rowling", null))))
    }
}