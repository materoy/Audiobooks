package com.audiobooks.audiobooks.library.presentation

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.audiobooks.audiobooks.ui.theme.AudiobooksTheme
import androidx.compose.ui.Alignment
import androidx.compose.foundation.layout.Box
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color

data class SegmentedControlItem(
    val title: String,
)

@Composable
fun SegmentedControl(
    items: List<SegmentedControlItem>,
    selected: Int,
    modifier: Modifier = Modifier,
    onSelectItem: (String) -> Unit
) {
    Box(
        modifier = modifier
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .align(Alignment.Center)
                .clip(shape = RoundedCornerShape(25.dp))
                .background(MaterialTheme.colors.primary.copy(alpha = .4f))
            ,
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            items.forEachIndexed { index, segmentedControlItem ->
                if (index != selected) {
                    SegmentedControlText(title = segmentedControlItem.title)
                } else {
                    Box(
                        Modifier
                            .width(IntrinsicSize.Max)
                            .clip(RoundedCornerShape(25.dp))
                            .background(MaterialTheme.colors.primary)
                    ) {
                        SegmentedControlText(title = segmentedControlItem.title)
                    }
                }

            }
        }
    }
}

@Composable
fun SegmentedControlText(title: String) {
    Text(
        text = title,
        modifier = Modifier.padding(horizontal = 30.dp, vertical = 10.dp),
        style = MaterialTheme.typography.h6,
        color = Color.White
    )
}

@Preview(showBackground = true, showSystemUi = true)
@Composable
fun SegmentedControlPreview() {
    AudiobooksTheme(darkTheme = true) {
        SegmentedControl(
            items = listOf(
                SegmentedControlItem("Book"),
                SegmentedControlItem("Podcast"),
                SegmentedControlItem("Local"),
            ),
            selected = 2,
        ) {}
    }
}